package controllers

import (
	"fmt"
	"net/http"
	"os"
	"server/utils"

	"github.com/labstack/echo/v4"
	"github.com/slack-go/slack"
)

type slackController struct{ RedirectTo string }

func NewSlackController() *slackController {
	return &slackController{
		RedirectTo: fmt.Sprintf("%s/slacks/callback", os.Getenv("SERVER_HOST")),
	}
}

func (sc *slackController) NewSlack(c echo.Context) error {
	url := fmt.Sprintf(
		"https://slack.com/oauth/v2/authorize?scope=channels:read,chat:write&client_id=%s&redirect_uri=%s",
		os.Getenv("SLACK_CLIENT_ID"),
		sc.RedirectTo,
	)
	return c.Render(http.StatusOK, "slacks/new", url)
}

func (sc *slackController) Callback(c echo.Context) error {
	code := c.QueryParam("code")
	fmt.Println("code: ", code)
	oauthRes, err := slack.GetOAuthV2ResponseContext(
		c.Request().Context(),
		new(http.Client),
		os.Getenv("SLACK_CLIENT_ID"),
		os.Getenv("SLACK_CLIENT_SECRET"),
		code,
		sc.RedirectTo,
	)
	if err != nil {
		fmt.Println(err)
		return c.Render(http.StatusBadRequest, "slacks/success", "Failed to get access token")
	}

	firestore, err := utils.GetFirestore(c.Request().Context())
	if err != nil {
		fmt.Println(err)
		return c.Render(http.StatusBadRequest, "slacks/success", "Failed to store access token")
	}
	_, err = firestore.Collection("slack_teams").Doc(oauthRes.Team.ID).Set(c.Request().Context(), map[string]interface{}{
		"name":          oauthRes.Team.Name,
		"access_token":  oauthRes.AccessToken,
		"scope":         oauthRes.Scope,
		"refresh_token": oauthRes.RefreshToken,
		"expires_in":    oauthRes.ExpiresIn,
	})
	if err != nil {
		fmt.Println(err)
		return c.Render(http.StatusBadRequest, "slacks/success", "Failed to store access token")
	}

	return c.Render(http.StatusOK, "slacks/success", "Success!")
}
