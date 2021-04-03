package server

import (
	"crypto/sha512"
	"embed"
	"encoding/base64"
	"io/fs"
	"net/http"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/compress"
	"github.com/gofiber/fiber/v2/middleware/filesystem"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/requestid"
	"github.com/google/uuid"
	"github.com/sirupsen/logrus"

	"gitea.code-infection.com/efertone/fulla/api"
)

//go:embed index.html
var indexHtml embed.FS

//go:embed static/*
var staticFiles embed.FS

func Serve(listen string) error {
	app := fiber.New()

	if os.Getenv("FULLA_LOGIN_SECRET") == "" {
		logrus.Error("FULLA_LOGIN_SECRET is not defined!")

		generatedSecret := generateRandomSecret()

		os.Setenv("FULLA_LOGIN_SECRET", generatedSecret)
		logrus.Errorf("Generated FULLA_LOGIN_SECRET is '%s'", generatedSecret)
	}

	// app.Use(csrf.New())
	app.Use(requestid.New())
	app.Use(compress.New())
	app.Use(logger.New(logger.Config{
		Format: "[${time}] <${locals:requestid}> ${status} - ${latency} ${method} ${path}\n",
	}))

	api.Entrypoint(app.Group("/api"))

	subFS, _ := fs.Sub(staticFiles, "static")

	app.Use("/static", filesystem.New(filesystem.Config{
		Root:   http.FS(subFS),
		Browse: true,
	}))

	app.Use("*", filesystem.New(filesystem.Config{
		Root:         http.FS(indexHtml),
		Index:        "index.html",
		NotFoundFile: "index.html",
	}))

	return app.Listen(listen)
}

func generateRandomSecret() string {
	randomUUID := uuid.Must(uuid.NewRandom()).String()
	hash := sha512.New()

	hash.Write([]byte(randomUUID))

	return base64.URLEncoding.EncodeToString(hash.Sum(nil))
}
