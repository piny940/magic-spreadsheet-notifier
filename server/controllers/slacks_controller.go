package controllers

import (
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"

	"github.com/labstack/echo/v4"
)

type slackController struct{}

func NewSlackController() *slackController {
	return &slackController{}
}

func (sc *slackController) NewSlack(c echo.Context) error {
	url := fmt.Sprintf(
		"https://slack.com/oauth/v2/authorize?scope=channels:read,chat:write&client_id=%s&redirect_uri=%s/slacks/callback",
		os.Getenv("SLACK_CLIENT_ID"),
		os.Getenv("SERVER_HOST"),
	)
	return c.Render(http.StatusOK, "slacks/new", url)
}

func (sc *slackController) Callback(c echo.Context) error {
	code := c.QueryParam("code")
	fmt.Println("code: ", code)
	data := url.Values{
		"code":          {code},
		"client_id":     {os.Getenv("SLACK_CLIENT_ID")},
		"client_secret": {os.Getenv("SLACK_CLIENT_SECRET")},
	}
	res, err := http.PostForm("https://slack.com/api/oauth.v2.access", data)
	if err != nil {
		fmt.Println(err)
		return c.String(http.StatusBadRequest, "Failed to get access token")
	}
	defer res.Body.Close()
	b, err := io.ReadAll(res.Body)
	fmt.Println(string(b))
	return c.String(http.StatusOK, "Success!")
}
