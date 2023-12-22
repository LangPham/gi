defmodule Gi.Image do
  alias Gi.Command

  @type t :: %__MODULE__{
          path: binary(),
          ext: binary(),
          format: binary(),
          width: integer(),
          height: integer(),
          animated: boolean(),
          frame_count: integer(),
          list_command: [%Command{}],
          dirty: %{atom => any}
        }

  defstruct path: nil,
            ext: nil,
            format: nil,
            width: nil,
            height: nil,
            animated: false,
            frame_count: 1,
            list_command: [],
            dirty: %{}

  defguard is_image(value) when value.__struct__ == __MODULE__
end
