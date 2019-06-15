package routes

import (
	"net/http"

	"github.com/labstack/echo"
)

func registerStoriesRoutes(e *echo.Group) {
	e.GET("/stories", fetchStories)
	e.GET("/stories/:id", fetchStory)
}

func fetchStories(c echo.Context) error {
	return c.JSON(http.StatusOK, []string{"hello world"})
}

func fetchStory(c echo.Context) error {
	return c.JSON(http.StatusOK, c.Param("id"))
}
