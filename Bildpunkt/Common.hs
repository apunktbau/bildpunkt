{-# LANGUAGE ScopedTypeVariables #-}
module Bildpunkt.Common where

import Data.Array.Accelerate hiding (Vector)

type Vector        = (Float, Float, Float)
type Position      = Vector
type Direction     = Vector
type Ray           = (Position, Direction)
type Camera        = (Position, Direction, Float, Float)
type Resolution    = (Int,Int)
type Color         = Vector
type DistanceField = Exp Vector -> Exp (Float, Color)

red,green,blue,black,white :: Color
red   = (1,0,0)
green = (0,1,0)
blue  = (0,0,1)
black = (0,0,0)
white = (1,1,1)

moveOrigin :: Exp Float -> Exp Ray -> Exp Ray
moveOrigin f = lift1 $ \(p :: Exp Position, d :: Exp Direction)
                     -> (vecAdd p (vecScale d f), d)

vecNormalize :: Exp Vector -> Exp Vector
vecNormalize v = vecScale v (1.0 / (vecLength v))

vecLength :: Exp Vector -> Exp Float
vecLength = sqrt . vecLengthSqr

vecLengthSqr :: Exp Vector -> Exp Float
vecLengthSqr v = vecDot v v

vecCross :: Exp Vector -> Exp Vector -> Exp Vector
vecCross = lift2 $ \(x :: Exp Float, y :: Exp Float, z :: Exp Float) 
                    (u :: Exp Float, v :: Exp Float, w :: Exp Float) 
                 -> ((y*w) - (z*v), (z*u) - (x*w), (x*v) - (y*u))

vecDot :: Exp Vector -> Exp Vector -> Exp Float
vecDot = lift2 $ \(x :: Exp Float, y :: Exp Float, z :: Exp Float) 
                  (u :: Exp Float, v :: Exp Float, w :: Exp Float) 
               -> (x * u) + (y * v) + (z * w)

vecSub :: Exp Vector -> Exp Vector -> Exp Vector
vecSub a b = vecAdd a (vecInvert b)

vecScale :: Exp Vector -> Exp Float -> Exp Vector
vecScale v f = lift1 (\(x :: Exp Float, y :: Exp Float, z :: Exp Float) -> (f * x, f * y, f * z)) v

vecAdd :: Exp Vector -> Exp Vector -> Exp Vector
vecAdd = lift2 $ \(x :: Exp Float, y :: Exp Float, z :: Exp Float) 
                  (u :: Exp Float, v :: Exp Float, w :: Exp Float) 
               -> (x + u, y + v, z + w)

vecInvert :: Exp Vector -> Exp Vector
vecInvert = lift1 $ \(x :: Exp Float, y :: Exp Float, z :: Exp Float) -> (-x,-y,-z)
