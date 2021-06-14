defmodule Gi do
  @moduledoc """
  Documentation for `Gi`.
  """
  import Gi.Command
  import Gi.Image
  alias Gi.{Image, Command}

  @doc """
  Opens image source, raises a `File.Error` exception in case of failure.
  """

  @spec open(binary()) :: Image.t()
  def open(string_path) do
    path =
      string_path
      |> String.trim(".")
      |> Path.expand()
    unless File.regular?(path), do: raise(File.Error)

    %Image{path: path, ext: Path.extname(path)}
  end

  @spec save(Image.t()) :: Image.t()
  def save(image) do
    if length(image.command) > 0 do
      image
    else
      do_command(image)
    end
  end



  @spec add_command(Image.t(), command) :: Image.t() when command: Command.t()
  def add_command(image, command) when is_command(command) do
    command = image.list_command ++ command
    %{image | list_command: command}
  end
  def add_command(image, command), do: image

  defp do_command(image) do
    Enum.reduce(image, fn action, img -> do_action(img, action) end)
  end

  defp do_action(img, action) do
    IO.inspect img, label: "IMG===\n"
    IO.inspect action, label: "ACTION===\n"
    img
  end

end
