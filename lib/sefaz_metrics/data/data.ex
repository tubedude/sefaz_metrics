defmodule SefazMetrics.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias SefazMetrics.Repo

  alias SefazMetrics.Data.Fact
  alias SefazMetrics.Data.Fetch

  @doc """
  Fetch new fact.

  """
  def fetch_fact do
    case Fetch.fetch() do
      {:ok, fact_attr} ->
        update_or_create(fact_attr)

      {:error, _msg} ->
        {:error, change_fact(%Fact{})}

    end
  end

  def update_or_create(%{} = fact_attr) do
    case Repo.get_by(Fact, date: fact_attr.date) do
      nil ->
        create_fact(fact_attr)
      fact ->
        update_fact(fact, fact_attr )
    end
  end

  @doc """
  Returns the list of facts.

  ## Examples

      iex> list_facts()
      [%Fact{}, ...]

  """
  def list_facts do
    Repo.all(Fact)
  end

  def get_fact!(id) do
    Repo.get!(Fact, id)
  end

  @doc """
  Creates a fact.

  ## Examples

      iex> create_fact(%{field: value})
      {:ok, %Fact{}}

      iex> create_fact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fact(attrs \\ %{}) do
    %Fact{}
    |> Fact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fact.

  ## Examples

      iex> update_fact(fact, %{field: new_value})
      {:ok, %Fact{}}

      iex> update_fact(fact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fact(%Fact{} = fact, attrs) do
    fact
    |> Fact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Fact.

  ## Examples

      iex> delete_fact(fact)
      {:ok, %Fact{}}

      iex> delete_fact(fact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fact(%Fact{} = fact) do
    Repo.delete(fact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fact changes.

  ## Examples

      iex> change_fact(fact)
      %Ecto.Changeset{source: %Fact{}}

  """
  def change_fact(%Fact{} = fact) do
    Fact.changeset(fact, %{})
  end
end
