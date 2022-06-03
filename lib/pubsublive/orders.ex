defmodule PubsubLive.Orders do

  @topic "orders"
  @client_id :my_client
  @hosts [localhost: 9092]
  @partition 0

  def simulate(count) do

    :ok = :brod.start_client(@hosts, @client_id, _client_config=[])
    :ok = :brod.start_producer(@client_id, @topic, _producer_config = [])

    events = 10
    # ids    = events * 3

    Enum.each(1..count, fn _i ->
      # id = Enum.random(1..ids)

      event_id = Enum.random(1..events)
      dollars = Enum.random(1..20)
      cents = Enum.random(0..99)
      cost = "#{dollars}.#{cents}"

      payload =  "#{event_id},name-#{event_id},#{cost}"

      :ok = :brod.produce_sync(@client_id, @topic, @partition, _key="", "#{event_id},name-#{event_id},#{cost}")
    end)

    :brod.stop_client(@client_id)
  end
end
