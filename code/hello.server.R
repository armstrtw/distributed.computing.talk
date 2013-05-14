require(rzmq)

ctx <- init.context()
responder <- init.socket(ctx,"ZMQ_REP")
bind.socket(responder, "tcp://*:5555")

while (1) {
    req <- receive.socket(responder)
    print("Received Hello")
    send.socket(responder, "World")
}
