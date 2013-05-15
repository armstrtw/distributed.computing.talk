require(rzmq)

ctx <- init.context()
responder <- init.socket(ctx,"ZMQ_REP")
bind.socket(responder, "tcp://*:5558")

while (1) {
    msg <- receive.socket(responder)
    fun <- msg$fun
    args <- msg$args
    result <- do.call(fun,args)
    send.socket(responder, result)
}
