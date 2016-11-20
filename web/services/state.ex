defmodule Polibot.StateServices do
  alias Polibot.{State, StateChangesets, Repo}

  def create!(country) do
    info = generate_info(country.id)
    changeset = StateChangesets.creation(%State{}, info)
    case Repo.insert(changeset) do
      {:ok, state} -> state
      {:error, _} -> :error_creating_state
    end
  end

  def generate_info(country_id) do
    import Polibot.InfoServices

    %{country_id: country_id}
    |> Map.put(:name, assign_random(:state_name))
    |> Map.put(:avg_salary, generate_random_number(3))
    |> Map.put(:human_development, generate_random_percentage(40, 80))
    |> Map.put(:religion, assign_random(:religion))
    |> Map.put(:political_tendency), assign_random(:tendency)
    |> Map.put(:population, generate_random_number(7))
  end
end
