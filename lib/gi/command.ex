defmodule Gi.Command do
  @type t :: %__MODULE__{
          command: :atom,
          sub_command: :atom,
          param: [binary()]
        }

  defstruct command: nil,
            sub_command: nil,
            param: []

  defguard is_command(value) when value.__struct__ == __MODULE__
end
