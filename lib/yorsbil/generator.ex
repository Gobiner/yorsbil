defmodule Yorsbil.Generator do
  import DefMemo
  def randword do
    :random.seed(:os.timestamp)

    vowels = ~w(æ ɑː ɒ ɔː ɪ iː ɛ ʌ ʊ uː eɪ aɪ ɔɪ oʊ aʊ ə i ɑːr ɔːr ɪr ɛr ʊr ər)
    consonants = ~w(m n ŋ p b t d k g tʃ dʒ f v θ s z ʃ ʒ h r j w l)
    onset_phonemes = consonants
            -- ~w(ŋ)
            ++ ~w(pl bl kl ɡl pr br tr dr kr ɡr tw dw ɡw kw pw)
            ++ ~w(fl sl θl fr θr ʃr hw sw θw vw)
            ++ ~w(pj bj tj dj kj ɡj mj nj fj vj θj sj zj hj lj)
            ++ ~w(sp st sk sm sn sf sθ spl skl spr str skr skw smj spj stj skj sfr)
    coda = consonants
            -- ~w(j w h r)
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
    num_syllables = [1,2,3,4] |> Enum.random

    syllables = for _ <- 1..num_syllables,
                  do: syllable_structure |> Enum.random |> nonrandom

    "/" <> (syllables |> Enum.join(".")) <> "/"
  end

  def nonrandom(inp) do
    nonrandom(inp, [])
  end

  def nonrandom([head | rest], []) do
    nonrandom(rest, [Enum.random(head)])
  end
  def nonrandom([head | rest], [last | _] = acc) do
    nonrandom(rest, [nextphoneme(head, last) | acc])
  end
  def nonrandom([], acc) do
    acc |> Enum.reverse |> Enum.join
  end

  def nextphoneme(choices, prev) do
    case markov_map[prev |> String.graphemes |> List.last] do
      %{} -> choices |> Enum.random
      probs when is_map(probs) ->
        probs = probs
                |> Enum.filter(&(Enum.any?(choices, fn ch -> (ch |> String.graphemes |> List.first) == (&1 |> elem(0) |> String.graphemes |> List.first) end)))
                |> Map.new
        x = random_transition(probs)
        possibilities = choices |> Enum.filter(&((&1 |> String.graphemes |> List.first) == (x |> String.graphemes |> List.first)))
        possibilities |> Enum.random
      _ -> choices |> Enum.random
    end
  end

  def random_transition(inp) do
    x = :random.uniform * (inp |> Map.values |> Enum.sum)
    Enum.reduce_while(inp, 0,
        fn {l, prob}, acc ->
            if acc+prob >= x,
            do: {:halt, l},
          else: {:cont, prob+acc}
        end)
  end

  defmemo markov_map do
    Yorsbil.CmuDict.dictentries
      |> Enum.map(&(elem(&1,1)))
      |> Enum.map(&(Enum.join(&1)))
      |> Enum.map(&(&1 |> String.graphemes |> Enum.chunk(2,1) |> Enum.map(fn [a,b] -> {a,b} end)))
      |> List.flatten
      |> Enum.reduce(%{},
          fn ({a,b}, acc) ->
            Map.update(acc, a, %{b => 1},
                fn map ->
                  Map.update(map, b, 1, &(&1 + 1))
                end)
          end)
      |> normalize
  end

  # copied from Faust.Table.normalize
  # https://github.com/jquadrin/faust/blob/0e605ae81db88a768f122a420a8c3d382607562f/lib/faust/table.ex#L48
  defp normalize(table) do
    Enum.reduce(table, %{},
      fn {node, transitions}, acc ->
        sum = transitions |> Map.values |> Enum.sum
        Map.put(acc, node, Enum.reduce(transitions, %{},
          fn {transition, val}, tacc ->
            Map.put(tacc, transition, val/sum)
          end)
        )
      end)
  end
end
