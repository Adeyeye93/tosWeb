defmodule Tos.Website do
  alias Tos.User.Website

  def save_website(web \\ "", user) do
    %Website{}
    |> Website.changeset(%{domain: web, user_id: user, active: true, risk_score: 0, time_spent_seconds: 0})
    |> Tos.Repo.insert()
    |> case do
      {:ok, website} ->
        {:ok, website.id}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update(web, data, value) do
    case Tos.Repo.get_by(Website, id: web) do
      nil -> {:error, "Website not found"}
      website ->
        changeset = Website.changeset(website, %{data => value})
        Tos.Repo.update(changeset)
        |> case do
          {:ok, updated_website} -> {:ok, updated_website}
          {:error, changeset} -> {:error, changeset}
        end
    end
  end

  def get_all_site() do
    Website
    |> Tos.Repo.all()
  end


end
