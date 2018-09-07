defmodule SefazMetrics.Data.Fact do
  use Ecto.Schema
  import Ecto.Changeset
  alias SefazMetrics.Data.Fact

  schema "facts" do
    field(:date, :date)
    field(:emitter_quant, :float)
    field(:nfe_quant, :float)

    timestamps()
  end

  @doc false
  def changeset(%Fact{} = fact, attrs) do
    fact
    |> cast(attrs, [:date, :nfe_quant, :emitter_quant])
    |> validate_required([:date, :nfe_quant, :emitter_quant])
    |> unique_constraint(:date)
  end
end
