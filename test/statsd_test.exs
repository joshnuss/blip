defmodule StatsDTest do
  use ExUnit.Case
  doctest StatsD

  test "greets the world" do
    assert StatsD.hello() == :world
  end
end
