defmodule Polibot.CountryServices do
  alias Polibot.{CountryChangesets, Country, Repo}

  @names ["Roslilia", "Bosnuda", "Wozla", "Ostilias", "Uzkos", "Zuristan", "Yozka", "Yayprington"]

  def create! do
    name = assign_random(:name)
    changeset = CountryChangesets.creation(%Country{}, %{name: name})
    case Repo.insert(changeset) do
      {:ok, country} -> country
      {:error, _} -> :error_creating_country
    end
  end

  defp assign_random(:name) do
    [name] = Enum.take_random(@names, 1)
    name
  end
end
