defmodule PubsubliveWeb.PriceComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="flex flex-row justify-end">
      <div class="w-14 py-2 mr-1 text-slate-800 bg-blue-100 border-blue-100 border text-center rounded-md hover:bg-sky-800 hover:text-white" phx-hook="Price" id={@id}> <%= @value %></div>
    </div>
    """
  end
end
