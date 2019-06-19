// Package story defines the structure of stories
package story

import (
	"encoding/json"
)

// Story represents an entire story
type Story struct {
	ID                string               `json:"id"`
	Title             string               `json:"title"`
	Slug              string               `json:"slug"`
	CoverImage        string               `json:"cover"`
	StartingPassageID string 			   `json:"startingPassageId"`
	ImagesToPreload   []string             `json:"images"`
	Characters        []Character          `json:"characters"`
	Items             []Item               `json:"items"`
	Locations         []Location           `json:"locations"`
	Scenes            []Scene              `json:"scenes"`
}

func marshalType(t string, d interface{}) ([]byte, error) {
	return json.Marshal(&struct {
		Type string      `json:"type"`
		Data interface{} `json:"data"`
	}{t, d})
}
