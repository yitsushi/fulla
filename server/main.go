package server

import (
	"embed"
	"io/fs"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/compress"
	"github.com/gofiber/fiber/v2/middleware/csrf"
	"github.com/gofiber/fiber/v2/middleware/filesystem"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/requestid"

	"gitea.code-infection.com/efertone/fulla/api"
)

//go:embed index.html
var indexHtml embed.FS

//go:embed static/*
var staticFiles embed.FS

func Serve(listen string) error {
	app := fiber.New()

	app.Use(csrf.New())
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
