package main

import (
	"flag"
	"fmt"
	"html/template"
	"io"
	"os"
	"server/controllers"
	"server/utils"

	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	env := flag.String("e", "development", "set environment")
	flag.Parse()
	loadDotenv(*env)
	utils.InitFirebase()

	e := echo.New()
	t := &Template{
		templates: template.Must(template.ParseGlob("public/**/*.html")),
	}
	e.Renderer = t
	sc := controllers.NewSlackController()
	e.GET("", sc.Index)
	slack := e.Group("/slacks")
	{
		slack.GET("/callback", sc.Callback)
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

type Template struct {
	templates *template.Template
}

func (t *Template) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	return t.templates.ExecuteTemplate(w, name, data)
}
