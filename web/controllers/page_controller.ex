defmodule Tada.PageController do
  use Tada.Web, :controller

  def index(conn, _params) do
    changeset = Tada.List.changeset(%Tada.List{})
    render conn, "index.html", changeset: changeset
  end
end
