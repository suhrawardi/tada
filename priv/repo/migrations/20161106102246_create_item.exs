defmodule Tada.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :order, :integer
      add :status, :string
      add :content, :string
      add :due_date, :datetime
      add :list_id, references(:lists, on_delete: :nothing)

      timestamps
    end

    create unique_index(:items, [:title, :list_id])
  end
end
