defmodule Tada.SessionController do
  use Tada.Web, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"password" => password}}) do
    uuid = get_session(conn, :requested_list)
    case Tada.ListAuth.login_by_password(conn, uuid, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: list_path(conn, :show, uuid))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Failed to login!")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> Tada.ListAuth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
