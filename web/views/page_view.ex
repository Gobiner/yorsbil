defmodule Yorsbil.PageView do
  use Yorsbil.Web, :view

  def randword do
    # :random.seed(:os.timestamp)

    vowels = ~w(æ ɑː ɒ ɔː ɪ iː ɛ ʌ ʊ uː eɪ aɪ ɔɪ oʊ aʊ ə i ɜːr ɑːr ɔːr ɪr ɛr ʊr ər)
    consonants = ~w(m n ŋ p b t d k g tʃ dʒ f v θ s z ʃ ʒ h r j w l)
    num_syllables = [1,2,3,4] |> Enum.random
    onset_phonemes = consonants
            -- ~w(ŋ)
            ++ ~w(pl bl kl ɡl pr br tr dr kr ɡr tw dw ɡw kw pw)
            ++ ~w(fl sl θl fr θr ʃr hw sw θw vw)
            ++ ~w(pj bj tj dj kj ɡj mj nj fj vj θj sj zj hj lj)
            ++ ~w(sp st sk sm sn sf sθ spl skl spr str skr skw smj spj stj skj sfr)
    coda = consonants
            -- ~w(y w h)
            ++ ~w(lp lb lt ld ltʃ ldʒ lk)
            ++ ~w(rp rb rt rd rtʃ rdʒ rk rɡ)
            ++ ~w(lf lv lθ ls lʃ)
            ++ ~w(rf rv rθ rs rz rʃ)
            ++ ~w(lm ln rm rn rl)
            ++ ~w(mp nt nd ntʃ ndʒ ŋk)
            ++ ~w(mf mθ nθ ns nz ŋθ)
            ++ ~w(ft sp st sk)
            ++ ~w(fθ pt kt)
            ++ ~w(pθ ps tθ ts dθ ks)
            ++ ~w(lpt lfθ lts lst lkt lks)
            ++ ~w(rmθ rpt rps rts rst rkt)
            ++ ~w(mpt mps ndθ ŋkt ŋks ŋkθ)
            ++ ~w(ksθ kst)

    syllable_structure = [[onset_phonemes, vowels, coda], [onset_phonemes, vowels], [vowels, coda]]

    syllables = for x <- 1..num_syllables,
                  do: syllable_structure |> Enum.random |> Enum.map(&Enum.random/1)

    "/" <> (syllables |> Enum.join(".")) <> "/"
  end
end
