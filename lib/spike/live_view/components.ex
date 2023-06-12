defmodule Spike.LiveView.Components do
  @moduledoc """
  Provides low-level components that can be useful to
  built higher-level form input components in your app.

  For starting point to build your own form components,
  see our [Components Library](components_library.md).
  """

  use Phoenix.Component

  @doc """
  Renders form, which wraps input fields, allowing for 
  `Spike.LiveView` events to be emitted on change, and
  captured by LiveView or LiveComponent specified by
  `target` attribute. 

  This component accepts a slot, in which your input field
  should reside along with any additional markup you may
  require, and the following attributes:

  * form - required, should map to `Spike.Form`, usually
    `@form` in `assigns`
  * field - required, atom, should be one of the existing
    fields on the form
  * submit_event - optional, name of an event that will be
    emitted when, for example, user hits Enter on the input
  * target - optional, leave `nil` if your `@form` is handled
    by LiveView, set to `@myself` (or component selector) if
    the form changes should be handled by a component.

        import Spike.LiveView.Components
        ...
        <.form_field form={@form} field={:first_name}>
          <input type="text" name="value" value={@form_field.first_name} />
        </.form_field>

  """
  def form_field(%{form: _, field: _} = assigns) do
    assigns =
      assigns
      |> assign_new(:submit_event, fn -> "submit" end)
      |> assign_new(:target, fn -> nil end)

    ~H"""
      <form phx-change="spike-form-event:set-value" phx-target={@target} phx-submit={@submit_event}>      
        <input name="ref" type="hidden" value={@form.ref} />
        <input name="field" type="hidden" value={@field} />
        <%= render_slot(@inner_block) %>
      </form>
    """
  end

  @doc """
  Allows you to get a map of errors on dirty fields of given form.

  Attributes:

    * form - required, should map to `Spike.Form`, usually
      `@form` in `assigns`
    * field - required, atom, should be one of the existing
      fields on the form
    * dirty_fields -> optional, defautls to `Spike.dirty_fields(form)`

          import Spike.LiveView.Components
          ...

          <.errors let={field_errors} field={@field} form={@form} errors={@errors}>
            <span class="error">
              <%= field_errors |> Enum.map(fn {_k, v} -> v end) |> Enum.join(", ") %>
            </span>
          </.errors>
  """
  def errors(%{errors: _, form: _, field: _} = assigns) do
    assigns =
      assigns
      |> assign_new(:dirty_fields, fn -> Spike.dirty_fields(assigns.form) end)

    assigns = assign(assigns, :field_errors, field_errors(assigns))

    ~H"""
      <%= if @field_errors != [] do %>
        <%= render_slot(@inner_block, @field_errors) %>
      <% end %>
    ~H\"""
    """
  end

  defp field_errors(%{errors: errors, form: form, field: field, dirty_fields: dirty_fields}) do
    if errors[form.ref] && errors[form.ref] |> Map.get(field) &&
         dirty_fields[form.ref] && field in dirty_fields[form.ref] do
      errors[form.ref][field]
    else
      []
    end
  end
end
