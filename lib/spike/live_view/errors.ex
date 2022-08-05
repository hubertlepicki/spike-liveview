defmodule Spike.LiveView.Errors do
  use Phoenix.Component

  def errors(%{errors: _, form_data: _, key: _} = assigns) do
    assigns =
      assigns
      |> assign_new(:dirty_fields, fn -> Spike.dirty_fields(assigns.form_data) end)

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

  defp field_errors(%{errors: errors, form_data: form_data, key: key, dirty_fields: dirty_fields}) do
    if errors[form_data.ref] && errors[form_data.ref] |> Map.get(key) &&
         dirty_fields[form_data.ref] && key in dirty_fields[form_data.ref] do
      errors[form_data.ref][key]
    else
      []
    end
  end
end
