defmodule Pubsublive.MyBroadway do
  use Broadway
  alias Broadway.Message

  # Configure a reall simple broadway pipeline with only 1 producer and 1 processor
  # This could be split out to have multiple stages for higher concurrency.
  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
        name: __MODULE__,
        producer: [
          module: {BroadwayKafka.Producer, [
            hosts: [localhost: 9092],
            group_id: "group_1",
            topics: ["orders"],
          ]},
          concurrency: 1
        ],
        processors: [
          default: [
            concurrency: 1
          ]
        ]
      )
  end

  def handle_message(_, message, _) do
    result =
      message
      |> Message.update_data(&process_string_to_tuple_hack/1)

    # Simulate some expensive work
    :timer.sleep(Enum.random(200..300))

    # Broadcast to all the phoenix live views that care about this data
    Phoenix.PubSub.broadcast(Pubsublive.PubSub, "notifications", result.data)

    result
  end

  def process_string_to_tuple_hack(data) do
    data
    |> String.split(",")
    |> List.to_tuple()
  end
end
