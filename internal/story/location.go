package story

// Location represents a location in a story
type Location struct {
	ID                  string               `json:"id"`
	Name                string               `json:"name"`
	ImageLink           string               `json:"image"`
	ActionText          *string              `json:"actionText,omitempty"`
	ConnectingLocations []ConnectingLocation `json:"connectingLocations,omitempty"`
}
