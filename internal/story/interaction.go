package story

import (
	"encoding/json"
)

// Interaction names
const (
	with = "WITH"
	withAnything = "WITH_ANYTHING"
	withAnyItem = "WITH_ANY_ITEM"
	withAnyLocation = "WITH_ANY_LOCATION"
	withAnyCharacter = "WITH_ANY_CHARACTER"
)

// Interaction is an interface to defines the different interactions
// a reader can make
type Interaction interface {
	json.Marshaler
}


// With represents the InteractionMatcher for interacting with a
// specific entity
type With struct {
	Entity string `json:"entity"`
}

// MarshalJSON marshals the with InteractionMatcher  
func (i *With) MarshalJSON() ([]byte, error) {
	return marshalType(with, *i)
}

// WithAnything represents the InteractionMatcher for interacting with
// any entity
type WithAnything struct {
}

// MarshalJSON marshals the withAnything InteractionMatcher  
func (i *WithAnything) MarshalJSON() ([]byte, error) {
	return marshalType(withAnything, *i)
}

// WithAnyItem represents the InteractionMatcher for interacting with
// any item
type WithAnyItem struct {
}

// MarshalJSON marshals the withAnyItem InteractionMatcher  
func (i *WithAnyItem) MarshalJSON() ([]byte, error) {
	return marshalType(withAnyItem, *i)
}

// WithAnyLocation represents the InteractionMatcher for interacting with
// any location
type WithAnyLocation struct {
}

// MarshalJSON marshals the withAnyLocation InteractionMatcher  
func (i *WithAnyLocation) MarshalJSON() ([]byte, error) {
	return marshalType(withAnyLocation, *i)
}

// WithAnyCharacter represents the InteractionMatcher for interacting with
// any character
type WithAnyCharacter struct {
}

// MarshalJSON marshals the withAnyCharacter InteractionMatcher  
func (i *WithAnyCharacter) MarshalJSON() ([]byte, error) {
	return marshalType(withAnyCharacter, *i)
}