package storage

import (
	"bytes"
	"context"
	"fmt"
	"image"
	"image/jpeg"
	"io"
	"strings"
	"sync"

	"github.com/minio/minio-go/v7"
	"github.com/nfnt/resize"
	"github.com/sirupsen/logrus"
)

const (
	ThumbnailPrefix = ".cache"
	ThumbnailSize   = 512
)

// func cpuProfile() *os.File {
// 	fc, err := os.Create("cpuprofile")
// 	if err != nil {
// 		log.Fatal("could not create CPU profile: ", err)
// 	}
// 	defer fc.Close() // error handling omitted for example
// 	if err := pprof.StartCPUProfile(fc); err != nil {
// 		log.Fatal("could not start CPU profile: ", err)
// 	}

// 	return fc
// }

// func memProfile(runGC bool) *os.File {
// 	fm, err := os.Create("memprofile")
// 	if err != nil {
// 		log.Fatal("could not create memory profile: ", err)
// 	}

// 	if runGC {
// 		runtime.GC() // get up-to-date statistics
// 	}

// 	if err := pprof.WriteHeapProfile(fm); err != nil {
// 		log.Fatal("could not write memory profile: ", err)
// 	}

// 	return fm
// }

func GenerateAllThumbnails(numberOfWorkers int) error {
	// fc := cpuProfile()
	// defer fc.Close()
	// defer pprof.StopCPUProfile()
	minioClient, err := MinioClientFromEnv()
	if err != nil {
		return err
	}

	ctx := context.Background()

	objects := minioClient.ListObjects(ctx, BucketNameFromEnv(), minio.ListObjectsOptions{
		Prefix:    "",
		Recursive: true,
	})

	wg := new(sync.WaitGroup)

	for i := 0; i < numberOfWorkers; i++ {
		wg.Add(1)

		go worker(i, wg, minioClient, objects)
	}

	wg.Wait()

	// fm := memProfile(false)
	// defer fm.Close()

	return nil
}

func worker(id int, wg *sync.WaitGroup, minioClient *minio.Client, queue <-chan minio.ObjectInfo) {
	for current := range queue {
		if strings.HasPrefix(current.Key, ThumbnailPrefix) {
			continue
		}

		ctx := context.Background()
		path := current.Key
		thumbnailPath := fmt.Sprintf("%s/%s", ThumbnailPrefix, path)

		object, err := minioClient.GetObject(ctx, BucketNameFromEnv(), thumbnailPath, minio.GetObjectOptions{})
		if err != nil {
			continue
		}

		stat, err := object.Stat()
		if err == nil {
			logrus.Debugf("[skip] <%d> %s", id, stat.Key)

			continue
		}

		object.Close()

		_, stat = ThumbnailOrOriginal(ctx, minioClient, path, thumbnailPath)

		logrus.Debugf("[done] <%d> %s", id, stat.Key)
	}

	logrus.Debugf("<%d> I'm done")

	wg.Done()
}

func ThumbnailOrOriginal(ctx context.Context, minioClient *minio.Client, path, thumbnailPath string) (*minio.Object, minio.ObjectInfo) {
	original, err := minioClient.GetObject(ctx, BucketNameFromEnv(), path, minio.GetObjectOptions{})
	if err != nil {
		return nil, minio.ObjectInfo{}
	}

	stat, err := original.Stat()
	if err != nil {
		return original, minio.ObjectInfo{}
	}

	thumb, size := generateThumbnail(original)
	if thumb == nil {
		return original, stat
	}

	_, err = minioClient.PutObject(ctx, BucketNameFromEnv(), thumbnailPath, thumb, size, minio.PutObjectOptions{
		ContentType: "image/jpeg",
	})
	if err != nil {
		return original, stat
	}

	thumbnailObject, err := minioClient.GetObject(ctx, BucketNameFromEnv(), thumbnailPath, minio.GetObjectOptions{})
	if err != nil {
		return original, stat
	}

	stat, _ = thumbnailObject.Stat()

	return thumbnailObject, stat
}

func generateThumbnail(content io.Reader) (io.Reader, int64) {
	originalImage, _, err := image.Decode(content)
	if err != nil {
		return nil, 0
	}

	newImage := resize.Thumbnail(ThumbnailSize, ThumbnailSize, originalImage, resize.NearestNeighbor)

	var b bytes.Buffer

	err = jpeg.Encode(&b, newImage, nil)
	if err != nil {
		return nil, 0
	}

	return &b, int64(b.Len())
}
