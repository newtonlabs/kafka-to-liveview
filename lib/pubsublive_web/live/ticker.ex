defmodule PubsubliveWeb.Ticker do
  use Phoenix.LiveView
  alias Phoenix.LiveView.JS

  # Boot up the process and initialize state.  State is maintained in the socket.
  # Specifically assigns is used for application state.  Params will track http params
  # and URL params
  #
  # In this example we are:
  # 1. Booting up the process for the user and connecting their client
  # 2. Listening to the internal "notifications" pubsub that will broadcast events coming
  #    from Kafka
  # 3. Setting up initital state to show the users (a simple hash with tables and ids)
  def mount(_params, _session, socket) do
    PubsubliveWeb.Endpoint.subscribe("notifications")

    # Could be an HTTP / GraphQL query (perhaps more memory efficient to manage elsewhere)
    selections = [
      # {id, name, value}
      {"1", "home", "1"}
    ]

    {:ok, assign(socket, :selections, selections)}
  end

  # Now we render the page from the intial mount/bootstrap above
  # We need to use LiveView Components to only send state for that one item in the list
  # Otherwise, on change the entire payload will send to the wire vs the state maintained
  # In the component by the "id" passed
  def render(assigns) do
    ~H"""
    <table>
    <%= for {id, name, value} <- @selections do %>
    <div>
      <.live_component module={PubsubliveWeb.TickerComponent} id={id} name={name} value={value}/>
    </div>
    <% end %>
    </table>
    """
  end

  # This is a poorly peformant example as it sends the ENTIRE payload on any update, must pull into a component
  # that can manage their own state
  # def render(assigns) do
  #   ~H"""
  #   <table>
  #   <%= for {id, name, value} <- @selections do %>
  #   <div>
  #     <span class={JS.transition("highlight")}> <%= id %> <%= name %> <%= value %> </span>
  #   </div>
  #   <% end %>
  #   </table>
  #   """
  # end

  # Assumes fits the contract {id, name, value} from Broadway
  def handle_info(message, socket) do
    IO.puts("recieving message")
    IO.inspect(message)

    IO.puts("socket state")
    IO.inspect(socket.assigns.selections)

    IO.puts("updated state")
    selections = update_selections(socket.assigns.selections, message)
    IO.inspect(selections)

    {:noreply, assign(socket, :selections, selections)}
  end

  def update_selections([], message), do: [message]

  def update_selections([_head = {id, _name, _value} | tail], {id, new_name, new_value}),
    do: [{id, new_name, new_value} | tail]

  def update_selections([head | tail], message), do: [head | update_selections(tail, message)]
end

# {product_id: 123, quantity: 5}
# def insert_item([], new_item), do: [new_item]
# def insert_item([h = %{product_id: id, quantity: old_quantity}|t], %{product_id: id, quantity: growth}), do: [%{h | quantity: old_quantity + growth}|t]
# def insert_item([h|t], new_item), do: [h|insert_item(t, new_item)]
