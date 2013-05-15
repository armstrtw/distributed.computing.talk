#!/usr/bin/env Rscript

library(rzmq)

context = init.context()
pub.socket = init.socket(context,"ZMQ_PUB")
bind.socket(pub.socket,"tcp://*:5556")

node.names <- c("2yr","5yr","10yr")
usd.base.curve <- structure(rep(2,length(node.names)),names=node.names)
eur.base.curve <- structure(rep(1,length(node.names)),names=node.names)

while(1) {
    ## updates to USD swaps
    new.usd.curve <- usd.base.curve + rnorm(length(usd.base.curve))/100
    send.raw.string(pub.socket,"USD-SWAPS",send.more=TRUE)
    send.socket(pub.socket,new.usd.curve)

    ## updates to EUR swaps
    new.eur.curve <- eur.base.curve + rnorm(length(eur.base.curve))/100
    send.raw.string(pub.socket,"EUR-SWAPS",send.more=TRUE)
    send.socket(pub.socket,new.eur.curve)
}
