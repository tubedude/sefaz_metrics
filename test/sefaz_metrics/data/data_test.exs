defmodule SefazMetrics.DataTest do
  use SefazMetrics.DataCase

  alias SefazMetrics.Data

  describe "facts" do
    alias SefazMetrics.Data.Fact

    @valid_attrs %{date: ~D[2010-04-17], emitter_quant: 120.5, nfe_quant: 120.5}
    @update_attrs %{date: ~D[2011-05-18], emitter_quant: 456.7, nfe_quant: 456.7}
    @invalid_attrs %{date: nil, emitter_quant: nil, nfe_quant: nil}

    def fact_fixture(attrs \\ %{}) do
      {:ok, fact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_fact()

      fact
    end

    test "list_facts/0 returns all facts" do
      fact = fact_fixture()
      assert Data.list_facts() == [fact]
    end

    test "get_fact!/1 returns the fact with given id" do
      fact = fact_fixture()
      assert Data.get_fact!(fact.id) == fact
    end

    test "create_fact/1 with valid data creates a fact" do
      assert {:ok, %Fact{} = fact} = Data.create_fact(@valid_attrs)
      assert fact.date == ~D[2010-04-17]
      assert fact.emitter_quant == 120.5
      assert fact.nfe_quant == 120.5
    end

    test "create_fact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_fact(@invalid_attrs)
    end

    test "update_fact/2 with valid data updates the fact" do
      fact = fact_fixture()
      assert {:ok, fact} = Data.update_fact(fact, @update_attrs)
      assert %Fact{} = fact
      assert fact.date == ~D[2011-05-18]
      assert fact.emitter_quant == 456.7
      assert fact.nfe_quant == 456.7
    end

    test "update_fact/2 with invalid data returns error changeset" do
      fact = fact_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_fact(fact, @invalid_attrs)
      assert fact == Data.get_fact!(fact.id)
    end

    test "delete_fact/1 deletes the fact" do
      fact = fact_fixture()
      assert {:ok, %Fact{}} = Data.delete_fact(fact)
      assert_raise Ecto.NoResultsError, fn -> Data.get_fact!(fact.id) end
    end

    test "change_fact/1 returns a fact changeset" do
      fact = fact_fixture()
      assert %Ecto.Changeset{} = Data.change_fact(fact)
    end
  end
end
