module Story exposing
    ( Character
    , ConnectionLocation
    , Info
    , Item
    , Location
    , Narrative
    , Passage
    , Story
    , decode
    , decodeInfo
    , getRules
    , toEngine
    )

import Dict exposing (Dict)
import Engine
import Json.Decode as Decode exposing (Decoder, bool, list, maybe, nullable, string)
import Json.Decode.Pipeline exposing (custom, optional, required, requiredAt, resolve)



-- Types


type alias Story =
    { id : String
    , title : String
    , slug : String
    , coverImage : String
    , startingPassageId : String
    , imagesToPreLoad : List String
    , characters : Dict String Character
    , items : Dict String Item
    , locations : Dict String Location
    , scenes : Dict String (List String)
    , passages : Dict String Passage
    }


type alias Narrative =
    { text : String
    , audio : Maybe String
    }


type alias Character =
    { id : String
    , name : String
    , image : String
    , interactable : Bool
    , actionText : Maybe String
    }


type alias Item =
    { id : String
    , actionText : String
    }


type alias Location =
    { id : String
    , name : String
    , image : String
    , actionText : Maybe String
    , connectingLocations : List ConnectionLocation
    }


type alias ConnectionLocation =
    { id : String
    , conditions : List Engine.Condition
    }


type alias Scene =
    { id : String
    , passages : List Passage
    }


type alias Passage =
    { id : String
    , interaction : Engine.InteractionMatcher
    , conditions : List Engine.Condition
    , changes : List Engine.ChangeWorldCommand
    , narrative : Narrative
    }


type alias Info =
    { id : String
    , title : String
    , slug : String
    , coverImage : String
    }



-- Decoders


decodeInfo : Decoder Info
decodeInfo =
    Decode.succeed Info
        |> required "id" string
        |> required "title" string
        |> required "slug" string
        |> required "cover" string


decode : Decoder Story
decode =
    Decode.succeed Story
        |> required "id" string
        |> required "title" string
        |> required "slug" string
        |> required "cover" string
        |> required "startingPassageId" string
        |> required "images" (list string)
        |> custom decodeCharacters
        |> custom decodeItems
        |> custom decodeLocations
        |> custom decodeScenes
        |> custom decodePassages


decodeNarrative : Decoder Narrative
decodeNarrative =
    Decode.succeed Narrative
        |> required "text" string
        |> optional "audio" (maybe string) Nothing


decodeCharacters : Decoder (Dict String Character)
decodeCharacters =
    let
        decodeCharacter =
            Decode.succeed Character
                |> required "id" string
                |> required "name" string
                |> required "image" string
                |> required "interactable" bool
                |> optional "actionText" (maybe string) Nothing

        toCharacters characters =
            characters
                |> List.map (\character -> ( character.id, character ))
                |> Dict.fromList
                |> Decode.succeed
    in
    Decode.succeed toCharacters
        |> required "characters" (list decodeCharacter)
        |> resolve


decodeItems : Decoder (Dict String Item)
decodeItems =
    let
        decodeItem =
            Decode.succeed Item
                |> required "id" string
                |> required "actionText" string

        toItems items =
            items
                |> List.map (\item -> ( item.id, item ))
                |> Dict.fromList
                |> Decode.succeed
    in
    Decode.succeed toItems
        |> required "items" (list decodeItem)
        |> resolve


decodeLocations : Decoder (Dict String Location)
decodeLocations =
    let
        decodeLocation =
            Decode.succeed Location
                |> required "id" string
                |> required "name" string
                |> required "image" string
                |> optional "actionText" (maybe string) Nothing
                |> optional "connectingLocations" (list decodeConnectingLocation) []

        toLocations locations =
            locations
                |> List.map (\location -> ( location.id, location ))
                |> Dict.fromList
                |> Decode.succeed
    in
    Decode.succeed toLocations
        |> required "locations" (list decodeLocation)
        |> resolve


decodeConnectingLocation : Decoder ConnectionLocation
decodeConnectingLocation =
    Decode.succeed ConnectionLocation
        |> required "id" string
        |> required "conditions" (list decodeCondition)


