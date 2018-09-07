defmodule SefazMetricsWeb.FactView do
  use SefazMetricsWeb, :view
  alias SefazMetricsWeb.FactView

  def render("index.json", %{facts: facts}) do
    %{data: render_many(facts, FactView, "fact.json")}
  end

  def render("show.json", %{fact: fact}) do
    %{data: render_one(fact, FactView, "fact.json")}
  end

  def render("fact.json", %{fact: fact}) do
    %{id: fact.id, date: fact.date, nfe_quant: fact.nfe_quant, emitter_quant: fact.emitter_quant}
  end
end
