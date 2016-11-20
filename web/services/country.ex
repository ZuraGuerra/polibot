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
    cond do
      country.name == "Roslilia" || "Bosnuda" -> @map_url <> "1.jpg"
      country.name == "Wozla" || "Ostilias" -> @map_url <> "2.jpg"
      country.name == "Uzkos" || "Zuristan" -> @map_url <> "3.jpg"
      country.name == "Yozka" || "Yayprington" -> @map_url <> "4.jpg"
    end
  end

  def story(country) do
    "This is your country: It's name is #{country.name}, it has 4 states."
  end

  def calculate_stats(country) do
    "👩‍ Population - 679129841
    💰 Average salary - $86K
    🎂 Average age - 42
    🚶 Foreigners - 16%
    ↔️ Tendency - Conservatism
    👩 Woman - 45%
    👱 Man - 42%"
  end

  defp assign_random(:name) do
    [name] = Enum.take_random(@names, 1)
    name
  end
end
