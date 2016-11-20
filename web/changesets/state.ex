defmodule Polibot.StateChangesets do
  use Polibot.Web, :model
  @params [:name, :avg_salary, :human_development, :religion, :political_tendency,
           :population, :density, :country_id]

  def creation(struct, params \\ %{}), do: struct |> cast(params, @params)
end
