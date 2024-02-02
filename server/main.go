package main

import (
	"flag"
	"fmt"
	"os"
	"server/controllers"

	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	env := flag.String("e", "development", "set environment")
	flag.Parse()
	loadDotenv(*env)
	e := echo.New()
	slack := e.Group("/slacks")
	{
		sc := controllers.NewSlackController()
		slack.GET("/new", sc.NewSlack)
	}

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.Logger.Fatal(e.Start(":" + os.Getenv("SERVER_PORT")))
}

func loadDotenv(env string) {
	if env != "production" {
		if err := godotenv.Load(fmt.Sprintf(".env.%s", env)); err != nil {
			panic(err)
		}
	}
}
