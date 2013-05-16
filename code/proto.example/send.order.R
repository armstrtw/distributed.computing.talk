require(rzmq,quietly=TRUE)
require(RProtoBuf,quietly=TRUE)

ctx <- init.context()
broker <- init.socket(ctx,"ZMQ_REQ")
connect.socket(broker, "tcp://*:5559")


## read the proto file
readProtoFiles(files=c("order.proto","fill.proto"))

aapl.order <- new(tutorial.Order,
                  symbol = "AAPL",
                  price = 600.9,
                  size = 100L
                  )

aapl.bytes <- serialize(aapl.order, NULL)

## send order
send.socket(broker, aapl.bytes, serialize=FALSE)

## pull back fill information
fill.bytes <- receive.socket(broker,unserialize=FALSE)
fill <- tutorial.Fill$read(fill.bytes)
fill$toString()
