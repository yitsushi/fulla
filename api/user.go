package api

import (
	"os"
	"time"

	"gitea.code-infection.com/efertone/go-jwt"
	"github.com/gofiber/fiber/v2"
)

const (
	sessionDuration = 8
)

type loginRequest struct {
	Username string
	Token    string
}

type loginResponse struct {
	Token string
	Error string
}

type userData struct {
	Name string
}

func newUserData(name string) userData {
	return userData{Name: name}
}

func secret() string {
	return os.Getenv("FULLA_LOGIN_SECRET")
}

func login(c *fiber.Ctx) error {
	var request loginRequest

	expectedToken := secret()
	response := loginResponse{}

	err := c.BodyParser(&request)
	if err != nil {
		response.Error = err.Error()

		return c.JSON(response)
	}

	if request.Token != expectedToken {
		response.Error = "invalid token"

		return c.JSON(response)
	}

	exiresIn := time.Hour * sessionDuration
	payload := jwt.NewPayload(newUserData(request.Username), "Fulla", "", &exiresIn)
	token, err := jwt.Encode(jwt.NewHeader(), payload, []byte(expectedToken))
	response.Token = token

	if err != nil {
		response.Error = err.Error()
	}

	return c.JSON(response)
}

func checkAuth(c *fiber.Ctx) error {
	_, _, err := jwt.Validate(c.Get("JWT-Token"), []byte(secret()), "", userData{})
	if err != nil {
		return err
	}

	return c.Next()
}
