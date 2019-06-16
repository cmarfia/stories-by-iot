package story

// Character represents a character in a story
type Character struct {
	ID           string  `json:"id"`
	Name         string  `json:"name"`
	ImageLink    string  `json:"image"`
	Interactable bool    `json:"interactable"`
	ActionText   *string `json:"actionText,omitempty"`
}
