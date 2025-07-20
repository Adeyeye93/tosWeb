defmodule Tos.User.Preference do
  use Tos.Schema
  import Ecto.Changeset

  schema "preferences" do
    field :value, :boolean, default: false
    field :key, :string

    belongs_to :users, Tos.Account.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
