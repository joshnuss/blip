defmodule Blip.Parser do
  import NimbleParsec

  @types %{
    "c"  => :counter,
    "g"  => :guage,
    "ms" => :timing,
    "s"  => :set
  }

  number = integer(min: 1)
  acceptable_chars = [?a..?z] ++ [?0..?9] ++ [?-, ?_]
  bucket = ascii_string(acceptable_chars, min: 1)

  type = @types
         |> Map.keys()
         |> Enum.map(&string/1)
         |> choice

  number_part = string(":") |> concat(number)
  type_part = string("|") |> concat(type)
  tags_part = string("|#") |> concat(ascii_string([], min: 1))

  defparsec :tokenize, bucket |> optional(number_part) |> optional(type_part) |> optional(tags_part)

  def parse(string) do
    case tokenize(string) do
      {:ok, data, _, _, _, _} ->
        normalize(data, {:counter, "", 1, []})
      oops ->
        IO.inspect(oops)
    end
  end

  def normalize([], acc) do
    acc
  end

  def normalize(["|#", tags | t], {type, bucket, count, _tags}) do
    normalize(t, {type, bucket, count, String.split(tags, ",")})
  end

  def normalize(["|", type | t], {_type, bucket, count, tags}) do
    normalize(t, {@types[type], bucket, count, tags})
  end

  def normalize([":", count | t], {type, bucket, _count, tags}) do
    normalize(t, {type, bucket, count, tags})
  end

  def normalize([bucket|t], {type, _bucket, count, tags}) do
    normalize(t, {type, bucket, count, tags})
  end
end
