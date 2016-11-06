defmodule Tada.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :item_id, references(:items, on_delete: :nothing)

      timestamps
    end

    create unique_index(:tags, [:name, :item_id])
  end
end
