package storage

import (
	"os"

	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

type MinoiClientOptions struct {
	Endpoint        string
	AccessKeyID     string
	SecretAccessKey string
	UseSSL          bool
}

func NewMinioClient(options MinoiClientOptions) (*minio.Client, error) {
	return minio.New(options.Endpoint, &minio.Options{
		Creds:  credentials.NewStaticV4(options.AccessKeyID, options.SecretAccessKey, ""),
		Secure: options.UseSSL,
	})
}

func MinioClientFromEnv() (*minio.Client, error) {
	return NewMinioClient(MinoiClientOptions{
		Endpoint:        os.Getenv("FULLA_ENDPOINT"),
		AccessKeyID:     os.Getenv("FULLA_ACCESS_KEY_ID"),
		SecretAccessKey: os.Getenv("FULLA_SECRET_ACCESS_KEY"),
		UseSSL:          os.Getenv("FULLA_NOSSL") == "",
	})
}

func BucketNameFromEnv() string {
	return os.Getenv("FULLA_BUCKET")
}
