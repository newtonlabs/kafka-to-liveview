defmodule PubsubLive.Orders do

  @topic "orders"
  @client_id :my_client
  @hosts [localhost: 9092]

  def simulate(count) do

    :ok = :brod.start_client(@hosts, @client_id, _client_config=[])
    :ok = :brod.start_producer(@client_id, @topic, _producer_config = [])

    Enum.each(1..count, fn _i ->
      partition = 0
      id = Enum.random(1..10)
      dollars = Enum.random(1..100)
      cents = Enum.random(0..99)
      :ok = :brod.produce_sync(@client_id, @topic, partition, _key="", "#{id},name-#{id},$#{dollars}.#{cents}")
    end)

    :brod.stop_client(@client_id)
  end
end
