defmodule Spike.LiveView.FormField do
  use Phoenix.Component

  def form_field(%{form_data: _, key: _} = assigns) do
    assigns =
      assigns
      |> assign_new(:submit_event, fn -> "submit" end)
      |> assign_new(:target, fn -> nil end)

    ~H"""
      <form phx-change="spike-form-event:set-value" phx-target={@target} phx-submit={@submit_event}>      
        <input name="ref" type="hidden" value={@form_data.ref} />
        <input name="key" type="hidden" value={@key} />
        <%= render_slot(@inner_block) %>
      </form>
    """
  end
end
