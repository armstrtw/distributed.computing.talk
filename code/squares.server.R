require(rzmq)

ctx <- init.context()
responder <- init.socket(ctx,"ZMQ_REP")
bind.socket(responder, "tcp://*:5557")

while (1) {
    req <- receive.socket(responder)
    send.socket(responder, req * req)
}
