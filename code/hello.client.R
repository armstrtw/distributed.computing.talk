require(rzmq)

ctx <- init.context()

requester <-  init.socket(ctx,"ZMQ_REQ")

connect.socket(requester, "tcp://localhost:5555")

for(request.number in 1:10) {
    print(paste("Sending Hello", request.number))
    send.socket(requester, "Hello")
    reply <- receive.socket(requester)
    print(paste("Received:",reply,"number",request.number))
}
