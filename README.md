# StatsD Server

A fault-tolerant and concurrent StatsD server.

![Supervision Tree](https://raw.githubusercontent.com/joshnuss/elixir-statsd/master/supervision-tree.jpg)

## Installation

```
hub clone joshnuss/elixir-statsd
cd elixir-statsd
```

## Running

To run on port 2052

```
./statsd 2052
```

### With multiple sockets

```
./statsd 2052 2053
```

## Testing

```
echo "requests|c|99" | nc -u -w0 127.0.0.1 2052
```
