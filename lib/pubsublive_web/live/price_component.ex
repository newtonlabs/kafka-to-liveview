defmodule PubsubliveWeb.PriceComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="shadow-md w-14 py-3 mr-1 bg-blue-100 border-blue-100 border text-center rounded-md hover:bg-sky-800 hover:text-white" phx-hook="Price" id={@id}> <%= @value %></div>
    """
  end
end
