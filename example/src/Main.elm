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
    , body = []
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


cubeBody : Int -> Room
cubeBody dims =
    let
        vertices : List Point
        vertices =
            cubeVertices dims

        visited : Set Point
        visited =
            Set.empty

        fillDict : List Point -> Dict Point (List Point) -> Dict Point (List Point)
        fillDict points d =
            case points of
                [] ->
                    d

                [ p ] ->
                    d

                p1 :: p2 :: rest ->
                    fillDict (p2 :: rest) (Dict.insert p1 (p2 :: rest) d)

        lines : List (List Point)
        lines =
            [ vertices ]

        dict : Dict Point (List Point)
        dict =
            fillDict vertices Dict.empty
    in
    fillOutCubes [ vertices ] dict


fillOutCubes : List Point -> Dict Point (List Point) -> Room
fillOutCubes vertices dict =
    -- TODO
    let
        folder : Point -> List Point -> Dict Point (List Point) -> Dict Point (List Point)
        folder p ps d =
            let
                missing : List Point
                missing =
                    missingPoints p ps

                new : List ( Point, List Point )
                new =
                    List.map (\x -> ( p, x )) missing

                new2 : List ( Point, List Point )
                new2 =
                    List.map (\x -> ( x, p )) missing
            in
            Dict.fromList new
                |> Dict.union (Dict.fromList new2)
                |> Dict.union d
    in
    Dict.foldl folder dict dict
        |> Dict.toList
        |> List.map (\( x, toys ) -> x :: toys)


missingPoints : Point -> List Point -> List Point
missingPoints point points =
    -- TODO
    points


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
