// Package dynamodb defines all interactions with AWS DynamoDB
package dynamodb

import (
	"github.com/cmarfia/stories-by-iot/internal/story"
)

// Service represent a connected dynamodb service
type Service struct {
}

// MustInitialize creates a new instance of the dynamodb service
// or it will panic
func MustInitialize() Service {
	return Service{}
} 

// GetLibrary returns the library stored in dynamoDB
func (s Service) GetLibrary() ([]*story.Info, error) {
	return []*story.Info{&mockStoryInfo}, nil
}

// GetStoryByID returns a single story stored in dynamoDB
func (s Service) GetStoryByID(id string) (*story.Story, error) {
	return &mockStory, nil
}

