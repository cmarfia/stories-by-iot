// Package story defines the structure of stories
package story

// Story represents an entire story
type Story struct {
	ID string
	Title string
	Slug string
	CoverImage string
	StartingNarrative Narrative
	StartingState []ChangeWorldCommand
	ImagesToPreload []string
	Characters []Character
	Items []Item
	Locations []Location
	Scenes []Scene
}