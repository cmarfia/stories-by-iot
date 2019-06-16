// Package server is responsible for creating and configuring the echo framework server
package server

import (
	"net/http"

	"github.com/cmarfia/stories-by-iot/internal/dynamodb"
	"github.com/cmarfia/stories-by-iot/internal/template"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
	"github.com/labstack/gommon/log"
	"github.com/pkg/errors"
)

// New create an initializes a echo.Echo server
func New(dynamoService *dynamodb.Service) (*echo.Echo, error) {
	echo.NotFoundHandler = func(c echo.Context) error {
		return c.Redirect(http.StatusPermanentRedirect, "/#/404")
	}

	e := echo.New()
	e.HideBanner = true

	e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			return next(&APIContext{c, dynamoService})
		}
	})

	e.Use(middleware.RecoverWithConfig(middleware.DefaultRecoverConfig))

	r, err := template.NewRenderer()
	if err != nil {
		return nil, errors.Wrap(err, "server: could not create template renderer")
	}

	e.Renderer = r

	if l, ok := e.Logger.(*log.Logger); ok {
		l.SetHeader("${time_rfc3339} ${level}")
	}

	return e, nil
}
