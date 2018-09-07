defmodule SefazMetricsWeb.Router do
  use SefazMetricsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SefazMetricsWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/fetch", PageController, :fetch)
  end

  scope "/api", SefazMetricsWeb do
    pipe_through(:api)

    resources("/facts", FactController, only: [:index])
  end
end
