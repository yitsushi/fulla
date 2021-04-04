package api

import (
	"context"
	"fmt"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/minio/minio-go/v7"

	"gitea.code-infection.com/efertone/fulla/storage"
)

const (
	fileType   = "file"
	folderType = "folder"
)

type listResponseItem struct {
	Key  string
	Type string
	MIME string
}

func listObjects(c *fiber.Ctx) error {
	minioClient, err := storage.MinioClientFromEnv()
	if err != nil {
		return err
	}

	path := c.Params("*")
	if path != "" {
		path = fmt.Sprintf("%s/", path)
	}

	response := []listResponseItem{}
	objectsChan := minioClient.ListObjects(c.Context(), storage.BucketNameFromEnv(), minio.ListObjectsOptions{
		Prefix:       path,
		WithMetadata: true,
	})

	for object := range objectsChan {
		if object.Key == ".cache/" {
			continue
		}

		item := listResponseItem{
			Key:  object.Key,
			Type: fileType,
			MIME: object.ContentType,
		}

		if strings.HasSuffix(object.Key, "/") {
			item.Type = folderType
		}

		if item.MIME == "" && item.Type == fileType {
			item.MIME = getObjectMime(c.Context(), minioClient, object.Key)
		}

		response = append(response, item)
	}

	return c.JSON(response)
}

func getObjectMime(ctx context.Context, minioClient *minio.Client, path string) string {
	object, err := minioClient.GetObject(ctx, storage.BucketNameFromEnv(), path, minio.GetObjectOptions{})
	if err != nil {
		return ""
	}

	objectInfo, _ := object.Stat()

	return objectInfo.ContentType
}
