-- Simple hello world
helloWorld = putStrLn "Hello World"

------------------------------------------------------------
-- Aufzählungstypen
-- data Typname = Konstante1 | Konstante2 | ... | KonstanteN

data Anime = OnePunchMan | DeathNote | ThePromisedNeverland

animeToString :: Anime -> String
animeToString a = case a of
    OnePunchMan -> "OnePunchMan"
    DeathNote   -> "DeathNote"
    _           -> "Unknown"

-- Oder pattern matching
animeIs ThePromisedNeverland = "ThePromisedNeverland"

------------------------------------------------------------
-- Produkttyp - Zusammenfassung verschiedener Werte
-- Kartesischer Produkt der Mengen Mi-Mn die (mi...mn) bilden
-- data Typname = KonstruktorName Typ1 | Typ2 | ... | TypN
-- e.g. Tupel

data AnimeRate = AnimeRate Anime Int


printAnimeTupel :: AnimeRate -> IO ()
printAnimeTupel (AnimeRate anime rate) = do
    let animeName = animeToString anime
    let rateStr   = show rate
    let result    = animeName ++ ", Rate: " ++ rateStr
    putStrLn result


-- Record syntax
data SuperAnimeRate = SuperAnimeRate { anime :: Anime, rate :: Int}
printSuperAnime :: SuperAnimeRate -> IO ()
printSuperAnime SuperAnimeRate { rate = rate, anime = anime } = do
    let result = animeToString anime ++ ", Rate: " ++ show rate
    putStrLn result

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

plus3 :: Int -> (Int -> (Int -> Int))
plus3 a b c = a + b + c

mul :: Int -> Int -> Int
mul x y = x * y


main = do
    helloWorld
    let animeA = animeToString OnePunchMan
    putStrLn animeA
    let animeB = animeIs ThePromisedNeverland
    putStrLn animeB
    let animeRate = AnimeRate OnePunchMan 1
    printAnimeTupel animeRate
    let superAnimeRate =
            SuperAnimeRate { rate = 10, anime = ThePromisedNeverland }
    printSuperAnime superAnimeRate
    let animeRate    = rate superAnimeRate
    let animeRateStr = show animeRate
    putStrLn animeRateStr
    let foo = applyTwice (++ " HaHa") "Hello" in putStrLn foo
    let three = plus3 3 2 1 in print three
    let res = mul 3 3 in print res
