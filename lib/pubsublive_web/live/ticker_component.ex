defmodule PubsubliveWeb.TickerComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="row">
      <div class="column column-20"> <%= @name %> </div>
      <div class="column column-10 selection" phx-hook="Price" id={@id}>  <%= @value %> </div>
    </div>
    """
  end
end
