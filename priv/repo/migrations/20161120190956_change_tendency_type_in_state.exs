defmodule Polibot.Repo.Migrations.ChangeTendencyTypeInState do
  use Ecto.Migration

  def change do
    alter table(:states) do
      remove :political_tendency
      add :political_tendency, :string
    end
  end
end
