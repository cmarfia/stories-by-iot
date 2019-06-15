package story

// Character represents a character in a story
type Character struct {
	ID string
	Name string
	ImageLink string
	Interactable bool
	ActionText *string
}