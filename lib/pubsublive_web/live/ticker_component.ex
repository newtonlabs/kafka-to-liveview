defmodule PubsubliveWeb.TickerComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <span phx-hook="Price" id={@id}>  <%= @id %> <%= @name %> <%= @value %> </span>
    """
  end
end
