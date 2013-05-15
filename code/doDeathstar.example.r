require(doDeathstar)
registerDoDeathstar("localhost")

z <- foreach(i=1:100) %dopar% {
    set.seed(i)
    numDraws <- 1e4
    r <- .5
    x <- runif(numDraws, min=-r, max=r)
    y <- runif(numDraws, min=-r, max=r)
    inCircle <- ifelse( (x^2 + y^2)^.5 < r , 1, 0)
    sum(inCircle) / length(inCircle) * 4
}


