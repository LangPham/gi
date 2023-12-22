defmodule GiTest do
  use ExUnit.Case
  doctest Gi

  test "open_file fail" do
    re = Gi.open("test/example1.jpg")
    assert re == %Gi.Error{message: :not_found}
  end

  test "open_file " do
    re = Gi.open("test/example.jpg")

    assert re == %Gi.Image{
             path: "test/example.jpg",
             ext: ".jpg",
             format: nil,
             width: nil,
             height: nil,
             animated: false,
             frame_count: 1,
             list_command: [],
             dirty: %{}
           }
  end
end