decodeScenes : Decoder (Dict String (List String))
decodeScenes =
    let
        decodeScene =
            Decode.succeed Scene
                |> required "id" string
                |> required "passages" (list decodePassage)

        toScenes scenes =
            scenes
                |> List.map (\scene -> ( scene.id, List.map .id scene.passages ))
                |> Dict.fromList
                |> Decode.succeed
    in
    Decode.succeed toScenes
        |> required "scenes" (list decodeScene)
        |> resolve


decodePassages : Decoder (Dict String Passage)
decodePassages =
    let
        decodeScene =
            Decode.succeed Scene
                |> required "id" string
                |> required "passages" (list decodePassage)

        toScenes scenes =
            scenes
                |> List.concatMap (\scene -> scene.passages)
                |> List.map (\passage -> ( passage.id, passage ))
                |> Dict.fromList
                |> Decode.succeed
    in
    Decode.succeed toScenes
        |> required "scenes" (list decodeScene)
        |> resolve


decodePassage : Decoder Passage
decodePassage =
    Decode.succeed Passage
        |> required "id" string
        |> required "interaction" decodeInteraction
        |> required "conditions" (list decodeCondition)
        |> required "changes" (list decodeChangeWorldCommand)
        |> required "narrative" decodeNarrative


decodeChangeWorldCommand : Decoder Engine.ChangeWorldCommand
decodeChangeWorldCommand =
    let
        toChangeWorldCommand commandName =
            case commandName of
                "MOVE_TO" ->
                    Decode.succeed (Engine.moveTo >> Decode.succeed)
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "ADD_LOCATION" ->
                    Decode.succeed (Engine.addLocation >> Decode.succeed)
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "REMOVE_LOCATION" ->
                    Decode.succeed (Engine.removeLocation >> Decode.succeed)
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "MOVE_ITEM_TO_INVENTORY" ->
                    Decode.succeed (Engine.moveItemToInventory >> Decode.succeed)
                        |> requiredAt [ "data", "item" ] string
                        |> resolve

                "MOVE_CHARACTER_TO_LOCATION" ->
                    Decode.succeed (composeBinaryDecoder Engine.moveCharacterToLocation)
                        |> requiredAt [ "data", "character" ] string
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "MOVE_CHARACTER_OFF_SCREEN" ->
                    Decode.succeed (Engine.moveCharacterOffScreen >> Decode.succeed)
                        |> requiredAt [ "data", "character" ] string
                        |> resolve

                "MOVE_ITEM_TO_LOCATION" ->
                    Decode.succeed (composeBinaryDecoder Engine.moveItemToLocation)
                        |> requiredAt [ "data", "item" ] string
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "MOVE_ITEM_TO_LOCATION_FIXED" ->
                    Decode.succeed (composeBinaryDecoder Engine.moveItemToLocationFixed)
                        |> requiredAt [ "data", "item" ] string
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "MOVE_ITEM_OFF_SCREEN" ->
                    Decode.succeed (Engine.moveItemOffScreen >> Decode.succeed)
                        |> requiredAt [ "data", "item" ] string
                        |> resolve

                "LOAD_SCENE" ->
                    Decode.succeed (Engine.loadScene >> Decode.succeed)
                        |> requiredAt [ "data", "scene" ] string
                        |> resolve

                "END_STORY" ->
                    Decode.succeed (Engine.endStory >> Decode.succeed)
                        |> requiredAt [ "data", "endingNarrative" ] string
                        |> resolve

                _ ->
                    Decode.fail "unrecognized change world command"
    in
    Decode.succeed toChangeWorldCommand
        |> required "type" string
        |> resolve


