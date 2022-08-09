# Spike.LiveView

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
capabilities out of the box by defining them as follows:

```
# for LiveView
defmodule MyApp.MyFormLive do
  use MyAppWeb, :form_live_view

  def mount(_params, _, socket) do
    form = init_form()

    {:ok,
     socket
     |> assign(%{form: form, errors: Spike.errors(form)})}
  end

  ...
end

# for LiveComponent
defmodule MyApp.MyFormLiveComponent do
  use MyAppWeb, :form_live_view

  def mount(_params, _, socket) do
    form = init_form()

    {:ok,
     socket
     |> assign(%{form: form, errors: Spike.errors(form)})}
  end
```


