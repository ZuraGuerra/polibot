defmodule Polibot.Repo.Migrations.AddCountryIdToCandidate do
  use Ecto.Migration

  def change do
    alter table(:candidates) do
      add :country_id, references(:countries, on_delete: :nothing)
    end
    create index(:candidates, [:country_id])
  end
end
