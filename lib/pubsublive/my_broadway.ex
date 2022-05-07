defmodule Pubsublive.MyBroadway do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    IO.inspect("link started")

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092],
             group_id: "group_1",
             topics: ["orders"]
           ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 10
        ]
      ],
      batchers: [
        default: [
          batch_size: 100,
          batch_timeout: 200,
          concurrency: 10
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    # IO.inspect("handled")
    result =
      message
      # |> Message.update_data(fn data -> {data, String.to_integer(data) * 2} end)
      |> Message.update_data(&process_string_to_tuple_hack/1)

    # |> Message.update_data(fn data -> data end)

    IO.inspect("broadcasting....")
    IO.inspect(result.data)

    Phoenix.PubSub.broadcast(Pubsublive.PubSub, "notifications", result.data)
    result
  end

  def process_string_to_tuple_hack(data) do
    data
    |> String.split(",")
    |> List.to_tuple()
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    # list = messages |> Enum.map(fn e -> e.data end)
    # IO.inspect(list, label: "Got batch")
    messages
  end
end
