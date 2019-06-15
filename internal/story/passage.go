package story

// Passage defines a specific section of the story.
type Passage struct {
	ID string
	Interaction Interaction
	Conditions []Condition
	Changes []ChangeWorldCommand
	Narrative Narrative
	IsEnding bool
}