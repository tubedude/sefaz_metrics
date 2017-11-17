defmodule SefazMetrics.Repo.Migrations.CreateFacts do
  use Ecto.Migration

  def change do
    create table(:facts) do
      add :date, :date, unique: true
      add :nfe_quant, :float
      add :emitter_quant, :float

      timestamps()
    end

    create index(:facts, :date)
  end
end
