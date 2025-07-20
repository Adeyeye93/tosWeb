defmodule TosWeb.ProfileLive do
  use TosWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_param, _session, sockets) do

    assign =
      sockets
      |> assign(:page_title, "Profile")
      |> assign(:uploading, false)
      |> assign(:test, 76.5)
      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 10, progress: &handle_progress/3, auto_upload: true)
        {:ok, assign}
  end

  defp handle_progress(:avatar, entry, socket) do
    if entry.done? do
      uploaded_files =
        consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
          email = socket.assigns.current_user.email

          # Sanitize the email to use as filename (replace @ and . to prevent filesystem issues)
          safe_email = email |> String.replace("@", "_at_") |> String.replace(".", "_")

          # Get original file extension from client_name or use .jpg as fallback
          ext =
            case Path.extname(entry.client_name) do
              "" -> ".jpg"
              other -> other
            end

          filename = "#{safe_email}#{ext}"

          dest = Path.join([:code.priv_dir(:tos), "static", "assets", "uploads", "users", "profile", filename])

          File.cp!(path, dest)

          # Update the user's avatar in DB
            Tos.Repo.get_by!(Tos.Account.User, email: email)
            |> Ecto.Changeset.change(avatar: filename)
            |> Tos.Repo.update!()

          {:ok, ~p"/assets/uploads/users/profile/#{filename}"}
        end)

      IO.inspect(entry, label: "Avatar upload completed")

      {:noreply, socket |> update(:uploaded_files, &(&1 ++ uploaded_files)) |> assign(:uploading, true) |> push_event("validateActive", %{button_id: "save"})}
    else
      {:noreply, socket}
    end
  end


  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do

    {:noreply, socket }

  end


  # defp error_to_string(:too_large), do: "Too large"
  # defp error_to_string(:too_many_files), do: "You have selected too many files"
  # defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"



  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
        <div :for={entry <- @uploads.avatar.entries} class="toastify on w-fit toastify-right toastify-top" aria-live="polite" style="transform: translate(0px, 0px); top: 15px; width: 200px; "><div class="toast [&amp;.hide]:!hidden" data-config="{ triggerId: '#basic-toast' }">
        <div class="box relative w-fit p-5 before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md">
            <div class="grid gap-1" style="width: 100px">
                <div class="font-semibold">Uploading... {entry.progress}% </div>
                 <progress sytle="height: 10px; border-radius: 10px; transition-duration: 1s;" value={entry.progress} max="100"> </progress>
            </div>
        </div>
    </div>
    <button type="button" aria-label="Close" class="toast-close">✖</button>
    </div>

      <div class="flex items-center mt-8">
                            <h2 class="mr-auto text-lg font-medium">Profile Layout</h2>
                        </div>
                        <div class="tabs relative w-full">
                            <!-- BEGIN: Profile Info -->
                            <div class="box relative before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md p-0 mt-5">
                                <div class="flex flex-col p-5 border-b lg:flex-row">
                                    <div class="flex items-center justify-center flex-1 px-5 lg:justify-start">
                                        <div class="relative" phx-drop-target={@uploads.avatar.ref}>
                                            <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full ring-1 ring-(--color)/25 [--color:var(--color-primary)] border-5 size-20 sm:size-24 lg:size-32" alt="Midone - Tailwind Admin Dashboard Template">
                                            <img class="absolute top-0 size-full object-cover" src={"#{@avatar}"} alt="Midone - Tailwind Admin Dashboard Template" />
                                            </span>
                                            <form id="upload-form" phx-submit="save" phx-change="validate">
                                            <div class="bg-(--color)/70 border-3 border-background absolute bottom-0 right-0 mb-1 mr-1 flex items-center justify-center rounded-full p-2 text-white [--color:var(--color-primary)]" style="cursor: pointer;">
                                              <.live_file_input upload={@uploads.avatar}  class="" style="opacity: 0; position: absolute; top: 0; left: 0;"/>
                                                <i data-lucide="camera" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-4">

                                                </i>
                                            </div>
                                            </form>
                                        </div>
                                        <div class="ml-5">
                                            <div class="w-24 text-lg font-medium truncate sm:w-40 sm:whitespace-normal">
                                            <%= @current_user.username %>
                                            </div>
                                            <div class="opacity-70">Online</div>
                                        </div>
                                    </div>
                                    <div class="flex-1 px-5 pt-5 mt-6 border-t border-l border-r lg:mt-0 lg:border-t-0 lg:pt-0">
                                        <div class="font-medium text-center lg:mt-3 lg:text-left">
                                            Contact Details
                                        </div>
                                        <div class="flex flex-col items-center justify-center mt-4 lg:items-start">
                                            <div class="flex items-center truncate sm:whitespace-normal">
                                                <i data-lucide="mail" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                <%= @current_user.email %>
                                            </div>
                                            <div class="flex items-center mt-3 truncate sm:whitespace-normal">
                                                <i data-lucide="shield-check" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                Active
                                            </div>

                                        </div>
                                    </div>
                                    <div class="flex items-center justify-center flex-1 px-5 pt-5 mt-6 border-t lg:mt-0 lg:border-0 lg:pt-0">
                                        <div class="grid grid-cols-3 gap-5">
                                            <div class="text-center">
                                                <div class="text-xl font-medium">201</div>
                                                <div class="opacity-70">Orders</div>
                                            </div>
                                            <div class="text-center">
                                                <div class="text-xl font-medium">1k</div>
                                                <div class="opacity-70">Purchases</div>
                                            </div>
                                            <div class="text-center">
                                                <div class="text-xl font-medium">492</div>
                                                <div class="opacity-70">Reviews</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="px-5 py-4">
                                    <ul role="tablist" class="bg-foreground/5 relative z-0 flex h-10 w-full select-none items-center justify-center rounded-xl p-1 [&&gt;*]:flex-1 mb-0">
                                        <li role="presentation" class="z-20 w-full">
                                            <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                <i data-lucide="airplay" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                Profile
                                            </button>
                                        </li>
                                        <li role="presentation" class="z-20 w-full">
                                            <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                <i data-lucide="aperture" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                Account
                                            </button>
                                        </li>
                                        <li role="presentation" class="z-20 w-full">
                                            <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                <i data-lucide="package-check" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                Change Password
                                            </button>
                                        </li>
                                        <li role="presentation" class="z-20 w-full">
                                            <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                <i data-lucide="palette" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                Settings
                                            </button>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <!-- END: Profile Info -->
                            <div class="tab-content">
                                <div class="tab-pane hidden [&.active]:block" role="tabpanel">
                                    <div class="mt-8">
                                        <div class="grid grid-cols-12 gap-x-6 gap-y-8">
                                            <!-- BEGIN: Latest Uploads -->
                                            <div class="box relative before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md col-span-12 p-0 lg:col-span-6">
                                                <div class="flex items-center px-5 py-5 border-b sm:py-3">
                                                    <h2 class="mr-auto text-base font-medium">
                                                        Latest Uploads
                                                    </h2>
                                                    <div data-tw-placement="bottom-end" class="dropdown ml-auto sm:hidden">
                                                        <a data-tw-toggle="dropdown" class="dropdown-toggle cursor-pointer relative z-[51] block size-5" href="#">
                                                            <i data-lucide="more-horizontal" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-5 opacity-70"></i>
                                                        </a>
                                                        <div class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&.show]:visible [&.show]:opacity-100">
                                                            <div class="dropdown-content w-40">
                                                                <a class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50">
                                                                    All Files
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <button class="[--color:var(--color-foreground)] cursor-pointer border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 hidden sm:flex">
                                                        All Files
                                                    </button>
                                                </div>
                                                <div class="p-5">
                                                    <div class="flex items-center">
                                                        <div class="w-12 file">
                                                            <div class="relative block bg-center bg-no-repeat bg-contain before:content-[''] before:pt-[100%] before:w-full before:block bg-directory">
                                                            </div>
                                                        </div>
                                                        <div class="ml-4">
                                                            <a class="font-medium" href="">
                                                                Documentation
                                                            </a>
                                                            <div class="mt-0.5 text-xs opacity-70">40 KB</div>
                                                        </div>
                                                        <div data-tw-placement="bottom-end" class="dropdown ml-auto">
                                                            <a data-tw-toggle="dropdown" class="dropdown-toggle cursor-pointer relative z-[51] block size-5" href="#">
                                                                <i data-lucide="more-horizontal" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-5 opacity-70"></i>
                                                            </a>
                                                            <div class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&.show]:visible [&.show]:opacity-100">
                                                                <div class="dropdown-content w-40">
                                                                    <a class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50">
                                                                        <i data-lucide="users" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                                        Share
                                                                        File
                                                                    </a>
                                                                    <a class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50">
                                                                        <i data-lucide="trash" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                                        Delete
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center mt-5">
                                                        <div class="w-12 text-xs file">
                                                            <div class="relative block bg-center bg-no-repeat bg-contain before:content-[''] before:pt-[100%] before:w-full before:block bg-file">
                                                                <div class="absolute bottom-0 left-0 right-0 top-0 m-auto flex items-center justify-center text-white">
                                                                    MP3
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="ml-4">
                                                            <a class="font-medium" href="">
                                                                Celine Dion - Ashes
                                                            </a>
                                                            <div class="mt-0.5 text-xs opacity-70">40 KB</div>
                                                        </div>
                                                        <div data-tw-placement="bottom-end" class="dropdown ml-auto">
                                                            <a data-tw-toggle="dropdown" class="dropdown-toggle cursor-pointer relative z-[51] block size-5" href="#">
                                                                <i data-lucide="more-horizontal" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-5 opacity-70"></i>
                                                            </a>
                                                            <div class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&.show]:visible [&.show]:opacity-100">
                                                                <div class="dropdown-content w-40">
                                                                    <a class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50">
                                                                        <i data-lucide="users" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                                        Share
                                                                        File
                                                                    </a>
                                                                    <a class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50">
                                                                        <i data-lucide="trash" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                                        Delete
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center mt-5">
                                                        <div class="w-12 file">
                                                            <div class="relative block bg-center bg-no-repeat bg-contain before:content-[''] before:pt-[100%] before:w-full before:block bg-empty-directory">
                                                            </div>
                                                        </div>
                                                        <div class="ml-4">
                                                            <a class="font-medium" href="">
                                                                Resources
                                                            </a>
                                                            <div class="mt-0.5 text-xs opacity-70">0 KB</div>
                                                        </div>
                                                        <div data-tw-placement="bottom-end" class="dropdown ml-auto">
                                                            <a data-tw-toggle="dropdown" class="dropdown-toggle cursor-pointer relative z-[51] block size-5" href="#">
                                                                <i data-lucide="more-horizontal" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-5 opacity-70"></i>
                                                            </a>
                                                            <div class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&.show]:visible [&.show]:opacity-100">
                                                                <div class="dropdown-content w-40">
                                                                    <a class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50">
                                                                        <i data-lucide="users" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                                        Share
                                                                        File
                                                                    </a>
                                                                    <a class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50">
                                                                        <i data-lucide="trash" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                                        Delete
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- END: Latest Uploads -->
                                            <!-- BEGIN: Work In Progress -->
                                            <div class="box relative before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md col-span-12 p-0 lg:col-span-6">
                                                <div class="tabs relative w-full">
                                                    <div class="relative flex items-center p-5 border-b">
                                                        <h2 class="mr-auto text-base font-medium">
                                                            Work In Progress
                                                        </h2>
                                                        <div data-tw-placement="bottom-end" class="dropdown ml-auto sm:hidden">
                                                            <a data-tw-toggle="dropdown" class="dropdown-toggle cursor-pointer relative z-[51] block size-5" href="#">
                                                                <i data-lucide="more-horizontal" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-5 opacity-70"></i>
                                                            </a>
                                                            <div class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&.show]:visible [&.show]:opacity-100">
                                                                <div class="dropdown-content w-40">
                                                                    <li role="presentation" class="z-20 relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50 w-full">
                                                                        <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                                            New
                                                                        </button>
                                                                    </li>
                                                                    <li role="presentation" class="z-20 relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50 w-full">
                                                                        <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                                            Last Week
                                                                        </button>
                                                                    </li>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <ul role="tablist" class="bg-foreground/5 z-0 h-10 select-none items-center justify-center rounded-xl p-1 [&&gt;*]:flex-1 absolute inset-y-0 hidden w-auto my-auto right-5 sm:flex">
                                                            <li role="presentation" class="z-20 w-full">
                                                                <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                                    New
                                                                </button>
                                                            </li>
                                                            <li role="presentation" class="z-20 w-full">
                                                                <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                                    Last Week
                                                                </button>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    <div class="tab-content p-5">
                                                        <div class="tab-pane hidden [&.active]:block" role="tabpanel">
                                                            <div>
                                                                <div>
                                                                    <div class="flex">
                                                                        <div class="mr-auto">Pending Tasks</div>
                                                                        <div>20%</div>
                                                                    </div>
                                                                    <div class="border w-full h-2 relative rounded-full bg-(--color)/5 border-(--color)/20 [--color:var(--color-primary)] before:inset-y-0 before:absolute before:w-(--value) before:left-0 before:rounded-full before:bg-(--color)/20 before:border before:-m-px before:border-(--color)/30 mt-2 [--value:50%]">
                                                                    </div>
                                                                </div>
                                                                <div class="mt-5">
                                                                    <div class="flex">
                                                                        <div class="mr-auto">Completed Tasks</div>
                                                                        <div>2 / 20</div>
                                                                    </div>
                                                                    <div class="border w-full h-2 relative rounded-full bg-(--color)/5 border-(--color)/20 [--color:var(--color-primary)] before:inset-y-0 before:absolute before:w-(--value) before:left-0 before:rounded-full before:bg-(--color)/20 before:border before:-m-px before:border-(--color)/30 mt-2 [--value:25%]">
                                                                    </div>
                                                                </div>
                                                                <div class="mt-5">
                                                                    <div class="flex">
                                                                        <div class="mr-auto">Tasks In Progress</div>
                                                                        <div>42</div>
                                                                    </div>
                                                                    <div class="border w-full h-2 relative rounded-full bg-(--color)/5 border-(--color)/20 [--color:var(--color-primary)] before:inset-y-0 before:absolute before:w-(--value) before:left-0 before:rounded-full before:bg-(--color)/20 before:border before:-m-px before:border-(--color)/30 mt-2 [--value:75%]">
                                                                    </div>
                                                                </div>
                                                                <div class="text-center">
                                                                    <a class="[--color:var(--color-foreground)] cursor-pointer border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 inline-block mx-auto mt-5" href="">
                                                                        View More Details
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- END: Work In Progress -->
                                            <!-- BEGIN: Daily Sales -->
                                            <div class="box relative before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md col-span-12 p-0 lg:col-span-6">
                                                <div class="flex items-center px-5 py-5 border-b sm:py-3">
                                                    <h2 class="mr-auto text-base font-medium">Daily Sales</h2>
                                                    <div data-tw-placement="bottom-end" class="dropdown ml-auto sm:hidden">
                                                        <a data-tw-toggle="dropdown" class="dropdown-toggle cursor-pointer relative z-[51] block size-5" href="#">
                                                            <i data-lucide="more-horizontal" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-5 opacity-70"></i>
                                                        </a>
                                                        <div class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&.show]:visible [&.show]:opacity-100">
                                                            <div class="dropdown-content w-40">
                                                                <a class="relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50">
                                                                    <i data-lucide="file" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                                    Download
                                                                    Excel
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <button class="[--color:var(--color-foreground)] cursor-pointer border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 hidden sm:flex">
                                                        <i data-lucide="file" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 mr-2 size-4"></i>
                                                        Download
                                                        Excel
                                                    </button>
                                                </div>
                                                <div class="p-5">
                                                    <div class="relative flex items-center">
                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-12">
                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/profile-13.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                        </span>
                                                        <div class="ml-4 mr-auto">
                                                            <a class="font-medium" href="">
                                                                Brad Pitt
                                                            </a>
                                                            <div class="mr-5 opacity-70 sm:mr-5">
                                                                Bootstrap 4 HTML Admin Template
                                                            </div>
                                                        </div>
                                                        <div class="font-medium">
                                                            +$19
                                                        </div>
                                                    </div>
                                                    <div class="relative flex items-center mt-5">
                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-12">
                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/profile-11.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                        </span>
                                                        <div class="ml-4 mr-auto">
                                                            <a class="font-medium" href="">
                                                                Robert De Niro
                                                            </a>
                                                            <div class="mr-5 opacity-70 sm:mr-5">
                                                                Tailwind Admin Dashboard Template
                                                            </div>
                                                        </div>
                                                        <div class="font-medium">
                                                            +$25
                                                        </div>
                                                    </div>
                                                    <div class="relative flex items-center mt-5">
                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-12">
                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/profile-7.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                        </span>
                                                        <div class="ml-4 mr-auto">
                                                            <a class="font-medium" href="">
                                                                Leonardo DiCaprio
                                                            </a>
                                                            <div class="mr-5 opacity-70 sm:mr-5">
                                                                Vuejs HTML Admin Template
                                                            </div>
                                                        </div>
                                                        <div class="font-medium">
                                                            +$21
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- END: Daily Sales -->
                                            <!-- BEGIN: Latest Tasks -->
                                            <div class="box relative before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md col-span-12 p-0 lg:col-span-6">
                                                <div class="tabs relative w-full">
                                                    <div class="relative flex items-center p-5 border-b">
                                                        <h2 class="mr-auto text-base font-medium">
                                                            Latest Tasks
                                                        </h2>
                                                        <div data-tw-placement="bottom-end" class="dropdown ml-auto sm:hidden">
                                                            <a data-tw-toggle="dropdown" class="dropdown-toggle cursor-pointer relative z-[51] block size-5" href="#">
                                                                <i data-lucide="more-horizontal" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-5 opacity-70"></i>
                                                            </a>
                                                            <div class="box before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md dropdown-menu invisible absolute z-50 p-1 opacity-0 before:backdrop-blur-xl [&.show]:visible [&.show]:opacity-100">
                                                                <div class="dropdown-content w-40">
                                                                    <li role="presentation" class="z-20 relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50 w-full">
                                                                        <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                                            New
                                                                        </button>
                                                                    </li>
                                                                    <li role="presentation" class="z-20 relative flex cursor-default select-none hover:bg-foreground/5 items-center rounded-lg px-2 py-1.5 outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50 w-full">
                                                                        <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                                            Last Week
                                                                        </button>
                                                                    </li>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <ul role="tablist" class="bg-foreground/5 z-0 h-10 select-none items-center justify-center rounded-xl p-1 [&&gt;*]:flex-1 absolute inset-y-0 hidden w-auto my-auto right-5 sm:flex">
                                                            <li role="presentation" class="z-20 w-full">
                                                                <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                                    New
                                                                </button>
                                                            </li>
                                                            <li role="presentation" class="z-20 w-full">
                                                                <button class="[&.active]:bg-background inline-flex w-full cursor-pointer items-center justify-center whitespace-nowrap rounded-lg px-3 py-1.5 font-medium [&.active]:shadow" type="button" role="tab">
                                                                    Last Week
                                                                </button>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    <div class="p-5">
                                                        <div class="tab-pane hidden [&.active]:block" role="tabpanel">
                                                            <div>
                                                                <div class="flex items-center">
                                                                    <div class="pl-4 border-l-4 border-primary/20">
                                                                        <a class="font-medium" href="">
                                                                            Create New Campaign
                                                                        </a>
                                                                        <div class="opacity-70">10:00 AM</div>
                                                                    </div>
                                                                    <div class="ml-auto">
                                                                        <div class="relative h-6 w-11">
                                                                            <input class="peer relative z-10 size-full cursor-pointer opacity-0" type="checkbox">
                                                                            <div class="bg-foreground/15 peer-checked:bg-foreground absolute inset-0 rounded-full transition-all">
                                                                            </div>
                                                                            <div class="z-4 bg-background absolute inset-0 inset-y-0 my-auto ml-0.5 size-5 rounded-full shadow transition-[margin] ease-linear peer-checked:ml-[1.35rem]">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex items-center mt-5">
                                                                    <div class="pl-4 border-l-4 border-primary/20">
                                                                        <a class="font-medium" href="">
                                                                            Meeting With Client
                                                                        </a>
                                                                        <div class="opacity-70">02:00 PM</div>
                                                                    </div>
                                                                    <div class="ml-auto">
                                                                        <div class="relative h-6 w-11">
                                                                            <input class="peer relative z-10 size-full cursor-pointer opacity-0" type="checkbox">
                                                                            <div class="bg-foreground/15 peer-checked:bg-foreground absolute inset-0 rounded-full transition-all">
                                                                            </div>
                                                                            <div class="z-4 bg-background absolute inset-0 inset-y-0 my-auto ml-0.5 size-5 rounded-full shadow transition-[margin] ease-linear peer-checked:ml-[1.35rem]">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex items-center mt-5">
                                                                    <div class="pl-4 border-l-4 border-primary/20">
                                                                        <a class="font-medium" href="">
                                                                            Create New Repository
                                                                        </a>
                                                                        <div class="opacity-70">04:00 PM</div>
                                                                    </div>
                                                                    <div class="ml-auto">
                                                                        <div class="relative h-6 w-11">
                                                                            <input class="peer relative z-10 size-full cursor-pointer opacity-0" type="checkbox">
                                                                            <div class="bg-foreground/15 peer-checked:bg-foreground absolute inset-0 rounded-full transition-all">
                                                                            </div>
                                                                            <div class="z-4 bg-background absolute inset-0 inset-y-0 my-auto ml-0.5 size-5 rounded-full shadow transition-[margin] ease-linear peer-checked:ml-[1.35rem]">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- END: Latest Tasks -->
                                            <!-- BEGIN: New Products -->
                                            <div class="box relative before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md col-span-12 p-0">
                                                <div class="flex items-center px-5 py-3 border-b">
                                                    <h2 class="mr-auto text-base font-medium">
                                                        New Products
                                                    </h2>
                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 mr-2">
                                                        <i data-lucide="chevron-left" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-4"></i>
                                                    </button>
                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2">
                                                        <i data-lucide="chevron-right" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-4"></i>
                                                    </button>
                                                </div>
                                                <div class="px-5">
                                                    <div data-config="{}" class="tiny-slider py-5">
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/preview-12.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Sony Master Series A9G
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:border-t-0 lg:pt-0">
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            70
                                                                        </div>
                                                                        <div class="opacity-70">Orders</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            54k
                                                                        </div>
                                                                        <div class="opacity-70">Purchases</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            70
                                                                        </div>
                                                                        <div class="opacity-70">Reviews</div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        29 May 2021
                                                                    </div>
                                                                    <div class="opacity-70">
                                                                        Date of Release
                                                                    </div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Preview
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Details
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/preview-8.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Dell XPS 13
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:border-t-0 lg:pt-0">
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            92
                                                                        </div>
                                                                        <div class="opacity-70">Orders</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            121k
                                                                        </div>
                                                                        <div class="opacity-70">Purchases</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            92
                                                                        </div>
                                                                        <div class="opacity-70">Reviews</div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        27 October 2020
                                                                    </div>
                                                                    <div class="opacity-70">
                                                                        Date of Release
                                                                    </div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Preview
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Details
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/preview-1.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Oppo Find X2 Pro
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:border-t-0 lg:pt-0">
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            29
                                                                        </div>
                                                                        <div class="opacity-70">Orders</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            77k
                                                                        </div>
                                                                        <div class="opacity-70">Purchases</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            29
                                                                        </div>
                                                                        <div class="opacity-70">Reviews</div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        5 January 2021
                                                                    </div>
                                                                    <div class="opacity-70">
                                                                        Date of Release
                                                                    </div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Preview
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Details
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/preview-10.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Oppo Find X2 Pro
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomi
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:border-t-0 lg:pt-0">
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            149
                                                                        </div>
                                                                        <div class="opacity-70">Orders</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            42k
                                                                        </div>
                                                                        <div class="opacity-70">Purchases</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            149
                                                                        </div>
                                                                        <div class="opacity-70">Reviews</div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        20 March 2021
                                                                    </div>
                                                                    <div class="opacity-70">
                                                                        Date of Release
                                                                    </div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Preview
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Details
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/preview-2.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Samsung Galaxy S20 Ultra
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 20
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:border-t-0 lg:pt-0">
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            59
                                                                        </div>
                                                                        <div class="opacity-70">Orders</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            34k
                                                                        </div>
                                                                        <div class="opacity-70">Purchases</div>
                                                                    </div>
                                                                    <div class="w-20 py-3 text-center rounded-md">
                                                                        <div class="text-xl font-medium">
                                                                            59
                                                                        </div>
                                                                        <div class="opacity-70">Reviews</div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        6 April 2021
                                                                    </div>
                                                                    <div class="opacity-70">
                                                                        Date of Release
                                                                    </div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Preview
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Details
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- END: New Products -->
                                            <!-- BEGIN: New Authors -->
                                            <div class="box relative before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md col-span-12 p-0">
                                                <div class="flex items-center px-5 py-3 border-b">
                                                    <h2 class="mr-auto text-base font-medium">New Authors</h2>
                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 mr-2">
                                                        <i data-lucide="chevron-left" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-4"></i>
                                                    </button>
                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2">

                                                    </button>
                                                </div>
                                                <div class="px-5">
                                                    <div data-config="{}" class="tiny-slider py-5">
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center flex-1 pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/profile-13.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Brad Pitt
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            Software Engineer
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex flex-col items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:items-start lg:border-t-0 lg:pt-0">
                                                                    <div class="flex items-center">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="facebook" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        bradpitt@left4code.com
                                                                    </div>
                                                                    <div class="flex items-center mt-2">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="twitter" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        Brad Pitt
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        29 May 2021
                                                                    </div>
                                                                    <div class="opacity-70">Joined Date</div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Message
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Profile
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center flex-1 pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/profile-11.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Robert De Niro
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            Frontend Engineer
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex flex-col items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:items-start lg:border-t-0 lg:pt-0">
                                                                    <div class="flex items-center">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="facebook" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        robertdeniro@left4code.com
                                                                    </div>
                                                                    <div class="flex items-center mt-2">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="twitter" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        Robert De Niro
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        27 October 2020
                                                                    </div>
                                                                    <div class="opacity-70">Joined Date</div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Message
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Profile
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center flex-1 pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/profile-7.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Leonardo DiCaprio
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            DevOps Engineer
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex flex-col items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:items-start lg:border-t-0 lg:pt-0">
                                                                    <div class="flex items-center">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="facebook" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        leonardodicaprio@left4code.com
                                                                    </div>
                                                                    <div class="flex items-center mt-2">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="twitter" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        Leonardo DiCaprio
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        5 January 2021
                                                                    </div>
                                                                    <div class="opacity-70">Joined Date</div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Message
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Profile
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center flex-1 pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/profile-11.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                            Russell Crowe
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            Backend Engineer
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex flex-col items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:items-start lg:border-t-0 lg:pt-0">
                                                                    <div class="flex items-center">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="facebook" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        <%= @current_user.email %>
                                                                    </div>
                                                                    <div class="flex items-center mt-2">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="twitter" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        Russell Crowe
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        20 March 2021
                                                                    </div>
                                                                    <div class="opacity-70">Joined Date</div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Message
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Profile
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="px-5">
                                                            <div class="flex flex-col items-center pb-5 lg:flex-row">
                                                                <div class="flex flex-col items-center flex-1 pr-5 sm:flex-row lg:border-r">
                                                                    <div class="sm:mr-5">
                                                                        <span data-content="" class="tooltip border-(--color)/5 block relative flex-none overflow-hidden rounded-full border-3 ring-1 ring-(--color)/25 [--color:var(--color-primary)] size-20">
                                                                            <img class="absolute top-0 size-full object-cover" src="dist/images/fakers/profile-15.jpg" alt="Midone - Tailwind Admin Dashboard Template">
                                                                        </span>
                                                                    </div>
                                                                    <div class="mt-3 mr-auto text-center sm:mt-0 sm:text-left">
                                                                        <a class="text-lg font-medium" href="">
                                                                        <%= @current_user.username %>
                                                                        </a>
                                                                        <div class="mt-1 opacity-70 sm:mt-0">
                                                                            Online
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="flex flex-col items-center justify-center flex-1 w-full px-5 pt-4 mt-6 border-t lg:mt-0 lg:w-auto lg:items-start lg:border-t-0 lg:pt-0">
                                                                    <div class="flex items-center">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="facebook" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        <%= @current_user.email %>
                                                                    </div>
                                                                    <div class="flex items-center mt-2">
                                                                        <a class="flex items-center justify-center w-8 h-8 mr-3 border rounded-full" href="">
                                                                            <i data-lucide="twitter" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-current size-3 opacity-70"></i>
                                                                        </a>
                                                                        <%= @current_user.username %>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="flex flex-col items-center pt-5 border-t sm:flex-row">
                                                                <div class="flex items-center justify-center w-full pb-5 border-b sm:w-auto sm:justify-start sm:border-b-0 sm:pb-0">
                                                                    <div class="bg-(--color)/20 border-(--color)/60 text-(--color) mr-3 rounded-xl border px-3 py-2 font-medium [--color:var(--color-primary)]">
                                                                        6 April 2021
                                                                    </div>
                                                                    <div class="opacity-70">Joined Date</div>
                                                                </div>
                                                                <div class="flex mt-5 sm:ml-auto sm:mt-0">
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-auto">
                                                                        Message
                                                                    </button>
                                                                    <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 px-4 py-2 ml-2">
                                                                        Profile
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- END: New Authors -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <script src={~p"/assets/js/vendors/lucide.js"}></script>
                        <script src={~p"/assets/js/components/base/lucide.js"}></script>

    """
  end
end
