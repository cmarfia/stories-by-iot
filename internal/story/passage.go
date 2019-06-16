package story

// Passage defines a specific section of the story.
type Passage struct {
	ID string `json:"id"`
	Interaction Interaction `json:"interaction"`
	Conditions []Condition `json:"conditions"`
	Changes []ChangeWorldCommand `json:"changes"`
	Narrative Narrative `json:"narrative"`
}