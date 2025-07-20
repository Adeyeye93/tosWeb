defmodule Tos.Repo.Migrations.CreateUserSites do
  use Ecto.Migration

  def change do
    create table(:user_sites) do
      add :domain, :string
      add :active, :boolean, default: false, null: false
      add :pref, references(:preferences, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      add :risk_score, :integer, default: 0, null: false
      add :time_spent_seconds, :integer, default: 0, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:user_sites, [:pref])
    create index(:user_sites, [:user_id])
  end
end
