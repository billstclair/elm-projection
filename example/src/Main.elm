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


makeCube : Int -> Number -> Point -> Room
makeCube dimension size center =
    (cubeBody dimension |> joinLines)
        |> Util.timesRoom size
        |> Util.addPointToRoom (Util.pplus (List.repeat dimension -0.5) center)


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
    Maybe.withDefault Set.empty <| Dict.get p d


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

        eachVertex : List Point -> Dict Point (Set Point) -> Room -> ( Room, Dict Point (Set Point) )
        eachVertex vs d room =
            case vs of
                [] ->
                    ( room, d )

                vertex :: rest ->
                    let
                        ( room3, d3 ) =
                            linesToAdjacents vertex (adjacentPoints vertex) d room
                    in
                    eachVertex rest d3 room3
    in
    eachVertex vertices Dict.empty [] |> Tuple.first


cdr : List a -> List a
cdr list =
    case List.tail list of
        Nothing ->
            []

        Just tail ->
            tail


joinLines : Room -> Room
joinLines room =
    let
        loop : Room -> Room -> Room
        loop shapes res =
            case shapes of
                [] ->
                    List.reverse res

                [ shape ] ->
                    List.reverse <| shape :: res

                shape :: rest ->
                    let
                        ( first, last ) =
                            listFirstAndLast shape

                        inner : Room -> List Shape -> Room
                        inner innerShapes innerRes =
                            case innerShapes of
                                [] ->
                                    loop rest <| shape :: res

                                innerShape :: innerRest ->
                                    let
                                        ( innerFirst, innerLast ) =
                                            listFirstAndLast innerShape
                                    in
                                    if first == innerFirst then
                                        let
                                            join =
                                                (List.reverse <| cdr shape) ++ innerShape
                                        in
                                        joinLines <| join :: innerRest ++ innerRes ++ res

                                    else if last == innerFirst then
                                        let
                                            join =
                                                shape ++ cdr innerShape
                                        in
                                        joinLines <| join :: innerRest ++ innerRes ++ res

                                    else if innerLast == first then
                                        let
                                            join =
                                                innerShape ++ cdr shape
                                        in
                                        joinLines <| join :: innerRest ++ innerRes ++ res

                                    else if last == innerLast then
                                        let
                                            join =
                                                shape ++ cdr (List.reverse innerShape)
                                        in
                                        joinLines <| join :: innerRest ++ innerRes ++ res

                                    else
                                        inner innerRest <| innerShape :: innerRes
                    in
                    inner (cdr shapes) []
    in
    loop room []


listFirstAndLast : List a -> ( Maybe a, Maybe a )
listFirstAndLast list =
    case List.head list of
        Nothing ->
            ( Nothing, Nothing )

        jh ->
            case List.head (List.reverse list) of
                Nothing ->
                    ( jh, Nothing )

                jt ->
                    ( jh, jt )


linesToAdjacents : Point -> List Point -> Dict Point (Set Point) -> Room -> ( Room, Dict Point (Set Point) )
linesToAdjacents vertex adjacents d res =
    case adjacents of
        [] ->
            ( res, d )

        p :: ptail ->
            if Set.member vertex <| get p d then
                linesToAdjacents vertex ptail d res

            else
                linesToAdjacents vertex
                    ptail
                    (put vertex p d)
                    ([ vertex, p ] :: res)


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
