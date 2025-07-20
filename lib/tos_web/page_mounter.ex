defmodule TosWeb.PageMounter do
  @moduledoc """
  This module is responsible for mounting pages in the TosWeb application.
  It defines the necessary functions to handle page rendering and routing.
  """

  alias Tos.Repo
  import Ecto.Query, only: [from: 2]
  import Phoenix.Component
  alias Tos.Account.User

  def on_mount(:default, _params, _session, sockets) do
    avatar =
      Repo.all(
        from u in User,
          where: u.username == ^sockets.assigns.current_user.username,
          select: u.avatar
      )

    avatar_path =
      case avatar do
        [] -> "/assets/uploads/users/profile/default_avatar.png"
        [avatar] -> "/assets/uploads/users/profile/#{avatar}"
      end

    socket =
      sockets
      |> assign(:avatar, avatar_path)

    {:cont, socket}
  end
end
