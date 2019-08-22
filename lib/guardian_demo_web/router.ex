defmodule GuardianDemoWeb.Router do
  use GuardianDemoWeb, :router

  pipeline :verify_auth do
    plug GuardianDemo.VerifyAuthPipeline
  end

  pipeline :protected do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GuardianDemoWeb do
    pipe_through :browser

    get "/", PrivateController, :index
  end

  scope "/", GuardianDemoWeb do
    pipe_through :api

    post "/login", AuthController, :login
  end

  scope "/", GuardianDemoWeb do
    pipe_through [:verify_auth, :protected]

    post "/private", PrivateController, :my_path
  end

  # Other scopes may use custom stacks.
  # scope "/api", GuardianDemoWeb do
  #   pipe_through :api
  # end
end
