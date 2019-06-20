package routes

import (
	"fmt"
	"net/http"

	"github.com/cmarfia/stories-by-iot/internal/server"

	"github.com/labstack/echo"
	"github.com/pkg/errors"
)

func registerStoriesRoutes(e *echo.Group) {
	e.GET("/stories", fetchStories)
	e.GET("/stories/:id", fetchStory)
}

func fetchStories(c echo.Context) error {
	apiContext, ok := c.(*server.APIContext)
	if !ok {
		return errors.New("routes: could not get API context for route /stories")
	}

	l, err := apiContext.DynamoService.GetLibrary()
	if err != nil {
		return errors.Wrap(err, "routes: error fetching library")
	}

	return c.JSON(http.StatusOK, l)
}

func fetchStory(c echo.Context) error {
	storyID := c.Param("id")
	apiContext, ok := c.(*server.APIContext)
	if !ok {
		return fmt.Errorf("routes: could not get API context for route /stories/%v", storyID)
	}

	s, err := apiContext.DynamoService.GetStoryByID(c.Param("id"))
	if err != nil {
		return errors.Wrapf(err, "routes: error fetching story with ID (%v)", storyID)
	}

	return c.JSON(http.StatusOK, s)
}
