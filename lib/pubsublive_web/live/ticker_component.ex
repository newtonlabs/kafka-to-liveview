defmodule PubsubliveWeb.TickerComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="w-40 shrink-0">
      <div class="text-slate-800 p-2 mr-px text-xs"> <%= @name %> </div>
    </div>
    """
  end
end
