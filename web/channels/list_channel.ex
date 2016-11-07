defmodule Tada.ListChannel do
  use Tada.Web, :channel

  def join("lists:" <> list_id, _params, socket) do
    {:ok, assign(socket, :list_id, String.to_integer(list_id))}
  end

  def handle_in(event, params, socket) do
    list = Repo.get(Tada.List, socket.assigns.list_id)
    handle_in(event, params, list, socket)
  end

  def handle_in("new_item", params, list, socket) do
    changeset =
      list
      |> build_assoc(:items, list_id: socket.assigns.list_id)
      |> Tada.Item.changeset(params)
    case Repo.insert(changeset) do
      {:ok, item} ->
        broadcast! socket, "new_item", %{
          id: item.id,
          title: item.title
        }
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
