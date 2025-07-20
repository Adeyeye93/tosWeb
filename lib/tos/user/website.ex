defmodule Tos.User.Website do
  use Tos.Schema
  import Ecto.Changeset

  schema "user_sites" do
    field :active, :boolean, default: false
    field :domain, :string
    field :pref, :id
    field :user_id, :id
    field :risk_score, :integer
    field :time_spent_seconds, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:domain, :active, :risk_score, :time_spent_seconds])
    |> validate_required([:domain, :active, :risk_score, :time_spent_seconds])
  end
end
