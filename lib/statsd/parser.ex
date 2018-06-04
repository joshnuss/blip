defmodule StatsD.Parser do
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

  defparsec :tokenize, bucket |> optional(number_part) |> optional(type_part)

  def parse(string) do
    case tokenize(string) do
      {:ok, data, _, _, _, _} ->
        normalize(data)
      oops ->
        IO.inspect(oops)
    end
  end

  def normalize([bucket, ":", count, "|", type]) do
    {@types[type], bucket, count}
  end

  def normalize([bucket, "|", type]) do
    {@types[type], bucket, 1}
  end

  def normalize([bucket, ":", count]) do
    {:counter, bucket, count}
  end

  def normalize([bucket]) do
    {:counter, bucket, 1}
  end
end
