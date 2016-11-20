defmodule Polibot.State do
  use Polibot.Web, :model

  schema "states" do
    field :name, :string
    field :avg_salary, :integer
    field :human_development, :integer
    field :religion, :string
    field :political_tendency, :integer
    field :population, :integer
    field :density, :integer
    belongs_to :country, Polibot.Country
    has_one :demographic, Polibot.Demographic

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :avg_salary, :human_development, :religion, :political_tendency, :population, :density])
    |> validate_required([:name, :avg_salary, :human_development, :religion, :political_tendency, :population, :density])
  end
end
