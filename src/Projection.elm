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


module Projection exposing (project)

{-| Do geometric projection.

Types are defined in `Projection.Types`.

@docs project

-}

import Projection.Types exposing (Eye, Point, Room, Rotation, Shape, Vector)


{-| Project a point to one fewer dimensions.
-}
project : Point -> Eye -> ( Point, Eye )
project point eye =
    -- TODO
    ( point, eye )
