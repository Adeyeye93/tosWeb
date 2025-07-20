defmodule Tos.Repo.Migrations.CreatePreferences do
  use Ecto.Migration

  def change do
    create table(:preferences) do
      add :key, :string
      add :value, :boolean, default: false, null: false
      add :users_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:preferences, [:users_id])
    create unique_index(:preferences, [:users_id, :key])
  end
end
