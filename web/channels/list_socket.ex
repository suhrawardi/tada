defmodule Tada.ListSocket do
  use Phoenix.Socket

  transport :websocket, Phoenix.Transports.WebSocket

  channel "lists:*", Tada.ListChannel

  @max_age 2 * 7 * 24 * 60 * 60

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "list socket", token, max_age: @max_age) do
      {:ok, list_id} ->
        {:ok, assign(socket, :list_id, list_id)}
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(_socket), do: nil
end
