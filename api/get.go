package api

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
	"github.com/minio/minio-go/v7"

	_ "image/jpeg"
	_ "image/png"

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
	c.Context().Response.Header.Add("Cache-Control", "private")

	return c.SendStream(object)
}

func getThumbnail(c *fiber.Ctx) error {
	minioClient, err := storage.MinioClientFromEnv()
	if err != nil {
		return err
	}

	ctx := c.Context()

	path := c.Params("*")
	thumbnailPath := fmt.Sprintf("%s/%s", storage.ThumbnailPrefix, path)

	object, err := minioClient.GetObject(ctx, storage.BucketNameFromEnv(), thumbnailPath, minio.GetObjectOptions{})
	if err != nil {
		return err
	}

	var objectInfo minio.ObjectInfo

	objectInfo, err = object.Stat()
	if err != nil {
		object, objectInfo = storage.ThumbnailOrOriginal(ctx, minioClient, path, thumbnailPath)
	}

	c.Context().SetContentType(objectInfo.ContentType)
	c.Context().Response.Header.Add("Cache-Control", "private")

	return c.SendStream(object)
}
