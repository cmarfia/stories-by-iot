package story

// Item represent an interactable item within a story
type Item struct {
	ID string `json:"id"`
	ActionText string `json:"actionText"`
}