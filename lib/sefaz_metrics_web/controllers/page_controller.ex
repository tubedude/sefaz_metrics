defmodule SefazMetricsWeb.PageController do
  use SefazMetricsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def fetch(conn, _params) do
    SefazMetrics.Data.fetch_fact()
    conn
    |> put_flash(:info, "Fetch successful")
    |> redirect(to: "/")
  end


end
