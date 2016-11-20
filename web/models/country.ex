defmodule Polibot.Country do
  use Polibot.Web, :model

  schema "countries" do
    field :name, :string
    has_many :states, Polibot.State
    has_one :candidate, Polibot.Candidate

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
