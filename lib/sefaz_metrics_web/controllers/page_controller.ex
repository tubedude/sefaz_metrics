defmodule SefazMetricsWeb.PageController do
  use SefazMetricsWeb, :controller

  plug :secure_cache_headers

  def index(conn, _params) do
    render conn, "index.html"
  end

  def fetch(conn, _params) do
    SefazMetrics.Data.fetch_fact()
    conn
    |> put_flash(:info, "Fetch successful")
    |> redirect(to: "/")
  end

  defp secure_cache_headers(conn, _) do
    Plug.Conn.put_resp_header(conn, "cache-control", "public")
    Plug.Conn.put_resp_header(conn, "pragma", "public")
  end

end
