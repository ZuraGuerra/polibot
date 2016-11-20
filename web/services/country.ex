defmodule Polibot.CountryServices do
  alias Polibot.{CountryChangesets, Country, Repo}

  @names ["Roslilia", "Bosnuda", "Wozla", "Ostilias", "Uzkos", "Zuristan", "Yozka", "Yayprington"]
  @map_url "https://github.com/ZuraGuerra/polibot/raw/master/web/static/images/country"

  def create! do
    name = assign_random(:name)
    changeset = CountryChangesets.creation(%Country{}, %{name: name})
    case Repo.insert(changeset) do
      {:ok, country} -> country
      {:error, _} -> :error_creating_country
    end
  end

  # Hardcoding because 4am ✨
  def map_url(country) do
    case country.name do
      "Roslilia" || "Bosnuda" -> @map_url <> "1.jpg"
      "Wozla" || "Ostilias" -> @map_url <> "2.jpg"
      "Uzkos" || "Zuristan" -> @map_url <> "3.jpg"
      "Yozka" || "Yayprington" -> @map_url <> "4.jpg"
    end
  end

  defp assign_random(:name) do
    [name] = Enum.take_random(@names, 1)
    name
  end
end
