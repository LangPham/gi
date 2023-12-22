defmodule Gi.Error do
  @type t :: %__MODULE__{
          message: binary()
        }
  defexception [:message]

  @impl true
  def exception(value) do
    case value do
      :not_found -> %__MODULE__{message: value}
      _ -> %__MODULE__{message: "unknown"}
    end
  end
end
