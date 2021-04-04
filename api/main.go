package api

import "github.com/gofiber/fiber/v2"

func Entrypoint(router fiber.Router) {
	router.Get("/", root)
	router.Get("/ping", ping)

	router.Get("/list/*", checkAuth, listObjects)
	router.Get("/get/*", checkAuth, getObject)
	router.Get("/thumbnail/*", checkAuth, getThumbnail)
	router.Post("/login", login)

	router.Get("*", root)
}

func root(c *fiber.Ctx) error {
	return c.SendString("What the hell are you doint?")
}

func ping(c *fiber.Ctx) error {
	return c.SendString("pong")
}
