defmodule Tada.ListChannel do
  use Tada.Web, :channel

  def join("lists:" <> list_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_item", params, socket) do
    broadcast! socket, "new_item", %{
      body: params["body"]
    }
    {:reply, :ok, socket}
  end
end
