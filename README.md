# StatsD Server

A fault-tolerant and concurrent StatsD server.

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

## Testing

```
echo "requests|c|99" | nc -u -w0 127.0.0.1 2052
```
