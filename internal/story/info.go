package story

// Info represents meta data information about a story
type Info struct {
	ID                string               `json:"id"`
	Title             string               `json:"title"`
	Slug              string               `json:"slug"`
	CoverImage        string               `json:"cover"`
}