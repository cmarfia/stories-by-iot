package routes

import (
	"net/http"

	"github.com/cmarfia/stories-by-iot/internal/template"
	"github.com/cmarfia/stories-by-iot/internal/server"

	"github.com/labstack/echo"
	"github.com/pkg/errors"
)

func registerStaticRoutes(e *echo.Echo) {
	e.Static("/img", "dist/img")
	e.Static("/css", "dist/css")
	e.Static("/js", "dist/js")
	e.GET("/", renderIndex)
}

func renderIndex(c echo.Context) error {
	apiContext, ok := c.(*server.APIContext)
	if !ok {
		return errors.New("routes: could not get API context for route /")
	}

	l, err := apiContext.DynamoService.GetLibrary()
	if err != nil {
		return errors.Wrap(err, "routes: error fetching library")
	}

	data := template.Index{
		Title: "Story By Iot",
		Version: 2,
		Flags: map[string]interface{}{
			"library": l,
		},
	}
	return c.Render(http.StatusOK, "index", data)
}
