defmodule Polibot.Repo.Migrations.MakeFbIdUnique do
  use Ecto.Migration

  def change do
    create unique_index(:candidates, [:fb_id])

  end
end
