defmodule Tada.ListController do
  use Tada.Web, :controller

  alias Tada.List

  plug :authenticate when action in [:show, :delete]

  def show(conn, %{"id" => uuid}) do
    list = Repo.get_by(Tada.List, uuid: uuid)
           |> Repo.preload(:items)
    render conn, "show.html", list: list
  end

  def create(conn, %{"list" => list_params}) do
    changeset = List.changeset(%List{}, list_params)
    case Repo.insert(changeset) do
      {:ok, list} ->
        conn
        |> Tada.ListAuth.login(list)
        |> put_flash(:info, "#{list.title} created!")
        |> redirect(to: list_path(conn, :show, list))
      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to create the list!")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => uuid}) do
    list = Repo.get_by(Tada.List, uuid: uuid)
    {:ok, list} = Repo.delete(list)
    conn
    |> put_flash(:info, "#{list.title} deleted")
    |> redirect(to: page_path(conn, :index))
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_list do
      conn
    else
      %{"id" => uuid} = conn.params
      conn
      |> put_session(:requested_list, uuid)
      |> put_flash(:error, "You must provide a valid password to access this list")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
