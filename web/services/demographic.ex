defmodule Polibot.DemographicServices do
  alias Polibot.{Demographic, DemographicChangesets, Repo}

  def create!(state) do
    info = generate_info(state.id)
    changeset = DemographicChangesets.creation(%Demographic{}, info)
    case Repo.insert(changeset) do
      {:ok, demographic} -> demographic
      {:error, _} -> :error_creating_demographic
    end
  end

  def generate_info(state_id) do
    import Polibot.InfoServices

    %{state_id: state_id}
    |> Map.put(:rich_people, generate_random_percentage(5, 30))
    |> Map.put(:poor_people, generate_random_percentage(20, 70))
    |> Map.put(:avg_age, generate_random_number(2))
    |> Map.put(:foreigners, generate_random_percentage(25, 60))
    |> Map.put(:men, generate_random_percentage(20, 50))
    |> Map.put(:women, generate_random_percentage(20, 50))  
  end
end
