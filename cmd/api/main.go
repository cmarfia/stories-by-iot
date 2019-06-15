package main

import (
	"net/http"
	"github.com/cmarfia/stories-by-iot/internal/template"

	"github.com/labstack/echo"
	"github.com/labstack/gommon/log"
)

func main() {
	e := echo.New() 
	e.HideBanner = true

	template.Init(e)
	if l, ok := e.Logger.(*log.Logger); ok {
		l.SetHeader("${time_rfc3339} ${level}")
	}

	// set up static resources
	e.Static("/img", "dist/img")
	e.Static("/css", "dist/css")
	e.Static("/js", "dist/js")
	
	e.GET("/", func(c echo.Context) error {
		return c.Render(http.StatusOK, "index", template.Index{Title: "Story By Iot", Version: 2})
	})

	e.Logger.Fatal(e.Start(":8080"))
}