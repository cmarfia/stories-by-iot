package routes

import (
	"net/http"

	"github.com/cmarfia/stories-by-iot/internal/template"

	"github.com/labstack/echo"
)

func registerStaticRoutes(e *echo.Echo) {
	e.Static("/img", "dist/img")
	e.Static("/css", "dist/css")
	e.Static("/js", "dist/js")
	e.GET("/", renderIndex)
}

func renderIndex(c echo.Context) error {
	return c.Render(http.StatusOK, "index", template.Index{Title: "Story By Iot", Version: 2})
}