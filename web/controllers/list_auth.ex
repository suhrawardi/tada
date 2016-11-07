defmodule Tada.ListAuth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    uuid = get_session(conn, :uuid)
    cond do
      list = conn.assigns[:current_list] ->
        put_current_list(conn, list)
      list = uuid && repo.get_by(Tada.List, uuid: uuid) ->
        put_current_list(conn, list)
      true ->
        assign(conn, :current_list, nil)
    end
  end

  def login(conn, list) do
    conn
    |> put_current_list(list)
    |> put_session(:uuid, list.uuid)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def login_by_password(conn, uuid, password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    list = repo.get_by(Tada.List, uuid: uuid)
    cond do
      list && checkpw(password, list.password_hash) ->
        {:ok, login(conn, list)}
      list ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  defp put_current_list(conn, list) do
    token = Phoenix.Token.sign(conn, "list socket", list.id)
    conn
    |> assign(:current_list, list)
    |> assign(:list_token, token)
  end
end
