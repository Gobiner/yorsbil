defmodule Yorsbil.CmuDict do
  def dictentries() do
    File.read!(filepath)
      |> String.split("\n")
      |> Enum.filter(&(!String.starts_with?(&1, ";")))
      |> Enum.map(&(String.split(&1, " ", parts: 2)))
      |> Enum.filter(&(length(&1)==2))
      |> Enum.map(&({ &1|>hd, &1|>Enum.at(1)|>arpa_to_ipa}))

  end
  def arpa_to_ipa(string) do
    string
      |> String.strip
      |> String.split
      |> Enum.map(&(String.replace(&1, ~r/\d/, "")))
      |> Enum.map(&phoneme/1)
  end

  def phoneme("AO"), do: "ɔː"
  def phoneme("AA"), do: "ɑː"
  def phoneme("IY"), do: "iː"
  def phoneme("UW"), do: "uː"
  def phoneme("EH"), do: "ɛ"
  def phoneme("IH"), do: "ɪ"
  def phoneme("UH"), do: "ʊ"
  def phoneme("AH"), do: "ʌ"
  # def phoneme("AX"), do: "ə"
  def phoneme("AE"), do: "æ"
  def phoneme("EY"), do: "eɪ"
  def phoneme("AY"), do: "aɪ"
  def phoneme("OW"), do: "oʊ"
  def phoneme("AW"), do: "aʊ"
  def phoneme("OY"), do: "ɔɪ"
  def phoneme("P"), do: "p"
  def phoneme("B"), do: "b"
  def phoneme("T"), do: "t"
  def phoneme("D"), do: "d"
  def phoneme("K"), do: "k"
  def phoneme("G"), do: "g"
  def phoneme("CH"), do: "tʃ"
  def phoneme("JH"), do: "dʒ"
  def phoneme("F"), do: "f"
  def phoneme("V"), do: "v"
  def phoneme("S"), do: "s"
  def phoneme("Z"), do: "z"
  def phoneme("TH"), do: "θ"
  def phoneme("DH"), do: "θ"
  def phoneme("SH"), do: "ʃ"
  def phoneme("ZH"), do: "ʒ"
  def phoneme("HH"), do: "h"
  def phoneme("M"), do: "m"
  def phoneme("EM"), do: "ɛm"
  def phoneme("N"), do: "n"
  def phoneme("EN"), do: "ɛn"
  def phoneme("NG"), do: "ŋ"
  def phoneme("ENG"), do: "ŋ"
  def phoneme("L"), do: "l"
  def phoneme("EL"), do: "ɛl"
  def phoneme("R"), do: "r"
  # def phoneme("DX"), do: "t"
  # def phoneme("NX"), do: "t"
  def phoneme("Y"), do: "j"
  def phoneme("W"), do: "w"
  def phoneme("ER"), do: "ɛr"

  def filepath() do
    Path.join(:code.priv_dir(:yorsbil), "data/cmudict-0.7b")
  end
end
