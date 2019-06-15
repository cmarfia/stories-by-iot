package story

// ChangeWorldCommand names
const (
	moveTo = "MOVETO" 
	addLocation = "ADDLOCATION" 
	removeLocation = "REMOVELOCATION"
	moveItemToInventory = "MOVEITEMTOINVENTORY"
	moveCharacterToLocation = "MOVECHARACTERTOLOCATION"
	moveCharacterOffScreen = "MOVECHARACTEROFFSCREEN"
	moveItemToLocation = "MOVEITEMTOLOCATION"
	moveItemToLocationFixed = "MOVEITEMTOLOCATIONFIXED"
	moveItemOffScreen = "MOVEITEMOFFSCREEN"
	loadScene = "LOADSCENE"
	endStory = "ENDSTORY"
) 

// ChangeWorldCommand is an interface to defines a command to change
// the story 
type ChangeWorldCommand interface {
	Command() (string, []string)
}

// MoveToLocation represents the ChangeWorldCommand for moving
// the story to a new location
type MoveToLocation struct {
	Location string
}

// Command returns the name of arguments for the moveTo ChangeWorldCommand  
func (c *MoveToLocation) Command() (string, []string) {
	return moveTo, []string{c.Location}
}

// AddLocation represents the ChangeWorldCommand for adding a new  location
// to the story
type AddLocation struct {
	Location string
}

// Command returns the name of arguments for the addLocation ChangeWorldCommand  
func (c *AddLocation) Command() (string, []string) {
	return addLocation, []string{c.Location}
}

// RemoveLocation represents the ChangeWorldCommand for removing a location
// to the story
type RemoveLocation struct {
	Location string
}

// Command returns the name of arguments for the removeLocation ChangeWorldCommand  
func (c *RemoveLocation) Command() (string, []string) {
	return removeLocation, []string{c.Location}
}

// MoveItemToInventory represents the ChangeWorldCommand for adding an item
// to the readers inventory
type MoveItemToInventory struct {
	Item string
}

// Command returns the name of arguments for the moveItemToInventory ChangeWorldCommand  
func (c *MoveItemToInventory) Command() (string, []string) {
	return moveItemToInventory, []string{c.Item}
}

// MoveCharacterToLocation represents the ChangeWorldCommand for moving a
// character to a specific location
type MoveCharacterToLocation struct {
	Character string
	Location string
}

// Command returns the name of arguments for the moveCharacterToLocation
// ChangeWorldCommand  
func (c *MoveCharacterToLocation) Command() (string, []string) {
	return moveCharacterToLocation, []string{c.Character, c.Location}
}

// MoveCharacterOffScreen represents the ChangeWorldCommand for moving a
// character off the screen
type MoveCharacterOffScreen struct {
	Character string
}

// Command returns the name of arguments for the moveCharacterOffScreen
// ChangeWorldCommand  
func (c *MoveCharacterOffScreen) Command() (string, []string) {
	return moveCharacterOffScreen, []string{c.Character}
}

// MoveItemToLocation represents the ChangeWorldCommand for moving an
// item to a specific location
type MoveItemToLocation struct {
	Item string
	Location string
}

// Command returns the name of arguments for the moveItemToLocation
// ChangeWorldCommand  
func (c *MoveItemToLocation) Command() (string, []string) {
	return moveItemToLocation, []string{c.Item, c.Location}
}

// MoveItemToFixedLocation represents the ChangeWorldCommand for moving an
// item to a specific location, where the item cannot be added to the
// readers inventory
type MoveItemToFixedLocation struct {
	Item string
	Location string
}

// Command returns the name of arguments for the moveItemToLocationFixed
// ChangeWorldCommand  
func (c *MoveItemToFixedLocation) Command() (string, []string) {
	return moveItemToLocationFixed, []string{c.Item, c.Location}
}

// MoveItemOffScreen represents the ChangeWorldCommand for moving an
// item off the screen
type MoveItemOffScreen struct {
	Item string
}

// Command returns the name of arguments for the moveItemOffScreen
// ChangeWorldCommand  
func (c *MoveItemOffScreen) Command() (string, []string) {
	return moveItemOffScreen, []string{c.Item}
}

// LoadScene represents the ChangeWorldCommand for loading a scene
type LoadScene struct {
	Scene string
}

// Command returns the name of arguments for the loadScene
// ChangeWorldCommand  
func (c *LoadScene) Command() (string, []string) {
	return loadScene, []string{c.Scene}
}

// EndStory represents the ChangeWorldCommand for ending the story
type EndStory struct {
	Ending string
}

// Command returns the name of arguments for the endStory
// ChangeWorldCommand  
func (c *EndStory) Command() (string, []string) {
	return endStory, []string{c.Ending}
}