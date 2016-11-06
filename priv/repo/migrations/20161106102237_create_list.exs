defmodule Tada.Repo.Migrations.CreateList do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :uuid, :uuid
      add :title, :string
      add :password_hash, :string

      timestamps
    end

    create unique_index(:lists, [:uuid])
  end
end
