package story

// Condition names
const (
	itemIsInInventory = "ITEMISININVENTORY"
	characterIsInLocation = "CHARACTERISINLOCATION"
	itemIsInLocation = "ITEMISINLOCATION"
	currentLocationIs = "CURRENTLOCATIONIS"
	itemIsNotInInventory = "ITEMISNOTININVENTORY"
	hasPreviouslyInteractedWith = "HASPREVIOUSLYINTERACTEDWITH"
	hasNotPreviouslyInteractedWith = "HASNOTPREVIOUSLYINTERACTEDWITH"
	currentSceneIs = "CURRENTSCENEIS"
	characterIsNotInLocation = "CHARACTERISNOTINLOCATION"
	itemIsNotInLocation = "ITEMISNOTINLOCATION"
	currentLocationIsNot = "CURRENTLOCATIONISNOT"
)

// Condition is an interface to defines the different conditions
// for the story
type Condition interface {
	Condition() (string, []string)
}

// ItemIsInInventory represents the Condition that an item is in
// the reader's inventory
type ItemIsInInventory struct {
	Item string
}

// Condition returns the name of arguments for the itemIsInInventory
// Condition  
func (c *ItemIsInInventory) Condition() (string, []string) {
	return itemIsInInventory, []string{c.Item}
}

// CharacterIsInLocation represents the Condition that a character is
// in a specific location
type CharacterIsInLocation struct {
	Character string
	Location string
}

// Condition returns the name of arguments for the characterIsInLocation
// Condition 
func (c *CharacterIsInLocation) Condition() (string, []string) {
	return characterIsInLocation, []string{c.Character, c.Location}
}

// ItemIsInLocation represents the Condition that a item is
// in a specific location
type ItemIsInLocation struct {
	Item string
	Location string
}

// Condition returns the name of arguments for the itemIsInLocation
// Condition 
func (c *ItemIsInLocation) Condition() (string, []string) {
	return itemIsInLocation, []string{c.Item, c.Location}
}

// CurrentLocationIs represents the Condition that the current location is
// in a specific location
type CurrentLocationIs struct {
	Location string
}

// Condition returns the name of arguments for the currentLocationIs
// Condition 
func (c *CurrentLocationIs) Condition() (string, []string) {
	return currentLocationIs, []string{c.Location}
}

// ItemIsNotInInventory represents the Condition that an item is not
// in the reader's inventory
type ItemIsNotInInventory struct {
	Item string
}

// Condition returns the name of arguments for the itemIsNotInInventory
// Condition 
func (c *ItemIsNotInInventory) Condition() (string, []string) {
	return itemIsNotInInventory, []string{c.Item}
}

// HasPreviouslyInteractedWith represents the Condition the reader has
// previously interacted with a specific entity
type HasPreviouslyInteractedWith struct {
	Entity string
}

// Condition returns the name of arguments for the hasPreviouslyInteractedWith
// Condition 
func (c *HasPreviouslyInteractedWith) Condition() (string, []string) {
	return hasPreviouslyInteractedWith, []string{c.Entity}
}

// HasNotPreviouslyInteractedWith represents the Condition the reader has no
// previously interacted with a specific entity
type HasNotPreviouslyInteractedWith struct {
	Entity string
}

// Condition returns the name of arguments for the hasNotPreviouslyInteractedWith
// Condition 
func (c *HasNotPreviouslyInteractedWith) Condition() (string, []string) {
	return hasNotPreviouslyInteractedWith, []string{c.Entity}
}

// CurrentSceneIs represents the Condition that the current scene is a
// specific scene
type CurrentSceneIs struct {
	Scene string
}

// Condition returns the name of arguments for the currentSceneIs
// Condition 
func (c *CurrentSceneIs) Condition() (string, []string) {
	return currentSceneIs, []string{c.Scene}
}

// CharacterIsNotInLocation represents the Condition that a character is 
// not in a specific location
type CharacterIsNotInLocation struct {
	Character string
	Location string
}

// Condition returns the name of arguments for the characterIsNotInLocation
// Condition 
func (c *CharacterIsNotInLocation) Condition() (string, []string) {
	return characterIsNotInLocation, []string{c.Character, c.Location}
}

// ItemIsNotInLocation represents the Condition that an item is 
// not in a specific location
type ItemIsNotInLocation struct {
	Item string
	Location string
}

// Condition returns the name of arguments for the itemIsNotInLocation
// Condition 
func (c *ItemIsNotInLocation) Condition() (string, []string) {
	return itemIsNotInLocation, []string{c.Item, c.Location}
}

// CurrentLocationIsNot represents the Condition that the current location 
// is not a specific location
type CurrentLocationIsNot struct {
	Location string
}

// Condition returns the name of arguments for the currentLocationIsNot
// Condition 
func (c *CurrentLocationIsNot) Condition() (string, []string) {
	return currentLocationIsNot, []string{c.Location}
}
