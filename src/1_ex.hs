-------------------------------------------------------------
-- Wiederholung
-- Implementierung von Funktionen aus der Standard-Bibliothek
-- Y.M. @LMU
-------------------------------------------------------------
import           Prelude                 hiding ( uncurry
                                                , flip
                                                , (.)
                                                , map
                                                , zip
                                                , zipWith
                                                , zip
                                                , foldl
                                                )
import           Control.Exception

assertEqual :: Eq a => a -> a -> IO ()
assertEqual x y = print (x == y)

-- A1-1 Funktionsdefinitionen
-- a) Uncurrying
-- > uncurry (/) (1,2) == 0.5
-- INFO:
--- Uncurried is a function that does not take 1 argument as per default in Haskell,
--- however takes in a tuple of type (a, b) and gives some value c
--- f :: (a, b) -> c - uncurried function as compared to f :: a -> b -> curried function
--- instead of multiple arguments get sequence of functions (currying)

uncurry :: (a -> b -> c) -> ((a, b) -> c)
uncurry f (x, y) = f x y

-- b) Anwendung einer Funktion mit zwei Argumenten auf ein Paar
-- > (1, 2) ||> (/) == 0.5

(||>) :: (a, b) -> (a -> b -> c) -> c
(x, y) ||> f = f x y

-- c) Vertauschung der Reihenfolge der Funktionsargumente
-- > flip (/) 2 1 == 0.5
flip :: (a -> b -> c) -> (b -> a -> c)
flip f x y = f y x

-- d) Funktionskomposition
-- > ((x -> x + 3) . (y -> y * 2)) 1 == 5
(.) :: (b -> c) -> (a -> b) -> a -> c
(.) f g x = f (g x)

-- e) map
-- > map (+10) [1, 2, 3, 4, 5] == [11, 12, 13, 14, 15]
map :: (a -> b) -> [a] -> [b]
map _         []            = []
map predicate (head : rest) = predicate head : map predicate rest

-- f) zip:
-- > zip ['a', 'b', 'c'] [1, 2, 3, 4, 5] == [('a', 1), ('b', 2), ('c', 3)]
zip :: [a] -> [b] -> [(a, b)]
zip _                 []                = []
zip []                _                 = []
zip (head_a : rest_a) (head_b : rest_b) = (head_a, head_b) : zip rest_a rest_b

-- g) Zippen mit Funktionsanwendung:
-- > zipWith (+) [1..] [1..3] == [2, 4, 6]
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith _ _  [] = []
zipWith _ [] _  = []
zipWith op (head_a : rest_a) (head_b : rest_b) =
    op head_a head_b : zipWith op rest_a rest_b

-- h) Falten nach links:
-- > foldl (flip (:)) [] [1..3] = [3, 2, 1]
-- > foldl ((\acc x -> x : acc)) [] [1..3] = [3, 2, 1]
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl op acc []            = acc
foldl op acc (head : rest) = foldl op accumulated rest
    where accumulated = op acc head

-- TODO:
-- | A1-2 Datentypen
-- Einige
-- welcher Listen der Länge 0 bis 3 repräsentieren kann,
-- d.h. ein einzelner Wert des Typs Einige enthält
-- entweder einen inneren Wert, oder zwei/drei/keine Werte.
-- Die inneren Werte sind jeweils vom gleichen Typ.
-- Der Datentyp soll automatisch der Klasse Show
-- angehören.
data Einige a = Nil | List Einige a -- <--- i m doing something wrong here, need to figure out it.

main = do
    assertEqual (uncurry (/) (1, 2))         0.5
    assertEqual ((1, 2) ||> (/))             0.5
    assertEqual (flip (/) 2 1)               0.5
    assertEqual (((+ 3) . (* 2)) 1)          5
    assertEqual (map (+ 10) [1, 2, 3, 4, 5]) [11, 12, 13, 14, 15]
    assertEqual (zip ['a', 'b', 'c'] [1, 2, 3, 4, 5])
                [('a', 1), ('b', 2), ('c', 3)]
    assertEqual (zipWith (+) [1 ..] [1 .. 3])           [2, 4, 6]
    assertEqual (foldl (+) 0 [1 .. 3])                  6
    assertEqual (foldl (flip (:)) [] [1 .. 3])          [3, 2, 1]
    assertEqual (foldl (\acc x -> x : acc) [] [1 .. 3]) [3, 2, 1]
