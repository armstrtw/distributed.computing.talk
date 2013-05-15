#!/usr/bin/env Rscript

library(rzmq)


context = init.context()
subscriber = init.socket(context,"ZMQ_SUB")

connect.socket(subscriber,"tcp://localhost:5555")
topic <- "EUR-SWAPS"
subscribe(subscriber,topic)

while(1) {

    ## throw away the topic msg
    res.topic <- receive.string(subscriber)
    if(get.rcvmore(subscriber)) {
        res <- receive.socket(subscriber)
        print(res)
    }
}
