# Components Library

Feel free to grab and customize these components to your needs, and treat them
as a starting point when building your form builder.

      import Spike.LiveView.Components

      def errors_component(%{form: _, field: _, errors: _} = assigns) do
        ~H"""
        <.errors let={field_errors} field={@field} form={@form} errors={@errors}>
          <span class="error">
            <%= field_errors |> Enum.map(fn {_k, v} -> v end) |> Enum.join(", ") %>
          </span>
        </.errors>
        """
      end

      def label_component(%{ref: _ref, text: _text, field: _field, required: required} = assigns) do
        if required do
          ~H"""
          <label for={"#{@ref}_#{@field}"}>* <%= @text %></label>
          """
        else
          ~H"""
          <label for={"#{@ref}_#{@field}"}><%= @text %></label>
          """
        end
      end

      def input_component(%{type: "textarea", field: _, form: _, errors: _} = assigns) do
        assigns = assigns |> assign_new(:target, fn -> nil end)

        ~H"""
        <div>
          <%= if @label do %>
            <.label_component text={@label} ref={@form.ref} field={@field} required={is_required?(@form, @field)} />
          <% end %>

          <.form_field field={@field} form={@form} target={@target}>
            <textarea id={"#{@form.ref}_#{@field}"} name="value"><%= @form |> Map.get(@field) %></textarea>
          </.form_field>

          <.errors_component form={@form} field={@field} errors={@errors} />
        </div>
        """
      end

      def input_component(%{type: type, field: _, form: _, errors: _} = assigns)
          when type in ["text", "password", "email"] do
        assigns = assigns |> assign_new(:target, fn -> nil end)

        ~H"""
        <div>
          <%= if @label do %>
            <.label_component text={@label} ref={@form.ref} field={@field} required={is_required?(@form, @field)} />
          <% end %>

          <.form_field field={@field} form={@form} target={@target}>
            <input id={"#{@form.ref}_#{@field}"} name="value" type={type} value={@form |> Map.get(@field)} />
          </.form_field>

          <.errors_component form={@form} field={@field} errors={@errors} />
        </div>
        """
      end

      def input_component(%{type: "checkbox", field: _, form: _, errors: _} = assigns) do
        assigns = assigns
                  |> assign_new(:checked_value, fn -> "1" end)
                  |> assign_new(:unchecked_value, fn -> "0" end)
                  |> assign_new(:target, fn -> nil end)

        ~H"""
        <div>
          <.form_field field={@field} form={@form} target={@target}>
            <span class="float-left">
              <input id={"#{@form.ref}_#{@field}_unchecked"} name="value" type="hidden" value={@unchecked_value} />
              <input id={"#{@form.ref}_#{@field}"} name="value" type="checkbox" value={@checked_value} checked={is_checked?(@form, @field, @checked_value)} />
            </span>

            <span>
              <%= if @label do %>
                <.label_component text={@label} ref={@form.ref} field={@field} required={is_required?(@form, @field)} />
              <% end %>
            </span>

          </.form_field>

          <.errors_component form={@form} field={@field} errors={@errors} />
        </div>
        """
      end

      def input_component(%{type: "select", field: _, form: _, errors: _, options: _} = assigns) do
        assigns = assigns |> assign_new(:target, fn -> nil end)

        ~H"""
        <div>
          <%= if @label do %>
            <.label_component text={@label} ref={@form.ref} field={@field} required={is_required?(@form, @field)} />
          <% end %>

          <.form_field field={@field} form={@form} target={@target}>
            <select id={"#{@form.ref}_#{@field}"} name="value">
              <%= for {value, text} <- @options do %>
                <option value={value || ""} selected={@form |> Map.get(@field) == value}><%= text %></option>
              <% end %>
            </select>
          </.form_field>

          <.errors_component form={@form} field={@field} errors={@errors} />
        </div>
        """
      end

      defp is_checked?(form, field, checked_value) do
        Map.get(form, field) == checked_value || Map.get(form, field) == true
      end

      defp is_required?(form, field) do
        validations = Vex.Extract.settings(form) |> Map.get(field, [])
        {:presence, true} in validations
      end

