defmodule SefazMetricsWeb.PageController do
  use SefazMetricsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def fetch(conn, _params) do
    SefazMetrics.Data.fetch_fact()
    redirect conn, to: "/"
  end


end
