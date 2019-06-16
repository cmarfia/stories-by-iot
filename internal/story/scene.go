package story 

// Scene represents a collection of passages that make up a
// scene of a story
type Scene struct {
	ID string `json:"id"`
	Passages []Passage `json:"passages"`
}