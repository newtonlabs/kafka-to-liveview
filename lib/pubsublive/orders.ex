defmodule PubsubLive.Orders do

  @topic "orders"
  @client_id :my_client
  @hosts [kafka: 9092]
  @partition 0

  def simulate(count) do

    :ok = :brod.start_client(@hosts, @client_id, _client_config=[])
    :ok = :brod.start_producer(@client_id, @topic, _producer_config = [])


    events = 10
    names = create_names(events)

    Enum.each(1..count, fn _i ->

      event_id = Enum.random(0..events-1)
      name     = Enum.at(names, event_id)
      dollars  = price(event_id)
      cents    = Enum.random(0..99)
      cost     = "#{dollars}.#{cents}"

      :ok = :brod.produce_sync(@client_id, @topic, @partition, _key="", "#{event_id},#{name},#{cost}")
    end)

    :brod.stop_client(@client_id)
  end

  def price(event_id) do
    if (event_id == 3) do
      IO.puts(1)
      1
    else
      Enum.random(1..10)
    end
  end

  def create_names(amount) do
    Enum.map(1..amount, fn _i -> Faker.StarWars.character end)
  end
end
