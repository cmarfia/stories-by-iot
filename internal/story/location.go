package story

// Location represents a location in a story
type Location struct {
	ID string
	Name string
	ImageLink string
	ActionText *string
	ConnectingLocations []ConnectingLocation
}