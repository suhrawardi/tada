defmodule Tada.ListSocket do
  use Phoenix.Socket

  transport :websocket, Phoenix.Transports.WebSocket

  channel "lists:*", Tada.ListChannel

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
