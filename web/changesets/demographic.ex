defmodule Polibot.DemographicChangesets do
  use Polibot.Web, :model
  @params [:rich_people, :poor_people, :avg_age, :foreigners, :men, :women, :state_id]

  def creation(struct, params \\ %{}), do: struct |> cast(params, @params)
end
