defmodule Polibot.Candidate do
  use Polibot.Web, :model

  schema "candidates" do
    field :fb_id, :string
    field :race, :string
    field :gender, :string
    field :was_poor, :boolean, default: false
    field :party, :string
    field :budget, :integer
    field :popularity, :integer
    field :actual_popularity, :integer
    field :first_name, :string
    field :last_name, :string
    field :tendency, :string
    field :charisma, :integer
    belongs_to :country, Polibot.Country

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:fb_id, :race, :gender, :was_poor, :party, :budget, :popularity, :actual_popularity, :first_name, :last_name, :tendency, :charisma])
    |> validate_required([:fb_id, :race, :gender, :was_poor, :party, :budget, :popularity, :actual_popularity, :first_name, :last_name, :tendency, :charisma])
  end
end
