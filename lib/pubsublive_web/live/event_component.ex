defmodule PubsubliveWeb.EventComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="p-2" id={@id}> <%= @name %> </div>
    """
  end
end
