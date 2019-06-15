// Package server is responsible for creating and configuring the echo framework server
package server

import (
	"net/http"

	"github.com/cmarfia/stories-by-iot/internal/template"

	"github.com/pkg/errors"
	"github.com/labstack/echo"
	"github.com/labstack/gommon/log"
)

// New create an initializes a echo.Echo server
func New() (*echo.Echo, error){
	echo.NotFoundHandler = func(c echo.Context) error {
		return c.Redirect(http.StatusPermanentRedirect, "/#/404")
	}
	
	e := echo.New() 
	e.HideBanner = true // Hide console banner

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