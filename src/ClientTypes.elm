module ClientTypes exposing (Msg(..), StorySnippet)


type Msg
    = Interact String
    | Loaded
    | Restart


type alias StorySnippet =
    { interactableName : String
    , interactableCssSelector : String
    , narrative : String
    }
