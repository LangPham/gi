defmodule GiTest do
  use ExUnit.Case
  doctest Gi

  describe "rust" do

    test "add" do
      # path = "test/example.jpg"
      path = "test/frame.png"

      re = Gi.open(path)
      IO.inspect(re, label: "RESULT RUST=====\n")
    end
  end
end
