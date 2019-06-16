package story

import (
	"encoding/json"
)

// Condition names
const (
	itemIsInInventory              = "ITEM_IS_IN_INVENTORY"
	characterIsInLocation          = "CHARACTER_IS_IN_LOCATION"
	itemIsInLocation               = "ITEM_IS_IN_LOCATION"
	currentLocationIs              = "CURRENT_LOCATION_IS"
	itemIsNotInInventory           = "ITEM_IS_NOT_IN_INVENTORY"
	hasPreviouslyInteractedWith    = "HAS_PREVIOUSLY_INTERACTED_WITH"
	hasNotPreviouslyInteractedWith = "HAS_NOT_PREVIOUSLY_INTERACTED_WITH"
	currentSceneIs                 = "CURRENT_SCENE_IS"
	characterIsNotInLocation       = "CHARACTER_IS_NOT_IN_LOCATION"
	itemIsNotInLocation            = "ITEM_IS_NOT_IN_LOCATION"
	currentLocationIsNot           = "CURRENT_LOCATION_IS_NOT"
)

// Condition is an interface to defines the different conditions
// for the story
type Condition interface {
	json.Marshaler
}

// ItemIsInInventory represents the Condition that an item is in
// the reader's inventory
type ItemIsInInventory struct {
	Item string `json:"item"`
}

// MarshalJSON marshals the itemIsInInventory Condition
func (c *ItemIsInInventory) MarshalJSON() ([]byte, error) {
	return marshalType(itemIsInInventory, *c)
}

// CharacterIsInLocation represents the Condition that a character is
// in a specific location
type CharacterIsInLocation struct {
	Character string `json:"character"`
	Location  string `json:"location"`
}

// MarshalJSON marshals the characterIsInLocation Condition
func (c *CharacterIsInLocation) MarshalJSON() ([]byte, error) {
	return marshalType(characterIsInLocation, *c)
}

// ItemIsInLocation represents the Condition that a item is
// in a specific location
type ItemIsInLocation struct {
	Item     string `json:"item"`
	Location string `json:"location"`
}

// MarshalJSON marshals the itemIsInLocation Condition
func (c *ItemIsInLocation) MarshalJSON() ([]byte, error) {
	return marshalType(itemIsInLocation, *c)
}

// CurrentLocationIs represents the Condition that the current location is
// in a specific location
type CurrentLocationIs struct {
	Location string `json:"location"`
}

// MarshalJSON marshals the currentLocationIs Condition
func (c *CurrentLocationIs) MarshalJSON() ([]byte, error) {
	return marshalType(currentLocationIs, *c)
}

// ItemIsNotInInventory represents the Condition that an item is not
// in the reader's inventory
type ItemIsNotInInventory struct {
	Item string `json:"item"`
}

// MarshalJSON marshals the itemIsNotInInventory Condition
func (c *ItemIsNotInInventory) MarshalJSON() ([]byte, error) {
	return marshalType(itemIsNotInInventory, *c)
}

// HasPreviouslyInteractedWith represents the Condition the reader has
// previously interacted with a specific entity
type HasPreviouslyInteractedWith struct {
	Entity string `json:"entity"`
}

// MarshalJSON marshals the hasPreviouslyInteractedWith Condition
func (c *HasPreviouslyInteractedWith) MarshalJSON() ([]byte, error) {
	return marshalType(hasPreviouslyInteractedWith, *c)
}

// HasNotPreviouslyInteractedWith represents the Condition the reader has no
// previously interacted with a specific entity
type HasNotPreviouslyInteractedWith struct {
	Entity string `json:"entity"`
}

// MarshalJSON marshals the hasNotPreviouslyInteractedWith Condition
func (c *HasNotPreviouslyInteractedWith) MarshalJSON() ([]byte, error) {
	return marshalType(hasNotPreviouslyInteractedWith, *c)
}

// CurrentSceneIs represents the Condition that the current scene is a
// specific scene
type CurrentSceneIs struct {
	Scene string `json:"scene"`
}

// MarshalJSON marshals the currentSceneIs Condition
func (c *CurrentSceneIs) MarshalJSON() ([]byte, error) {
	return marshalType(currentSceneIs, *c)
}

// CharacterIsNotInLocation represents the Condition that a character is
// not in a specific location
type CharacterIsNotInLocation struct {
	Character string `json:"character"`
	Location  string `json:"location"`
}

// MarshalJSON marshals the characterIsNotInLocation Condition
func (c *CharacterIsNotInLocation) MarshalJSON() ([]byte, error) {
	return marshalType(characterIsNotInLocation, *c)
}

// ItemIsNotInLocation represents the Condition that an item is
// not in a specific location
type ItemIsNotInLocation struct {
	Item     string `json:"item"`
	Location string `json:"location"`
}

// MarshalJSON marshals the itemIsNotInLocation Condition
func (c *ItemIsNotInLocation) MarshalJSON() ([]byte, error) {
	return marshalType(itemIsNotInLocation, *c)
}

// CurrentLocationIsNot represents the Condition that the current location
// is not a specific location
type CurrentLocationIsNot struct {
	Location string `json:"location"`
}

// MarshalJSON marshals the currentLocationIsNot Condition
func (c *CurrentLocationIsNot) MarshalJSON() ([]byte, error) {
	return marshalType(currentLocationIsNot, *c)
}
