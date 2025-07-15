defmodule TosWeb.UserRegistrationLive do
  use TosWeb, :live_view

  alias Tos.Account
  alias Tos.Account.User

  def render(assigns) do
    ~H"""
    <div class="relative h-screen lg:overflow-hidden bg-primary bg-noise xl:bg-background xl:bg-none before:hidden before:xl:block before:content-[''] before:w-[57%] before:-mt-[28%] before:-mb-[16%] before:-ml-[12%] before:absolute before:inset-y-0 before:left-0 before:transform before:rotate-[6deg] before:bg-primary/[.95] before:bg-noise before:rounded-[35%] after:hidden after:xl:block after:content-[''] after:w-[57%] after:-mt-[28%] after:-mb-[16%] after:-ml-[12%] after:absolute after:inset-y-0 after:left-0 after:transform after:rotate-[6deg] after:border after:bg-accent after:bg-cover after:blur-xl after:rounded-[35%] after:border-[20px] after:border-primary">
        <div class="p-3 sm:px-8 relative h-full before:hidden before:xl:block before:w-[57%] before:-mt-[20%] before:-mb-[13%] before:-ml-[12%] before:absolute before:inset-y-0 before:left-0 before:transform before:rotate-[-6deg] before:bg-primary/40 before:bg-noise before:border before:border-primary/50 before:opacity-60 before:rounded-[20%]">
            <div class="container relative z-10 mx-auto sm:px-20">
                <div class="block grid-cols-2 gap-4 xl:grid">
                    <!-- BEGIN: Register Info -->
                    <div class="hidden min-h-screen flex-col xl:flex">
                        <a class="flex items-center pt-10" href="">
                            <img class="w-6" src="dist/images/logo.svg" alt="Midone - Tailwind Admin Dashboard Template">
                            <span class="ml-3 text-xl font-medium text-white">
                                Midone <span class="font-light opacity-70">Admin</span>
                            </span>
                        </a>
                        <div class="my-auto">
                            <img class="-mt-16 w-1/2" src="dist/images/illustration.svg" alt="Midone - Tailwind Admin Dashboard Template">
                            <div class="mt-10 text-4xl font-medium leading-tight text-white">
                                A few more clicks to <br>
                                sign up to your account.
                            </div>
                            <div class="mt-5 text-lg text-white opacity-70">
                                Manage all your e-commerce accounts in one place
                            </div>
                        </div>
                    </div>
                    <!-- END: Register Info -->
                    <!-- BEGIN: Register Form -->
                    <.simple_form
                      for={@form}
                      id="registration_form"
                      phx-submit="save"
                      phx-change="validate"
                      phx-trigger-action={@trigger_submit}
                      action={~p"/users/log_in?_action=registered"}
                      method="post"
                    >
                    <div class="my-10 flex h-screen py-5 xl:my-0 xl:h-auto xl:py-0">
                        <div class="box relative p-5 before:absolute before:inset-0 before:mx-3 before:-mb-3 before:border before:border-foreground/10 before:bg-background/30 before:shadow-[0px_3px_5px_#0000000b] before:z-[-1] before:rounded-xl after:absolute after:inset-0 after:border after:border-foreground/10 after:bg-background after:shadow-[0px_3px_5px_#0000000b] after:rounded-xl after:z-[-1] after:backdrop-blur-md mx-auto my-auto w-full px-5 py-8 sm:w-3/4 sm:px-8 lg:w-2/4 xl:ml-24 xl:w-auto xl:p-0 xl:before:hidden xl:after:hidden">
                            <h2 class="text-center text-2xl font-semibold xl:text-left xl:text-3xl">
                                Sign Up
                            </h2>
                            <div class="mt-2 text-center opacity-70 xl:hidden">
                                A few more clicks to sign up to your account. Manage all your
                                e-commerce accounts in one place
                            </div>
                            <div class="mt-8 flex flex-col gap-5">
                                <.input field={@form[:username]} class="h-10 w-full rounded-md border bg-background ring-offset-background file:border-0 file:bg-transparent file:font-medium file:text-foreground placeholder:text-foreground/70 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-foreground/5 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 box block min-w-full px-5 py-6 xl:min-w-[28rem]" type="text" placeholder="Username" />
                                <.input field={@form[:email]} class="h-10 w-full rounded-md border bg-background ring-offset-background file:border-0 file:bg-transparent file:font-medium file:text-foreground placeholder:text-foreground/70 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-foreground/5 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 box block min-w-full px-5 py-6 xl:min-w-[28rem]" type="email" placeholder="Email" />
                                <div>
                                    <.input field={@form[:password]} class="h-10 w-full rounded-md border bg-background ring-offset-background file:border-0 file:bg-transparent file:font-medium file:text-foreground placeholder:text-foreground/70 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-foreground/5 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 box block min-w-full px-5 py-6 xl:min-w-[28rem]" type="password" placeholder="Password" />
                                </div>
                                <div class="flex text-xs sm:text-sm">
                                    <div class="flex gap-2.5 mr-auto flex-row items-center">
                                        <div class="bg-background border-foreground/70 relative size-4 rounded-sm border">
                                            <input class="peer relative z-10 size-full cursor-pointer opacity-0" type="checkbox" id="tos">
                                            <div class="z-4 bg-foreground invisible absolute inset-0 flex items-center justify-center text-white peer-checked:visible">
                                                <i data-lucide="check" class="stroke-[1.5] [--color:currentColor] stroke-(--color) fill-(--color)/25 size-4"></i>
                                            </div>
                                        </div>
                                        <label class="font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 opacity-70" for="tos">I agree to tos
                                            <a class="text-primary ml-1" href="">
                                                Privacy Policy
                                            </a>
                                            .</label>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-5 text-center xl:mt-10 xl:text-left">
                                <button class="cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 bg-(--color)/20 border-(--color)/60 text-(--color) hover:bg-(--color)/5 [--color:var(--color-primary)] h-10 box w-full px-4 py-5">
                                    Register
                                </button>
                                <button class="[--color:var(--color-foreground)] cursor-pointer inline-flex border items-center justify-center gap-2 whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 text-(--color) hover:bg-(--color)/5 bg-background border-(--color)/20 h-10 box mt-4 w-full px-4 py-5">
                                   Already haave an account? Login
                                </button>
                            </div>
                        </div>
                    </div>
                        </.simple_form>
                    <!-- END: Register Form -->
                </div>
            </div>
        </div>
    </div>

    """
  end

  def mount(_params, _session, socket) do
    changeset = Account.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Account.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Account.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Account.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Account.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end



# <div class="mx-auto max-w-sm">
# <.header class="text-center">
#   Register for an account
#   <:subtitle>
#     Already registered?
#     <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
#       Log in
#     </.link>
#     to your account now.
#   </:subtitle>
# </.header>

# <.simple_form
#   for={@form}
#   id="registration_form"
#   phx-submit="save"
#   phx-change="validate"
#   phx-trigger-action={@trigger_submit}
#   action={~p"/users/log_in?_action=registered"}
#   method="post"
# >
#   <.error :if={@check_errors}>
#     Oops, something went wrong! Please check the errors below.
#   </.error>

#   <.input field={@form[:email]} type="email" label="Email" required />
#   <.input field={@form[:password]} type="password" label="Password" required />

#   <:actions>
#     <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
#   </:actions>
# </.simple_form>
# </div>
