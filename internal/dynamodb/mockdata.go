package dynamodb

import (
	"github.com/cmarfia/stories-by-iot/internal/story"
)


func ptrString(str string) *string {
	return &str
}

var mockStoryInfo = story.Info{
	ID:         "90905b00-11f4-4726-8020-4ad6b102fceb",
	Title:      "Example Story",
	Slug:       "example-story",
	CoverImage: "img/laz_01_cover.png",
}

var mockStory = story.Story{
	ID:         "90905b00-11f4-4726-8020-4ad6b102fceb",
	Title:      "Example Story",
	Slug:       "example-story",
	CoverImage: "img/laz_01_cover.png",
	StartingNarrative: story.Narrative{
		Text:      "Intro",
		AudioLink: "--link--",
	},
	StartingState: []story.ChangeWorldCommand{
		&story.MoveToLocation{Location: "plains"},
		&story.MoveItemToLocation{Item: "continue", Location: "plains"},
		&story.MoveCharacterToLocation{Character: "laz", Location: "plains"},
		&story.LoadScene{Scene: "intro"},
	},
	ImagesToPreload: []string{
		"img/plains.png",
		"img/forest.png",
		"img/laz.png",
		"img/laz_01_cover.png",
	},
	Characters: []story.Character{
		{
			ID:           "laz",
			Name:         "Laz",
			ImageLink:    "img/laz.png",
			Interactable: true,
			ActionText:   ptrString("Speak with Laz"),
		},
	},
	Items: []story.Item{
		{
			ID:         "continue",
			ActionText: "Continue",
		},
	},
	Locations: []story.Location{
		{
			ID:         "plains",
			Name:       "The Plains",
			ImageLink:  "img/plains.png",
			ActionText: nil,
			ConnectingLocations: []story.ConnectingLocation{
				{
					ID: "forest",
					Conditions: []story.Condition{
						&story.CurrentSceneIs{Scene: "ending"},
					},
				},
			},
		},
		{
			ID:                  "forest",
			Name:                "The Deep Forest",
			ImageLink:           "img/forest.png",
			ActionText:          ptrString("Enter the Deep Forest"),
			ConnectingLocations: nil,
		},
	},
	Scenes: []story.Scene{
		{
			ID: "intro",
			Passages: []story.Passage{
				{
					ID:          "passage_1",
					Interaction: &story.With{Entity: "continue"},
					Conditions: []story.Condition{
						&story.ItemIsInLocation{Item: "continue", Location: "plains"},
						&story.CurrentLocationIs{Location: "plains"},
					},
					Changes: []story.ChangeWorldCommand{
						&story.LoadScene{Scene: "middle"},
					},
					Narrative: story.Narrative{
						Text:      "entered passage 1 after clicking continue",
						AudioLink: "--link--",
					},
				},
				{
					ID:          "passage_2",
					Interaction: &story.With{Entity: "laz"},
					Conditions: []story.Condition{
						&story.CharacterIsInLocation{Character: "laz", Location: "plains"},
						&story.CurrentLocationIs{Location: "plains"},
					},
					Changes: []story.ChangeWorldCommand{
						&story.LoadScene{Scene: "middle"},
					},
					Narrative: story.Narrative{
						Text:      "talked with laz entering passage 2",
						AudioLink: "--link--",
					},
				},
			},
		},
		{
			ID: "middle",
			Passages: []story.Passage{
				{
					ID:          "passage_3",
					Interaction: &story.With{Entity: "continue"},
					Conditions: []story.Condition{
						&story.CharacterIsInLocation{Character: "laz", Location: "plains"},
						&story.CurrentLocationIs{Location: "plains"},
						&story.HasNotPreviouslyInteractedWith{Entity: "laz"},
					},
					Changes: []story.ChangeWorldCommand{
						&story.MoveItemOffScreen{Item: "continue"},
						&story.LoadScene{Scene: "ending"},
					},
					Narrative: story.Narrative{
						Text:      "passage 3 continuing on",
						AudioLink: "--link--",
					},
				},
				{
					ID:          "passage_4",
					Interaction: &story.With{Entity: "laz"},
					Conditions: []story.Condition{
						&story.CharacterIsInLocation{Character: "laz", Location: "plains"},
						&story.CurrentLocationIs{Location: "plains"},
						&story.HasNotPreviouslyInteractedWith{Entity: "laz"},
					},
					Changes: []story.ChangeWorldCommand{
						&story.MoveItemOffScreen{Item: "continue"},
						&story.MoveCharacterOffScreen{Character: "laz"},
						&story.LoadScene{Scene: "ending"},
					},
					Narrative: story.Narrative{
						Text:      "passage 4 talking with laz",
						AudioLink: "--link--",
					},
				},
				{
					ID:          "passage_5",
					Interaction: &story.With{Entity: "laz"},
					Conditions: []story.Condition{
						&story.CharacterIsInLocation{Character: "laz", Location: "plains"},
						&story.CurrentLocationIs{Location: "plains"},
						&story.HasPreviouslyInteractedWith{Entity: "laz"},
					},
					Changes: []story.ChangeWorldCommand{
						&story.MoveItemOffScreen{Item: "continue"},
						&story.MoveCharacterOffScreen{Character: "laz"},
						&story.LoadScene{Scene: "ending"},
					},
					Narrative: story.Narrative{
						Text:      "passage 5 talking with laz again",
						AudioLink: "--link--",
					},
				},
			},
		},
		{
			ID: "ending",
			Passages: []story.Passage{
				{
					ID:          "passage_6",
					Interaction: &story.With{Entity: "laz"},
					Conditions: []story.Condition{
						&story.CharacterIsInLocation{Character: "laz", Location: "plains"},
						&story.CurrentLocationIs{Location: "plains"},
					},
					Changes: []story.ChangeWorldCommand{
						&story.MoveCharacterOffScreen{Character: "laz"},
					},
					Narrative: story.Narrative{
						Text:      "passage 6 Talking with laz for the first time",
						AudioLink: "--link--",
					},
				},
				{
					ID:          "passage_7",
					Interaction: &story.With{Entity: "forest"},
					Conditions: []story.Condition{
						&story.CurrentLocationIs{Location: "plains"},
					},
					Changes: []story.ChangeWorldCommand{
						&story.EndStory{
							EndingNarrative: "The End",
						},
						&story.MoveToLocation{Location: "forest"},
					},
					Narrative: story.Narrative{
						Text:      "passage 7 moving to the forest",
						AudioLink: "--link--",
					},
				},
			},
		},
	},
}
