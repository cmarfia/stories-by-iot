package story

// Interaction names
const (
	with = "WITH"
	withAnything = "WITHANYTHING"
	withAnyItem = "WITHANYITEM"
	withAnyLocation = "WITHANYLOCATION"
	withAnyCharacter = "WITHANYCHARACTER"
)

// Interaction is an interface to defines the different interactions
// a reader can make
type Interaction interface {
	Interaction() (string, []string)
}


// With represents the InteractionMatcher for interacting with a
// specific entity
type With struct {
	Entity string
}

// Interaction returns the name of arguments for the with
// InteractionMatcher  
func (i *With) Interaction() (string, []string) {
	return with, []string{i.Entity}
}

// WithAnything represents the InteractionMatcher for interacting with
// any entity
type WithAnything struct {
}

// Interaction returns the name of arguments for the withAnything
// InteractionMatcher  
func (i *WithAnything) Interaction() (string, []string) {
	return withAnything, []string{}
}

// WithAnyItem represents the InteractionMatcher for interacting with
// any item
type WithAnyItem struct {
}

// Interaction returns the name of arguments for the withAnyItem
// InteractionMatcher  
func (i *WithAnyItem) Interaction() (string, []string) {
	return withAnyItem, []string{}
}

// WithAnyLocation represents the InteractionMatcher for interacting with
// any location
type WithAnyLocation struct {
}

// Interaction returns the name of arguments for the withAnyLocation
// InteractionMatcher  
func (i *WithAnyLocation) Interaction() (string, []string) {
	return withAnyLocation, []string{}
}

// WithAnyCharacter represents the InteractionMatcher for interacting with
// any character
type WithAnyCharacter struct {
}

// Interaction returns the name of arguments for the withAnyCharacter
// InteractionMatcher  
func (i *WithAnyCharacter) Interaction() (string, []string) {
	return withAnyCharacter, []string{}
}