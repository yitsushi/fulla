package api

import (
	"github.com/gofiber/fiber/v2"
	"github.com/minio/minio-go/v7"

	"gitea.code-infection.com/efertone/fulla/storage"
)

func getObject(c *fiber.Ctx) error {
	minioClient, err := storage.MinioClientFromEnv()
	if err != nil {
		return err
	}

	path := c.Params("*")

	object, err := minioClient.GetObject(c.Context(), storage.BucketNameFromEnv(), path, minio.GetObjectOptions{})
	if err != nil {
		return err
	}

	objectInfo, _ := object.Stat()

	c.Context().SetContentType(objectInfo.ContentType)

	return c.SendStream(object)
}
