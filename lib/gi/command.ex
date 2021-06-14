defmodule Gi.Command do
  @type str :: binary
  @type param :: [str]

  @type t :: %__MODULE__{
               command: :atom,
               sub_command: :atom,
               param: param
             }

  defstruct command: nil,
            sub_command: nil,
            param: []

  defguard is_command(value) when value.__struct__ == __MODULE__
end
