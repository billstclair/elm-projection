--------------------------------------------------------------------------------
--
-- Render.elm
-- Render types.
-- Copyright (c) 2025 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE
--
----------------------------------------------------------------------


module Projection.Render exposing (renderShape, renderRoom)

{-| Render shapes

@docs renderShape, renderRoom

-}

import Projection
import Projection.Types exposing (Eye, Point, Room, Shape)
import Svg exposing (Svg)


pointDims : Point -> String
pointDims point =
    case point of
        [ x, y ] ->
            String.fromFloat x
                ++ ","
                ++ String.fromFloat y

        _ ->
            Svg.text <| "Point doesn't have two dimensions" ++ Debug.toString point


shapePointDims : Shape -> String
shapePointDims shape =
    let
        addPoint p s =
            s ++ " " ++ pointDims poins
    in
    List.foldl addPoint "" shape


{-| Render a `Shape`.
-}
renderShape : Shape -> Svg msg
renderShape shape =
    Svg.polyline [ points <| shapePointDims shape ]
        []


{-| Render a `Room`.
-}
renderRoom : Room -> Eye -> Svg msg
renderRoom room eye =
    svg [] <|
        List.map (\s -> renderShape s eye) room
