--------------------------------------------------------------------------------
--
-- Types.elm
-- Types for Projection.elm.
-- Copyright (c) 2025 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE
--
----------------------------------------------------------------------


module Projection.Types exposing
    ( Number, Point, Vector, Rotation
    , Shape, Room
    , Eye, Seer
    )

{-| Types for Projection.elm
This module allows you to project a point into one fewer dimensions,
given the eye looking at it.


# Basic types

@docs Number, Point, Vector, Rotation


# Things

@docs Shape, Room


# Seeing

@docs Eye, Seer

-}


{-| A number. Currently a `Float`.
-}
type alias Number =
    Float


{-| An ordered list of `Number`s, one for each dimension.
-}
type alias Point =
    List Number


{-| A number, in radians.
-}
type alias Rotation =
    Number


{-| Two points, from & to
-}
type alias Vector =
    { from : Point
    , to : Point
    }


{-| An ordered list of `Point`s.

To draw a shape, draw a line from each point to the next one.

-}
type alias Shape =
    List Point


{-| A list of `Shape`s.
-}
type alias Room =
    List Shape


{-| The observer for the projection.
-}
type alias Eye =
    { position : Point
    , direction : Vector
    , rotation : Rotation
    }


{-| A `Shape` that can see.
-}
type alias Seer =
    { room : Room
    , eye : Eye
    }
