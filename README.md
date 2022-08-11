# Readme

`Spike.LiveView` provides a wrapper around
[Phoenix.LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) and
[Phoenix.LiveComponent](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html),
which simplifies working with memory-backed forms, including nested forms that require
contextual validation.

## Installation

[Available in Hex](https://hex.pm/packages/spike_liveview), the package can be installed
by adding `spike_liveview` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spike_liveview, "~> 0.2"}
  ]
end
```

Documentation can be found at <https://hexdocs.pm/spike_liveview>.

## Quick start

Once installed in a Phoenix project, open up your `*_web.ex` file and add the following
functions:

```
  def form_live_view do
    quote do
      use Phoenix.LiveView,
        layout: {MyAppWeb.LayoutView, "live.html"}

      unquote(view_helpers())

      use Spike.LiveView
    end
  end

  def form_live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())

      use Spike.LiveView
    end
  end
```

This allows you to build LiveViews and LiveComponents that ship with form and form erors handling
capabilities out of the box.

You will need a Spike form. For usage how to build these, refer to [Spike docs](https://hexdocs.pm/spike).

For example, your simplest possible registration form may look like this:

```
defmodule MyApp.RegistrationForm do
  use Spike.Form do
    field(:username, :string)
    field(:password, :string)

    validates(:username, presence: true, by: &__MODULE__.validate_not_taken/2)
    validates(:password, presence: true)
  end

  def validate_not_taken(value, _context) do
    if MyApp.Repo.get_by(MyApp.User, username: value) do
      {:error, "username already taken"}
    else
      :ok
    end
  end
end
```

And a LiveView to handle registration process would be:


```
defmodule MyAppWeb.RegistrationLive do
  use MyAppWeb, :form_live_view
  import Spike.LiveView.Components

  def mount(_params, _, socket) do
    form = MyApp.RegistrationForm.new(%{})

    {:ok,
     socket
     |> assign(%{form: form, errors: Spike.errors(form)})}
  end

  def render(assigns) do
    ~H"""
    <h1>Register</h1>

    <div>
      <label for="username">Username:</label>

      <.form_field field={:username} form={@form}>
        <input id="username" name="value" type="text" value={@form.username} />
      </.form_field>

      <.errors let={field_errors} field={:username} form={@form} errors={@errors}>
        <span class="error">
          <%= field_errors |> Enum.map(fn {_k, v} -> v end) |> Enum.join(", ") %>
        </span>
      </.errors>
    </div>

    <div>
      <label for="password">Password:</label>

      <.form_field field={:password} form={@form}>
        <input id="password" name="value" type="text" value={@form.password} />
      </.form_field>

      <.errors let={field_errors} field={:password} form={@form} errors={@errors}>
        <span class="error">
          <%= field_errors |> Enum.map(fn {_k, v} -> v end) |> Enum.join(", ") %>
        </span>
      </.errors>
    </div>

    <a href="#" phx-click="register">Register!</a>
    """
  end

  def handle_event("register", _, socket) do
    if socket.assigns.errors == %{} do
      # perform registration logic here
      IO.puts("Registering user with #{socket.assigns.form.username} and #{socket.assigns.form.password}....")
      {:noreply, socket}   
    else
      {:noreply, socket |> assign(:form, Spike.make_dirty(socket.assigns.form))}
    end
  end
end
```

Remember to mount it at router and visit <http://localhost:4000/register>:
```
  scope "/", MyAppWeb do
    pipe_through :browser

    live "/register", RegistrationLive
  end
```


Usage of form components provided by this library is, however, pretty low-level, and we
recommend you build your own form components instead.

For starting point to build your own form components,
see our [Components Library](components_library.md).

With the above components, we can shorten our `render/1` function:

```
  def render(assigns) do
    ~H"""
    <h1>Register</h1>

    <Input type="text" form={@form} field={:username} errors={@errors} />
    <Input type="passwod" form={@form} field={:} errors={@errors} />
 
    <a href="#" phx-click="submit">Register!</a>
    """
  end
```

And that's pretty sweet!

See [Components Library](components_library.md),
[Spike Example app](https://github.com/hubertlepicki/spike_example) for more examples.

