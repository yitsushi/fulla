package api

import (
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
		Prefix: path,
	})

	for object := range objectsChan {
		item := listResponseItem{
			Key:  object.Key,
			Type: fileType,
		}

		if strings.HasSuffix(object.Key, "/") {
			item.Type = folderType
		}

		response = append(response, item)
	}

	return c.JSON(response)
}
