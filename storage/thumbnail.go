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
	numberOfWorkers = 5
)

func GenerateAllThumbnails() error {
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
			logrus.Infof("[skip] <%d> %s", id, stat.Key)

			continue
		}

		_, stat = ThumbnailOrOriginal(ctx, minioClient, path, thumbnailPath)

		logrus.Infof("[done] <%d> %s", id, stat.Key)
	}

	logrus.Info("Done")

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

	thumb := generateThumbnail(original)
	if thumb == nil {
		return original, stat
	}

	_, err = minioClient.PutObject(ctx, BucketNameFromEnv(), thumbnailPath, thumb, -1, minio.PutObjectOptions{})
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

func generateThumbnail(content io.Reader) io.Reader {
	originalImage, _, err := image.Decode(content)
	if err != nil {
		return nil
	}

	newImage := resize.Thumbnail(ThumbnailSize, ThumbnailSize, originalImage, resize.Lanczos3)

	var b bytes.Buffer

	err = jpeg.Encode(&b, newImage, nil)
	if err != nil {
		return nil
	}

	return &b
}
