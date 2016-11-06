defmodule Tada.Router do
  use Tada.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Tada.ListAuth, repo: Tada.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Tada do
    pipe_through :browser # Use the default browser stack

    resources "/lists", ListController, only: [:show, :create, :delete]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Tada do
  #   pipe_through :api
  # end
end
