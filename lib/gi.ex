defmodule Gi do
  @moduledoc """
  Manipulating Graphics Interfacing
  """
  import Gi.Command
  import Gi.Image
  alias Gi.{Image, Command}

  @doc """
  Opens image source, raises a `File.Error` exception in case of failure.

  ## Example

       iex>  Gi.open "example.jpg"
       %Gi.Image{
  			 animated: false,
  			 dirty: %{},
  			 ext: ".png",
  			 format: nil,
  			 frame_count: 1,
  			 height: nil,
  			 list_command: [],
  			 path: "example.jpg",
  			 width: nil
  			}
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

  @doc """
  Save image.

  ## Example

      Gi.save()
  """
  @spec save(Image.t()) :: Image.t()
  def save(image) do
    if length(image.list_command) == 0 do
      image
    else
      do_command(image)
    end
  end

  @doc """
  Mogrify image with option.

  ## Example

      # Resize image to width x height with ratio (WxH)
      Gi.open("example.jpg") # example.jpg (300x200)
      |> Gi.gm_mogrify(resize: "200x100")
      |> Gi.save() # => example.jpg (150x100)

      # Resize image to width x height (WxH!)
      Gi.open("example.jpg") # example.jpg (300x200)
      |> Gi.gm_mogrify(resize: "200x100!")
      |> Gi.save() # => example.jpg (200x100)

      # Format image to jpg, png, webp, ...
      Gi.open("example.jpg")
      |> Gi.gm_mogrify(format: "webp")
      |> Gi.save() # => create new file "example.webp"

      # Draw text on image (text x,y 'string')
      Gi.open("example.jpg")
      |> Gi.gm_mogrify(draw: "text 150,150 'Theta.vn'")
      |> Gi.save()

      # Multi utilities
      Gi.open("example.jpg")
      |> Gi.gm_mogrify([resize: "300x200", draw: "text 150,150 'Theta.vn'"])
      |> Gi.save()
  """
  def gm_mogrify(image, kw) do
    param = Enum.reduce(kw, [], fn x, acc -> acc ++ ["-#{Atom.to_string(elem(x, 0))}", elem(x, 1)] end)

    c = %Command{
      command: :gm,
      sub_command: :mogrify,
      param: param
    }

    format =
      Keyword.pop_values(kw, :format)
      |> elem(0)
      |> List.last
    dirty =
      case format do
        nil -> %{}
        ext -> %{mogrify_format: ext}
      end
    image = %{image | dirty: dirty}

    add_command(image, c)
  end

  @spec add_command(Image.t(), command) :: Image.t() when command: Command.t()
  defp add_command(image, command) when is_command(command) do
    command = image.list_command ++ [command]
    %{image | list_command: command}
  end
  defp add_command(image, _), do: image

  defp do_command(image) do
    Enum.reduce(image.list_command, image, fn action, img -> do_action(img, action) end)
  end

  defp do_action(img, action) do
    case action.command do
      :gm -> do_gm(img, action)
      _ -> img
    end
  end

  defp do_gm(image, action) do
    case action.sub_command do
      nil -> image
      :mogrify ->
        param = [Atom.to_string(action.sub_command) | action.param] ++ [image.path]
        System.cmd(Atom.to_string(action.command), param)
        case Map.get(image.dirty, :mogrify_format) do
          nil -> image
          ext ->
            file = image.path
            %{image | path: "#{Path.rootname(file)}.#{ext}"}
        end
      _ -> image #Todo: for sub command

    end
  end
end
