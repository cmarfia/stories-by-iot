package story 

// ConnectingLocation represents when a location can be connected
// with another location
type ConnectingLocation struct {
	ID string
	Conditions []Condition
}