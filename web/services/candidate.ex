defmodule Polibot.CandidateServices do
  alias Polibot.{InfoDictionaries, Candidate, CandidateChangesets, Repo}

  @avatar_url "https://github.com/ZuraGuerra/polibot/raw/master/web/static/images/"

  def create!(fb_id) do
    info = generate_info(fb_id)
    changeset = CandidateChangesets.creation(%Candidate{}, info)
    case Repo.insert(changeset) do
      {:ok, candidate} -> candidate
      {:error, _} -> :error_creating_candidate
    end
  end

  def get_avatar(candidate),
    do: @avatar_url <> candidate.gender <> "-" <> candidate.race ".jpg"

  defp generate_info(fb_id) do
    import Polibot.CandidateInfoServices

    info = %{fb_id: fb_id}
         |> Map.put(:race, assign_random(:race))
         |> Map.put(:gender, assign_random(:gender))
         |> Map.put(:was_poor, generate_boolean_state)
         |> Map.put(:budget, generate_random_number(6))
         |> Map.put(:popularity, generate_random_percentage(15, 40))
         |> Map.put(:actual_popularity, generate_random_percentage(25, 100))
         |> Map.put(:last_name, assign_random(:last_name))
         |> Map.put(:tendency, assign_random(:tendency))
         |> Map.put(:charisma, generate_random_percentage(15,30))

    Map.put(info, :first_name, assign_random(:first_name, info))
  end
end