decodeCondition : Decoder Engine.Condition
decodeCondition =
    let
        toCondition conditionName =
            case conditionName of
                "ITEM_IS_IN_INVENTORY" ->
                    Decode.succeed (Engine.itemIsInInventory >> Decode.succeed)
                        |> requiredAt [ "data", "item" ] string
                        |> resolve

                "CHARACTER_IS_IN_LOCATION" ->
                    Decode.succeed (composeBinaryDecoder Engine.characterIsInLocation)
                        |> requiredAt [ "data", "character" ] string
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "ITEM_IS_IN_LOCATION" ->
                    Decode.succeed (composeBinaryDecoder Engine.itemIsInLocation)
                        |> requiredAt [ "data", "item" ] string
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "CURRENT_LOCATION_IS" ->
                    Decode.succeed (Engine.currentLocationIs >> Decode.succeed)
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "ITEM_IS_NOT_IN_INVENTORY" ->
                    Decode.succeed (Engine.itemIsNotInInventory >> Decode.succeed)
                        |> requiredAt [ "data", "item" ] string
                        |> resolve

                "HAS_PREVIOUSLY_INTERACTED_WITH" ->
                    Decode.succeed (Engine.hasPreviouslyInteractedWith >> Decode.succeed)
                        |> requiredAt [ "data", "entity" ] string
                        |> resolve

                "HAS_NOT_PREVIOUSLY_INTERACTED_WITH" ->
                    Decode.succeed (Engine.hasNotPreviouslyInteractedWith >> Decode.succeed)
                        |> requiredAt [ "data", "entity" ] string
                        |> resolve

                "CURRENT_SCENE_IS" ->
                    Decode.succeed (Engine.currentSceneIs >> Decode.succeed)
                        |> requiredAt [ "data", "scene" ] string
                        |> resolve

                "CHARACTER_IS_NOT_IN_LOCATION" ->
                    Decode.succeed (composeBinaryDecoder Engine.characterIsNotInLocation)
                        |> requiredAt [ "data", "character" ] string
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "ITEM_IS_NOT_IN_LOCATION" ->
                    Decode.succeed (composeBinaryDecoder Engine.itemIsNotInLocation)
                        |> requiredAt [ "data", "item" ] string
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                "CURRENT_LOCATION_IS_NOT" ->
                    Decode.succeed (Engine.currentLocationIsNot >> Decode.succeed)
                        |> requiredAt [ "data", "location" ] string
                        |> resolve

                _ ->
                    Decode.fail "unrecognized change world command"
    in
    Decode.succeed toCondition
        |> required "type" string
        |> resolve


decodeInteraction : Decoder Engine.InteractionMatcher
decodeInteraction =
    let
        toCondition conditionName =
            case conditionName of
                "WITH" ->
                    Decode.succeed (Engine.with >> Decode.succeed)
                        |> requiredAt [ "data", "entity" ] string
                        |> resolve

                "WITH_ANYTHING" ->
                    Decode.succeed Engine.withAnything

                "WITH_ANY_ITEM" ->
                    Decode.succeed Engine.withAnyItem

                "WITH_ANY_LOCATION" ->
                    Decode.succeed Engine.withAnyLocation

                "WITH_ANY_CHARACTER" ->
                    Decode.succeed Engine.withAnyCharacter

                _ ->
                    Decode.fail "unrecognized change world command"
    in
    Decode.succeed toCondition
        |> required "type" string
        |> resolve



-- Public Methods


toEngine : Story -> Result String Engine.Model
toEngine story =
    case Dict.get story.startingPassageId story.passages of
        Just { changes } ->
            Ok <|
                Engine.changeWorld changes <|
                    Engine.init
                        { characters = Dict.keys story.characters
                        , items = Dict.keys story.items
                        , locations = Dict.keys story.locations
                        }
                        (getRules story)

        Nothing ->
            Err "unable to find starting passage"



-- Internal Methods


composeBinaryDecoder : (a -> b -> c) -> a -> b -> Decoder c
composeBinaryDecoder fn fst snd =
    Decode.succeed <| fn fst snd


getRules : Story -> Dict String Engine.Rule
getRules story =
    let
        addSceneCondition sceneId passage =
            { passage | conditions = Engine.currentSceneIs sceneId :: passage.conditions }

        toRuleEntry passage =
            ( passage.id
            , { interaction = passage.interaction
              , conditions = passage.conditions
              , changes = passage.changes
              }
            )

        passageToRule sceneId passageId =
            Dict.get passageId story.passages
                |> Maybe.map (addSceneCondition sceneId)
                |> Maybe.map toRuleEntry

        scenesToRules ( sceneId, passageIds ) =
            passageIds
                |> List.filterMap (passageToRule sceneId)
    in
    story.scenes
        |> Dict.toList
        |> List.map scenesToRules
        |> List.concat
        |> Dict.fromList
