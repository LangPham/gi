defmodule Gi.Rust do
  use Rustler, otp_app: :gi, crate: :gi_rust

  def open(_path), do: error()


  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
