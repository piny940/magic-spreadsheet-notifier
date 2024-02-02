package controllers

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

type slackController struct{}

func NewSlackController() *slackController {
	return &slackController{}
}

func (sc *slackController) NewSlack(c echo.Context) error {
	return c.String(http.StatusOK, "Hello, World!")
}
