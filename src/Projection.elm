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


module Projection exposing
    ( project, projectEye, projectPointAndEye, projectSeer
    , projectTo2D, projectShapeTo2D
    , rotatePoint, rotateShape, rotateRoom
    )

{-| Do geometric projection.


# Types are defined in `Projection.Types`.

@docs project, projectEye, projectPointAndEye, projectSeer
@docs projectTo2D, projectShapeTo2D


# Rotation about a line.

@docs rotatePoint, rotateShape, rotateRoom

-}

import Projection.Types as Types exposing (Eye, Point, Room, Seer, Shape, Vector)
import Projection.Util as Util
    exposing
        ( eyeDimension
        , papply
        , papply1
        , pdivide
        , pdot
        , pminus
        , pointDimension
        , pplus
        , ptimes
        , removeDimension
        , removeEyeDimension
        )


{-| Project a point to one fewer dimensions.
-}
project : Point -> Eye -> Point
project point eye =
    let
        dim =
            pointDimension point

        eyeDim =
            eyeDimension eye

        dimsOk =
            dim == eyeDim

        dims =
            ( dim, eyeDim )

        msg =
            if dimsOk then
                dims

            else
                Debug.log "Projection.project, dims don't match." dims

        { position, direction, up } =
            eye

        positionOk =
            removeDimension 1 position == [ 0, 0 ]

        directionOk =
            direction == List.repeat dim 0

        upOk =
            up == [ 0, 1, 0 ]

        eye2 =
            if positionOk && directionOk && upOk then
                eye

            else
                Debug.log "  Eye not OK" eye

        ( l, e ) =
            ( List.repeat dim 0, position )

        p =
            point

        -- (L-E)•(P-E) / (L-E)•(L-E)
        lE_PEoverLE_LE =
            pminus l e
                |> pdot (pminus p e)
                |> (/)
                    (pminus l e
                        |> pdot (pminus l e)
                    )

        q =
            pplus e <|
                papply1 ((*) lE_PEoverLE_LE) (pminus p e)
    in
    -- This works only if eye is on the y axis and up is on the z axis.
    removeDimension 2 q


{-| Project a point and eye to 2 dimensions.
-}
projectTo2D : Point -> Eye -> Point
projectTo2D point eye =
    if Util.pointDimension point <= 2 then
        point

    else
        let
            ( p2, e2 ) =
                projectPointAndEye point eye
        in
        projectTo2D p2 e2


{-| Project a `Shape` to 2 dimensions.
-}
projectShapeTo2D : Shape -> Eye -> Shape
projectShapeTo2D shape eye =
    let
        projectOne : Point -> Point
        projectOne point =
            projectTo2D point eye
    in
    List.map projectOne shape


{-| Project an Eye to one fewer dimensions.
-}
projectEye : Eye -> Eye
projectEye eye =
    removeEyeDimension 2 eye


{-| Project a point and the eye to one fewer dimensions.
-}
projectPointAndEye : Point -> Eye -> ( Point, Eye )
projectPointAndEye point eye =
    ( project point eye, projectEye eye )


{-| Same as `project`, but takes a `Seer` as the second arg.
-}
projectSeer : Point -> Seer -> List Point
projectSeer point seer =
    List.map (project point) seer.eyes


{-| Rotate the second point by the number of radians around the line
defined by the origin and the first point. Positive angles drive
that line into the origin, were it a screw.

For derivation, see grok-rotate-nd-scene.html.
I did a stupid conversion of the Python code there.

Here's the Python that Grok wrote:

    import math

    def rotate_point_nD(p, a, theta):
        # Inputs: p (list of n coords), a (list of n coords), theta (radians, clockwise)
        n = len(p)

        # Axis magnitude and normalization
        a_mag = math.sqrt(sum(ai * ai for ai in a))
        a_hat = [ai / a_mag for ai in a]

        # Dot product p · â
        p_dot_a_hat = sum(pi * ahi for pi, ahi in zip(p, a_hat))

        # Parallel component
        p_parallel = [p_dot_a_hat * ahi for ahi in a_hat]

        # Perpendicular component
        p_perp = [pi - ppi for pi, ppi in zip(p, p_parallel)]
        p_perp_mag = math.sqrt(sum(ppi * ppi for ppi in p_perp))

        # If p_perp is zero, no rotation needed
        if p_perp_mag == 0:
            return p

        # Normalize p_perp
        p_perp_hat = [ppi / p_perp_mag for ppi in p_perp]

        # Construct q (perpendicular to a_hat and p_perp)
        u = [1 - a_hat[0]**2] + [-a_hat[0] * a_hat[i] for i in range(1, n)]
        u_dot_p_perp = sum(ui * ppi for ui, ppi in zip(u, p_perp_hat))
        q = [ui - u_dot_p_perp * ppi for ui, ppi in zip(u, p_perp_hat)]

        # Normalize q
        q_mag = math.sqrt(sum(qi * qi for qi in q))
        if q_mag == 0:  # Edge case: pick another e_i if q is zero
            return p_parallel  # Simplest fallback
        q_hat = [qi / q_mag for qi in q]

        # Rotated point
        cos_theta = math.cos(theta)
        sin_theta = math.sin(theta)
        p_prime = [
            p_parallel[i] + cos_theta * p_perp[i] - sin_theta * p_perp_mag * q_hat[i]
            for i in range(n)
        ]

        return p_prime

    # Test
    p = [1, 0, 0]  # 3D example
    a = [0, 0, 1]  # Rotate around z-axis
    theta = math.pi / 2  # 90° clockwise
    p_rotated = rotate_point_nD(p, a, theta)
    print([round(x, 6) for x in p_rotated])  # Should be [0, -1, 0]

-}
rotatePoint : Float -> Point -> Point -> Point
rotatePoint angle axis point =
    -- TODO
    point


{-| Rotate the shape by the number of radians around the line
defined by the origin and the first point.
-}
rotateShape : Float -> Point -> Shape -> Shape
rotateShape angle axis shape =
    -- TODO
    shape


{-| Rotate the room by the number of radians around the line
defined by the origin and the first point.
-}
rotateRoom : Float -> Point -> Room -> Room
rotateRoom angle axis room =
    -- TODO
    room
