defmodule SefazMetricsWeb.FactController do
  use SefazMetricsWeb, :controller

  alias SefazMetrics.Data
  alias SefazMetrics.Data.Fact

  action_fallback(SefazMetricsWeb.FallbackController)

  def index(conn, _params) do
    facts = Data.list_facts()
    render(conn, "index.json", facts: facts)
  end

  def create(conn, %{"fact" => fact_params}) do
    with {:ok, %Fact{} = fact} <- Data.create_fact(fact_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", fact_path(conn, :show, fact))
      |> render("show.json", fact: fact)
    end
  end

  def show(conn, %{"id" => id}) do
    fact = Data.get_fact!(id)
    render(conn, "show.json", fact: fact)
  end

  def update(conn, %{"id" => id, "fact" => fact_params}) do
    fact = Data.get_fact!(id)

    with {:ok, %Fact{} = fact} <- Data.update_fact(fact, fact_params) do
      render(conn, "show.json", fact: fact)
    end
  end

  def delete(conn, %{"id" => id}) do
    fact = Data.get_fact!(id)

    with {:ok, %Fact{}} <- Data.delete_fact(fact) do
      send_resp(conn, :no_content, "")
    end
  end
end
