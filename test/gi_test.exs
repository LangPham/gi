defmodule GiTest do
  use ExUnit.Case
  doctest Gi

  test "greets the world" do
    assert Gi.hello() == :world
  end
end
