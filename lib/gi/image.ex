defmodule Gi.Image do
  alias Gi.Command

  @type str           :: binary
  @type int           :: integer
  @type check         :: boolean
  @type list_command  :: [%Command{}]
  @type dirty         :: %{atom => any}

  @type t :: %__MODULE__{
               path:          str,
               ext:           str,
               format:        str,
               width:         int,
               height:        int,
               animated:      check,
               frame_count:   int,
               list_command:  list_command,
               dirty:         dirty
             }

  defstruct path:         nil,
            ext:          nil,
            format:       nil,
            width:        nil,
            height:       nil,
            animated:     false,
            frame_count:  1,
            list_command: [],
            dirty:        %{}
end
