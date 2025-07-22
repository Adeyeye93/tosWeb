defmodule TosWeb.WebsiteController do
  use TosWeb, :controller
  alias Tos.Website

  def create(conn, %{"domain" => domain, "user" => user}) do
    case Website.save_website(domain, user) do
      {:ok, website} ->
        json(conn, %{status: "success", website: website})
      {:error, changeset} ->
        json(conn, %{status: "error", errors: changeset.errors})
    end
  end

  def update(conn, %{"web_id" => id, "data" => data, "value" => value}) do
    case Website.update(id, data, value) do
      {:ok, _} ->
        json(conn, %{status: "success"})
      {:error, changeset} ->
        json(conn, %{status: "error", errors: changeset.errors})
    end
  end
  # # Example: Accessing data from request headers instead of parameters

  # def example_using_headers(conn, _params) do
  #   # Get a header value, e.g., "x-custom-data"
  #   custom_data = get_req_header(conn, "x-custom-data") |> List.first()

  #   json(conn, %{received_data: custom_data})
  # end
end
