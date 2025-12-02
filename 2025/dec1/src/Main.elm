module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String exposing (split)



-- MAIN
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model =
  { inputs : String, solution: Int }

init : Model
init =
  Model "" 0


type Msg
  = Inputs String


toNeg = (String.replace "L" "-")
toPos = (String.replace "R" "")

makeInt : String -> Int
makeInt value =
    case (String.toInt value) of
        Just myInt ->
            myInt
        Nothing ->
            0

type alias WIP = {position: Int, head: Int, tail: List Int }

turnTheDial : List Int -> Int
turnTheDial value = 
    case value of
        [] -> 
            0
        (theHead :: theRest) ->
            checkPosition {position = 50, head = theHead, tail = theRest}

checkPosition : WIP -> Int
checkPosition wip =
    case wip.tail of
        [] -> 
            isZero wip
        (theHead :: theRest) ->
            (isZero wip) + (checkPosition {position = wip.position + wip.head, head = theHead, tail = theRest})

isZero : WIP -> Int
isZero wip = 
    if (modBy 100 (wip.position + wip.head)) == 0 then 1 else 0

solve : List String -> Int
solve inputs =
    turnTheDial (List.map makeInt (List.map (toPos) (List.map (toNeg) inputs)))

update : Msg -> Model -> Model
update msg model =
  case msg of
    Inputs inputs ->
      { model | inputs = inputs, solution = (solve (split "\n" inputs)) }

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ textarea [ cols 40, rows 10, placeholder "...", onInput Inputs ] []
    , showSolution model
    ]


showSolution : Model -> Html msg
showSolution model =
    div [ style "color" "green" ] [ text (String.fromInt model.solution) ]



