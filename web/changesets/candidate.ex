defmodule Polibot.CandidateChangesets do
  use Polibot.Web, :model
  @params [:fb_id, :race, :gender, :was_poor, :budget, :popularity, :country_id,
           :actual_popularity, :last_name, :first_name, :tendency, :charisma]

  def creation(struct, params \\ %{}), do: struct |> cast(params, @params)
end
