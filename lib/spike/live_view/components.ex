defmodule Spike.LiveView.Components do
  use Phoenix.Component

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

  def errors(%{errors: _, form: _, field: _} = assigns) do
    assigns =
      assigns
      |> assign_new(:dirty_fields, fn -> Spike.dirty_fields(assigns.form) end)

    field_errors = field_errors(assigns)

    if field_errors != [] do
      ~H"""
        <%= render_slot(@inner_block, field_errors) %>
      """
    else
      ~H"""
      """
    end
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

