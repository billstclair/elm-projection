module Main exposing (..)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List.Extra as LE
import Projection exposing (project)
import Projection.Types exposing (Eye, Number, Point, Room, Shape)
import Projection.Util as Util
import Set exposing (Set)


theEye : Eye
theEye =
    { position = [ 0, 10, 0 ]
    , direction = [ 0, 0, 0 ]
    , up = [ 0, 0, 1 ]
    }


{-| An edge of the cube.
-}
e : Number
e =
    1 / 2


type alias Cube =
    { center : Point
    , body : Room
    }


makeCube : Int -> Number -> Point -> Cube
makeCube dimension size center =
    { center = center
    , body = Util.timesRoom (size / 2) <| cubeBody dimension
    }


cubeNd : Int -> Shape -> Shape
cubeNd dimsLeft cubeN_1d =
    if dimsLeft <= 0 then
        cubeN_1d

    else
        cubeNd (dimsLeft - 1) <|
            (List.map (\x -> [ 0 :: x, 1 :: x ]) cubeN_1d
                |> List.concat
            )


cubeVertices : Int -> Shape
cubeVertices dims =
    cubeNd dims [ [] ]


get : Point -> Dict Point (Set Point) -> Set Point
get p d =
    case Dict.get p d of
        Just ps ->
            ps

        Nothing ->
            [] |> Set.fromList


put : Point -> Point -> Dict Point (Set Point) -> Dict Point (Set Point)
put p1 p2 d =
    d
        |> Dict.insert p1 (Set.insert p2 <| get p1 d)
        |> Dict.insert p2 (Set.insert p1 <| get p2 d)


cubeBody : Int -> Room
cubeBody dims =
    let
        vertices : List Point
        vertices =
            cubeVertices dims

        fillDict : List Point -> Dict Point (Set Point) -> Dict Point (Set Point)
        fillDict points d =
            case points of
                [] ->
                    d

                [ p ] ->
                    d

                p1 :: p2 :: rest ->
                    fillDict (p2 :: rest) (put p1 p2 d)

        dict : Dict Point (Set Point)
        dict =
            fillDict vertices Dict.empty

        eachVertex : List Point -> Dict Point (Set Point) -> Room -> ( Room, Dict Point (Set Point) )
        eachVertex vs d res =
            case vs of
                [] ->
                    ( res, d )

                vertex :: rest ->
                    let
                        linesToAdjacents : List Point -> Dict Point (Set Point) -> Room -> ( Room, Dict Point (Set Point) )
                        linesToAdjacents adjacents d2 res2 =
                            case adjacents of
                                [] ->
                                    ( res2, d2 )

                                p :: ptail ->
                                    if Set.member vertex <| get p d then
                                        linesToAdjacents ptail d2 res2

                                    else
                                        linesToAdjacents ptail
                                            (put vertex p d2)
                                            ([ vertex, p ] :: res)
                    in
                    linesToAdjacents (adjacentPoints vertex) d [ vertices ]

        ( room3, d3 ) =
            eachVertex vertices dict [ vertices ]
    in
    room3


{-| Binariize a number:

    0 -> 1
    /0 -> 0

-}
notidx : Number -> Number
notidx n =
    if n == 0 then
        1

    else
        0


adjacentPoints : Point -> List Point
adjacentPoints p =
    let
        indexer idx n =
            List.take idx p ++ (notidx n :: List.drop (idx + 1) p)
    in
    List.indexedMap indexer p


missingPoints : Point -> List Point -> List Point
missingPoints point points =
    adjacentPoints point
        |> Set.fromList
        |> Set.diff (Set.fromList points)
        |> Set.toList


cube3d : Shape
cube3d =
    [ [ -e, -e, -e ]
    , [ -e, e, -e ]
    , [ -e, e, e ]
    , [ -e, -e, e ]
    , [ -e, -e, -e ]

    --face 2
    , [ e, -e, -e ]
    , [ e, e, -e ]
    , [ -e, e, -e ]
    , [ -e, -e, -e ]

    --face 3
    , [ -e, -e, e ]
    , [ -e, e, e ]
    , [ -e, e, -e ]
    , [ -e, -e, -e ]

    --new base
    , [ e, -e, -e ]

    -- face 4
    , [ e, e, -e ]
    , [ e, e, e ]
    , [ e, -e, e ]
    , [ e, -e, -e ]

    -- face 5
    , [ -e, -e, -e ]
    , [ -e, e, -e ]
    , [ e, e, -e ]
    , [ e, -e, -e ]

    -- face 6
    , [ e, e, -e ]
    , [ e, e, e ]
    , [ e, -e, e ]
    , [ e, -e, -e ]
    ]


type alias Model =
    { count : Int
    , eye : Eye
    , shape : Shape
    , projected : Shape
    }


initialModel : Model
initialModel =
    { count = 0
    , eye = theEye
    , shape = cube3d
    , projected = projectShape cube3d theEye
    }


projectShape : Shape -> Eye -> Shape
projectShape shape eye =
    List.map (\p -> Projection.project p eye) shape


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }


h1 : String -> Html msg
h1 s =
    Html.h1 [] [ Html.text s ]


view : Model -> Html Msg
view model =
    div []
        [ h1 "billstclair/elm-projection example"
        , div []
            [ text "Projected cube: "
            , text <| Debug.toString model.projected
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
