defmodule Yorsbil.PageView do
  use Yorsbil.Web, :view

  def randword do
    vowels = ["a", "e", "i", "o", "u", "ae", "ee", "ie", "oe", "ue", "oo", "ar", "ur", "or", "au", "er", "ow", "oi", "air", "ear"]
    consonants = ["b", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "w", "wh", "y", "z", "th", "ch", "sh", "zh", "ng"]
    num_syllables = [1,2,3,4] |> Enum.random
    onset_phonemes = consonants -- ["ng", "zh"] ++ ["pl", "bl", "kl", "gl", "pr", "br", "tr", "dr", "kr", "gr", "tw", "dw", "gw", "kw", "pw", "fl", "sl", "thl", "fr", "thr", "shr", "hw", "sw", "thw", "vw", "sp", "st", "sk", "sm", "sn", "spl", "skl", "spr", "str", "skr", "skw"]
    coda = consonants -- ["y", "wh", "h"] ++ ["lp", "lb", "lt", "ldj", "lk", "rp", "rb", "rt", "rd", "rk", "rg", "lf", "lv", "lth", "ls", "lzh", "rf", "rv", "rth", "rs", "rz", "lm", "ln", "rm", "rn", "rl", "mp", "nt", "nd", "ntzh", "ndj", "mf", "mth", "ns", "nz", "ft", "sp", "st", "sk", "fth", "pt", "kt", "pth", "ps", "ts", "dth", "ks", "lpt", "lfth", "lts", "lst", "lkt", "lks", "rmth", "rpt", "rps", "rts", "rst", "rkt", "mpt", "mps", "ndth", "ksth", "kst"] 

    syllable_structure = [[onset_phonemes, vowels, coda], [onset_phonemes, vowels], [vowels, coda]]

    syllables = for x <- 1..num_syllables, do: syllable_structure |> Enum.random |> Enum.map(&Enum.random/1)

    syllables |> Enum.join 
  end
end
