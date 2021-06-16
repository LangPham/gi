defmodule Gi do
  @moduledoc """
  Manipulating Graphics Interfacing
  """
  import Gi.Command
  import Gi.Image
  alias Gi.{Image, Command}

  @doc """
  Opens image source, raises a `File.Error` exception in case of failure.
  ## Parameters

    - path: path to file image.

  ## Example

      iex>  Gi.open("test/example.jpg")
      %Gi.Image{
        animated: false,
        dirty: %{},
        ext: ".jpg",
        format: nil,
        frame_count: 1,
        height: nil,
        list_command: [],
        path: "test/example.jpg",
        width: nil
      }
  """
  @spec open(binary()) :: Image.t()
  def open(path) do
    unless File.regular?(path), do: raise(File.Error)
    %Image{path: path, ext: Path.extname(path)}
  end

  @doc """
  Get information of image.

  ## Example

      iex>  Gi.open("test/example.jpg")
      ...>  |> Gi.gm_identify
      %Gi.Image{
        animated: false,
        dirty: %{},
        ext: ".jpg",
        format: "JPEG (Joint Photographic Experts Group JFIF format)",
        frame_count: 1,
        height: 312,
        list_command: [],
        path: "test/example.jpg",
        width: 820
      }
  """
  @spec gm_identify(Image.t()) :: Image.t()
  def gm_identify(image) do
    # Todo: check animated
    {output, 0} = System.cmd("gm", ["identify", "-verbose", image.path])
    format = Regex.named_captures(~r/Format: (?<format>[[:alnum:][:blank:]()]+)/, output)
    image = %{image | format: format["format"]}

    geo = Regex.named_captures(~r/Geometry: (?<geometry>\w+)/, output)
    Regex.named_captures(~r/(?<width>\w+)x(?<height>\d+)/, geo["geometry"])
    |> Enum.reduce(image, fn {k, v}, acc -> Map.put(acc, String.to_atom(k), String.to_integer(v))  end)
  end

  @doc """
  Save image.
  ## Options
    - :path - Value as path. Save as image to path

  ## Example
      iex>  Gi.open("test/example.jpg")
      ...>  |> Gi.save()
      %Gi.Image{
        animated: false,
        dirty: %{},
        ext: ".jpg",
        format: nil,
        frame_count: 1,
        height: nil,
        list_command: [],
        path: "test/example.jpg",
        width: nil
      }

      iex>  Gi.open("test/example.jpg")
      ...>  |> Gi.save(path: "test/new_example.jpg")
      %Gi.Image{
        animated: false,
        dirty: %{},
        ext: ".jpg",
        format: nil,
        frame_count: 1,
        height: nil,
        list_command: [],
        path: "test/new_example.jpg",
        width: nil
      }
  """
  @spec save(Image.t(), Keyword.t()) :: Image.t()
  def save(image, opt \\ []) do
    save_as = Keyword.get(opt, :path)
    case save_as do
      nil -> do_save(image)
      path -> do_save_as(image, path)
    end
  end

  @doc """
  Mogrify image with option.
  ## Options
    - :resize - Resize image to value "WxH" or "WxH!".
      - "WxH" keep ratio of the original image.
        - Example: "400x300", "150x100" ...
      - "WxH!" exact size.
        - Example: "300x200!", "200x100!" ...
    - :format - Format image to value as jpg, png, webp...
    - :draw - Draw object on image:
      - "text x,y string" - draw string at position x,y.
        - Example: "text 150,150 'Theta.vn'"
      - "image Over x,y,w,h file" - draw file on image at position x,y with width w va height h.
        - Example: "image Over 0,0,400,600 d/logo.png"
    - :pointsize - pointsize of the PostScript, X11, or TrueType font for text, value as integer.

  ## Example

      # Resize image to width x height with ratio (WxH)
      iex>  Gi.open("test/example.jpg")
      ...>  |> Gi.gm_mogrify(resize: "200x100")
      ...>  |> Gi.save(path: "test/example_resize.jpg")

      iex>  Gi.open("test/example_resize.jpg")
      ...>  |> Gi.gm_identify
      %Gi.Image{
        animated: false,
        dirty: %{},
        ext: ".jpg",
        format: "JPEG (Joint Photographic Experts Group JFIF format)",
        frame_count: 1,
        height: 76,
        list_command: [],
        path: "test/example_resize.jpg",
        width: 200
      }

      # Resize image to width x height (WxH!)
      Gi.open("example.jpg") # example.jpg (300x200)
      |> Gi.gm_mogrify(resize: "200x100!")
      |> Gi.save() # => example.jpg (200x100)

      # Format image to jpg, png, webp, ...
      Gi.open("example.jpg")
      |> Gi.gm_mogrify(format: "webp")
      |> Gi.save() # => create new file "example.webp"

      # Draw text on image "text x,y string"
      Gi.open("example.jpg")
      |> Gi.gm_mogrify(draw: "text 150,150 'Lang Pham'")
      |> Gi.save()

      # Draw text on image "text x,y string" with pointsize,
      Gi.open("example.jpg")
      |> Gi.gm_mogrify([pointsize: 30, draw: "text 150,150 'Lang Pham'"])
      |> Gi.save()

      # Draw image on image "image Over x,y,w,h file"
      Gi.open("example.jpg")
      |> Gi.gm_mogrify(draw: "image Over 100,100,200, 200 dir/logo.a")
      |> Gi.save()

      # Multi utilities
      Gi.open("example.jpg")
      |> Gi.gm_mogrify([resize: "300x200", draw: "text 150,150 'Theta.vn'"])
      |> Gi.save()
  """
  @spec gm_mogrify(Image.t(), Keyword.t()) :: Image.t()
  def gm_mogrify(image, opts) do
    param = Enum.reduce(opts, [], fn x, acc -> acc ++ ["-#{Atom.to_string(elem(x, 0))}", elem(x, 1)] end)

    c = %Command{
      command: :gm,
      sub_command: :mogrify,
      param: param
    }

    format =
      Keyword.pop_values(opts, :format)
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

  @spec do_save_as(Image.t(), String.t()) :: Image.t()
  defp do_save_as(image, path) do
    dir_name = Path.dirname(path)
    File.mkdir_p!(dir_name)
    File.cp(image.path, path)
    image = %{image | path: path}
    if length(image.list_command) == 0 do
      image
    else
      do_command(image)
    end
  end

  @spec do_save(Image.t()) :: Image.t()
  defp do_save(image) do
    if length(image.list_command) == 0 do
      image
    else
      do_command(image)
    end
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
