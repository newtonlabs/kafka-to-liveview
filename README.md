# Pubsublive
A POC code repository to show an event flowing from 
1. Kafka
1. Broadway
1. Elixir Pubsub
1. Live View


### Start Kafka

```
$ bin/zookeeper-server-start.sh config/zookeeper.properties
$ bin/kafka-server-start.sh config/server.properties
```

### Send Messagss in REPL

```
topic = "orders"
client_id = :my_client
hosts = [localhost: 9092]

:ok = :brod.start_client(hosts, client_id, _client_config=[])
:ok = :brod.start_producer(client_id, topic, _producer_config = [])

```
:brod.produce_sync(client_id, topic, 0, _key="", "id-1, name-1, price-23")
```

# Enum.each(1..1000, fn i ->
#   partition = rem(i, 3)
#   :ok = :brod.produce_sync(client_id, topic, 0, _key="", "#{i}")
# end)

```


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
# kafka-to-liveview
