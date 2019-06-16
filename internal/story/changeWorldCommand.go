package story

import (
	"encoding/json"
)

// ChangeWorldCommand names
const (
	moveTo                  = "MOVE_TO"
	addLocation             = "ADD_LOCATION"
	removeLocation          = "REMOVE_LOCATION"
	moveItemToInventory     = "MOVE_ITEM_TO_INVENTORY"
	moveCharacterToLocation = "MOVE_CHARACTER_TO_LOCATION"
	moveCharacterOffScreen  = "MOVE_CHARACTER_OFF_SCREEN"
	moveItemToLocation      = "MOVE_ITEM_TO_LOCATION"
	moveItemToLocationFixed = "MOVE_ITEM_TO_LOCATION_FIXED"
	moveItemOffScreen       = "MOVE_ITEM_OFF_SCREEN"
	loadScene               = "LOAD_SCENE"
	endStory                = "END_STORY"
)

// ChangeWorldCommand is an interface to defines a command to change
// the story
type ChangeWorldCommand interface {
	json.Marshaler
}

// MoveToLocation represents the ChangeWorldCommand for moving
// the story to a new location
type MoveToLocation struct {
	Location string `json:"location"`
}

// MarshalJSON marshals the moveTo ChangeWorldCommand
func (c *MoveToLocation) MarshalJSON() ([]byte, error) {
	return marshalType(moveTo, *c)
}

// AddLocation represents the ChangeWorldCommand for adding a new  location
// to the story
type AddLocation struct {
	Location string `json:"location"`
}

// MarshalJSON marshals the addLocation ChangeWorldCommand
func (c *AddLocation) MarshalJSON() ([]byte, error) {
	return marshalType(addLocation, *c)
}

// RemoveLocation represents the ChangeWorldCommand for removing a location
// to the story
type RemoveLocation struct {
	Location string `json:"location"`
}

// MarshalJSON marshals the removeLocation ChangeWorldCommand
func (c *RemoveLocation) MarshalJSON() ([]byte, error) {
	return marshalType(removeLocation, *c)
}

// MoveItemToInventory represents the ChangeWorldCommand for adding an item
// to the readers inventory
type MoveItemToInventory struct {
	Item string `json:"item"`
}

// MarshalJSON marshals the moveItemToInventory ChangeWorldCommand
func (c *MoveItemToInventory) MarshalJSON() ([]byte, error) {
	return marshalType(moveItemToInventory, *c)
}

// MoveCharacterToLocation represents the ChangeWorldCommand for moving a
// character to a specific location
type MoveCharacterToLocation struct {
	Character string `json:"character"`
	Location  string `json:"location"`
}

// MarshalJSON marshals the moveCharacterToLocation ChangeWorldCommand
func (c *MoveCharacterToLocation) MarshalJSON() ([]byte, error) {
	return marshalType(moveCharacterToLocation, *c)
}

// MoveCharacterOffScreen represents the ChangeWorldCommand for moving a
// character off the screen
type MoveCharacterOffScreen struct {
	Character string `json:"character"`
}

// MarshalJSON marshals the moveCharacterOffScreen ChangeWorldCommand
func (c *MoveCharacterOffScreen) MarshalJSON() ([]byte, error) {
	return marshalType(moveCharacterOffScreen, *c)
}

// MoveItemToLocation represents the ChangeWorldCommand for moving an
// item to a specific location
type MoveItemToLocation struct {
	Item     string `json:"item"`
	Location string `json:"location"`
}

// MarshalJSON marshals the moveItemToLocation ChangeWorldCommand
func (c *MoveItemToLocation) MarshalJSON() ([]byte, error) {
	return marshalType(moveItemToLocation, *c)
}

// MoveItemToFixedLocation represents the ChangeWorldCommand for moving an
// item to a specific location, where the item cannot be added to the
// readers inventory
type MoveItemToFixedLocation struct {
	Item     string `json:"item"`
	Location string `json:"location"`
}

// MarshalJSON marshals the moveItemToLocationFixed ChangeWorldCommand
func (c *MoveItemToFixedLocation) MarshalJSON() ([]byte, error) {
	return marshalType(moveItemToLocationFixed, *c)
}

// MoveItemOffScreen represents the ChangeWorldCommand for moving an
// item off the screen
type MoveItemOffScreen struct {
	Item string `json:"item"`
}

// MarshalJSON marshals the moveItemOffScreen ChangeWorldCommand
func (c *MoveItemOffScreen) MarshalJSON() ([]byte, error) {
	return marshalType(moveItemOffScreen, *c)
}

// LoadScene represents the ChangeWorldCommand for loading a scene
type LoadScene struct {
	Scene string `json:"scene"`
}

// MarshalJSON marshals the loadScene ChangeWorldCommand
func (c *LoadScene) MarshalJSON() ([]byte, error) {
	return marshalType(loadScene, *c)
}

// EndStory represents the ChangeWorldCommand for ending the story
type EndStory struct {
	EndingNarrative Narrative `json:"endingNarrative"`
}

// MarshalJSON marshals the endStory ChangeWorldCommand
func (c *EndStory) MarshalJSON() ([]byte, error) {
	return marshalType(endStory, *c)
}
