----------------------------------------------------------------------
--
-- Projection.elm
-- Do projection.
-- projection point eye = (newPoint, newEye)
-- newPoint & newEye have one fewer dimensions than point & eye.
-- Copyright (c) 2025 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE
--
----------------------------------------------------------------------


module Projection exposing (project, projectSeer)

{-| Do geometric projection.

Types are defined in `Projection.Types`.

@docs project, projectSeer

-}

import Projection.Types as Types exposing (Eye, Point, Room, Seer, Shape, Vector)
import Projection.Util as Util exposing (papply, pdivide, pminus, pplus, ptimes)


{-| Project a point to one fewer dimensions.
-}
project : Point -> Eye -> ( Point, Eye )
project point eye =
    let
        { position, direction, up } =
            eye
    in
    ( point, eye )


{-| Same as `project`, but takes a `Seer` as the second arg.
-}
projectSeer : Point -> Seer -> ( Point, Seer )
projectSeer point seer =
    let
        ( newPoint, newEye ) =
            project point seer.eye
    in
    ( newPoint, { seer | eye = newEye } )
