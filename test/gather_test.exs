defmodule GatherTest do
  use ExUnit.Case
  doctest Gather

  test "greets the world" do
    assert Gather.hello() == :world
  end
end
