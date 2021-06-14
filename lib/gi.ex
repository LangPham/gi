defmodule Gi do
	@moduledoc """
	Documentation for `Gi`.
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
	
	@spec save(Image.t()) :: Image.t()
	def save(image) do
		if length(image.list_command) == 0 do
			image
		else
			do_command(image)
		end
	end
	
	@doc """
	Opens image source, raises a `File.Error` exception in case of failure.
	
  ## Example
	
      iex>  img = Gi.open "ex.png"
			iex>  Gi.gm_mogrify(img, [resize: "100x100"])  // 800x600 -> 100x75, 80x60 -> 100x75
			iex>  Gi.gm_mogrify(img, [resize: "100x100!"]) // 800x600 -> 100x100
	"""
	def gm_mogrify(image, kw) do
		param = Enum.reduce(kw, [], fn x, acc -> acc ++ ["-#{Atom.to_string(elem(x, 0))}", elem(x, 1)] end)
		new = List.last Keyword.pop_values(kw, :format)
		dirty =
			case new do
				nil -> %{}
				str -> %{mogrify_format: str}
			end
		c = %Command{
			command: :gm,
			sub_command: :mogrify,
			param: param,
			dirty: dirty
		}
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
