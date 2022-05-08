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

### Open the App

* [http://localhost:4000/ticker](http://localhost:4000/ticker)

### Fire Away

Send messages to Kafka, to be picked up by Broadway, to send to Phoenix to send to FE
```
# Format is unique id, name, and a price.  Name and price will update based on ID
# Number of messages to send
PubsubLive.Orders.simulate(1000)
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