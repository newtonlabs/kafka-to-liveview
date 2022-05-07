# Kafka To LiveView
A POC code repository to show an event flowing from 
1. Kafka
1. Broadway
1. Elixir Pubsub
1. Live View

### Download Kafka

Get the latest version of Kafka
* [Kafka Link](https://kafka.apache.org/downloads)

### Start Kafka

Start the server

```
$ bin/zookeeper-server-start.sh config/zookeeper.properties
$ bin/kafka-server-start.sh config/server.properties
```

Create a topic, if not already in place. For this demo we are using the topic "orders"
```
$ bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
```

### Setup to send messages to Kafka in REPL

```
topic = "orders"
client_id = :my_client
hosts = [localhost: 9092]

:ok = :brod.start_client(hosts, client_id, _client_config=[])
:ok = :brod.start_producer(client_id, topic, _producer_config = [])

```

### Fire Away

Send messages to Kafka, to be picked up by Broadway, to send to Phoenix to send to FE
```
# Format is unique id, name, and a price.  Name and price will update based on ID
:brod.produce_sync(client_id, topic, 0, _key="", "id-1, name-1, price-23")
```
