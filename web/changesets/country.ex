defmodule Polibot.CountryChangesets do
  use Polibot.Web, :model

  def creation(struct, params \\ %{}), do: struct |> cast(params, [:name])
end
