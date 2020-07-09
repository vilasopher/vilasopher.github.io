module DnD where

data Roll  = A | D deriving Show
type CDF   = Int -> Double
type PMF   = Int -> Double
type Range = [Int]
data Die   = Die CDF Range

cdfTransform :: CDF -> Roll -> CDF
cdfTransform f A x = (f x) ^ 2
cdfTransform f D x = 1 - (1 - f x)^2

cdfTransforms :: CDF -> [Roll] -> CDF
cdfTransforms = foldl cdfTransform

pmf :: CDF -> PMF
pmf f x = f x - f (x - 1)

expectedValue :: CDF -> Range -> Double
expectedValue f r = sum $ (\x -> fromIntegral x * pmf f x) <$> r

rollsEV :: Die -> [Roll] -> Double
rollsEV (Die f r) rs = expectedValue (cdfTransforms f rs) r

nudge :: Die -> Double -> [Roll] -> [Roll]
nudge d e rs
    | rollsEV d rs < e = rs ++ [A]
    | rollsEV d rs > e = rs ++ [D]
    | otherwise        = rs

rollSequences :: Die -> Double -> [[Roll]]
rollSequences d e = iterate (nudge d e) []

rollSequence :: Die -> Double -> Double -> [Roll]
rollSequence d e a = head . dropWhile tooFar $ rollSequences d e
    where tooFar = \rs -> abs (rollsEV d rs - e) > a
