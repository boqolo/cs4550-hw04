defmodule PracticeWeb.Router do
  use PracticeWeb, :router

  # Middleware
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # middleware for taking json at an api endpoint
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PracticeWeb do
    pipe_through :browser # this is wrapping the req in middleware

    get "/", PageController, :index
    post "/double", PageController, :double
    post "/calc", PageController, :calc
    post "/factor", PageController, :factor
    post "/palindrome", PageController, :palindrome?
    # TODO: Palindrome route
  end

  # Other scopes may use custom stacks.
  # scope "/api", PracticeWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PracticeWeb.Telemetry
    end
  end
end
