require(deathstar)

estimatePi <- function(seed) {
    set.seed(seed)
    numDraws <- 1e5
    r <- .5
    x <- runif(numDraws, min=-r, max=r)
    y <- runif(numDraws, min=-r, max=r)
    inCircle <- ifelse( (x^2 + y^2)^.5 < r , 1, 0)
    sum(inCircle) / length(inCircle) * 4
}

cluster <- c("localhost")
run.time <-
    system.time(ans <-
                zmq.cluster.lapply(cluster=cluster,
                                   as.list(1:1e3),
                                   estimatePi))

print(mean(unlist(ans)))
print(run.time)
print(attr(ans,"execution.report"))
