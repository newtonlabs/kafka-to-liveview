# Kafka To LiveView
A POC code repository to show an event flowing from 
1. Kafka
2. Broadway
3. Elixir Pubsub
4. Live View

### Deploy via Nullstone

```shell
docker build -t pubsublive .
nullstone launch --source=pubsublive --app=<app-name> --env=<env-name>
```

### How to run locally

```shell
# Start zookeeper, kafka, and postgres (detached)
docker compose up -d db kafka zookeeper
# Start app and tail logs
docker compose up app
```

Visit [http://localhost:4000/ticker](http://localhost:4000/ticker)

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
$ bin/kafka-topics.sh --create --topic orders --bootstrap-server localhost:9092
```

### Fire Away

Send messages to Kafka, to be picked up by Broadway, to send to Phoenix to send to FE
```
# Format is unique id, name, and a price.  Name and price will update based on ID
# Number of messages to send
PubsubLive.Orders.simulate(100)
```

### Code to look at for wiring

```


lib
├── pubsublive
│   ├── application.ex           # Broadway Config
│   ├── my_broadway.ex           # Broadway Code to accept Kafka
│   ├── orders.ex                # Generate messages for Kafka
└── pubsublive_web
    ├── live
    │   ├── ticker.ex            # Ticker LiveView, most of the code is here
    │   └── ticker_component.ex  # Ticker Component
    └── router.ex                # routes added for /ticker 

assets
├── css
│   └── app.css                  # Styling for flash on change
└── js
    └── app.js                   # Small hook for JS/LiveView Interop to flash
```
