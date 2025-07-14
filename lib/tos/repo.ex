defmodule Tos.Repo do
  use Ecto.Repo,
    otp_app: :tos,
    adapter: Ecto.Adapters.Postgres
end
