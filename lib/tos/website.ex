defmodule Tos.Website do
  alias Tos.User.Website

  def save_website(web \\ "") do
    %Website{}
    |> Website.changeset(%{domain: web, active: false, risk_score: 0, time_spent_seconds: 0})
    |> Tos.Repo.insert()
    |> case do
      {:ok, website} ->
        {:ok, website}

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
end
