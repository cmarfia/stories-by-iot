// Package routes is responsible for assigning routes to the to the echo framework server
package routes

import (
	"github.com/labstack/echo"
)

// Register all routes for the API
func Register(e *echo.Echo) {
	registerStaticRoutes(e)

	v1 := e.Group("/api/v1")
	{
		registerStoriesRoutes(v1)
	}
} 