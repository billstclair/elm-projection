module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List.Extra as LE
import Projection exposing (project)
import Projection.Types exposing (Eye, Number, Point, Room, Shape)
import Projection.Util as Util


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


cubeVertices : Int -> Room
cubeVertices dims =
    []


cubeBody : Int -> Number -> Point -> Room
cubeBody dimension size center =
    let
        sizeo2 =
            size / 2
    in
    -- TODO
    []


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
