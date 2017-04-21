.norm_vec <- function(x) sqrt(sum(x^2))
.norm_infty <- function(x) max(abs(x))

.f1 <- function(x, ga){
  result = sign(x) * pmax(abs(x)-ga, 0)
  return(result)
}

.g1 <- function(x, a, lambda){
  result = pmax(pmin(x - a, -lambda), lambda) + a
  return(result)
}

.f2 <- function(x, ga){
  result = x * array(pmax(1 - ga / apply(x, c(1,2), .norm_vec), 0), dim(x))
  return(result)
}

.g2 <- function(x, a, lambda){
  result = array(pmax(lambda / apply(x - a, c(1,2), .norm_vec), 1), dim(x)) * (x - a) + a
  return(result)
}

.f2_infty <- function(x, ga){
  result = x * array(pmax(1 - ga / apply(x, c(1,2), .norm_infty), 0), dim(x))
  return(result)
}

.g2_infty <- function(x, a, lambda){
  result = array(pmax(lambda / apply(x - a, c(1,2), .norm_infty), 1), dim(x)) * (x - a) + a
  return(result)
}

.fasjem_g <- function(a, lambda, epsilon, gamma, rho, iterMax){
  x  = .f1(a, (4*lambda*gamma))
  x1 = x
  x2 = x
  x3 = x
  x4 = x
  for (i in 1:iterMax){
    p1 = .f1(x1, (4*lambda*gamma))
    p2 = .g1(x2, a, (4*lambda*gamma*epsilon))
    p3 = .f2(x3, lambda)
    p4 = .g2(x4, a, (epsilon*lambda))
    p  = (p1 + p2 + p3 + p4) / 4
    x1 = x1 + (p * 2 - p1 - x1) * rho
    x2 = x2 + (p * 2 - p2 - x2) * rho
    x3 = x3 + (p * 2 - p3 - x3) * rho
    x4 = x4 + (p * 2 - p4 - x4) * rho
    x  = x  + (p - x) * rho
  }
  x = .f1(x, (4*lambda*gamma))
  return(x)
}

.fasjem_i <- function(a, lambda, epsilon, gamma, rho, iterMax){
  x  = .f1(a, (4*lambda*gamma))
  x1 = x
  x2 = x
  x3 = x
  x4 = x
  for (i in 1:iterMax){
    p1 = .f1(x1, (4*lambda*gamma))
    p2 = .g1(x2, a, (4*lambda*gamma*epsilon))
    p3 = .f2_infty(x3, lambda)
    p4 = .g2_infty(x4, a, (epsilon*lambda))
    p  = (p1 + p2 + p3 + p4) / 4
    x1 = x1 + (p * 2 - p1 - x1) * rho
    x2 = x2 + (p * 2 - p2 - x2) * rho
    x3 = x3 + (p * 2 - p3 - x3) * rho
    x4 = x4 + (p * 2 - p4 - x4) * rho
    x  = x  + (p - x) * rho
  }
  x = .f1(x, (4*lambda*gamma))
  return(x)
}

.EEGM <- function(covMatrix, lambda){
  result = sign(covMatrix) * pmax(abs(covMatrix)-lambda, 0)
  result
}

.backwardMap <-function(covMatrix){
  niuList = 0.001 * (1:1000)
  bestDet = det(.EEGM(covMatrix, 0.001))
  bestniu = 0.001
  for (i in 1:1000){
    if (bestDet < det(.EEGM(covMatrix, niuList[i]))){
      bestDet = det(.EEGM(covMatrix, niuList[i]))
      bestniu = niuList[i]
    }
  }
  return(solve(.EEGM(covMatrix, bestniu)))
}

fasjem <- function(X, method = "fasjem-g", lambda, epsilon, gamma, rho, iterMax){
  tmp = array(0, dim = c(dim(X[[1]])[1], dim(X[[1]])[2], length(X)))
  for (i in 1:length(X)){
    tmp[,,i] = X[[i]]
  }
  if (!isSymmetric(X[[1]])){
    tmp = array(apply(tmp, 3, cov), dim=c(ncol(X[[i]]), ncol(X[[i]]), length(X)))
  }

  tmp = array(apply(tmp, 3, .backwardMap), dim = c(ncol(X[[i]]), ncol(X[[i]]), length(X)))
  if(method == "fasjem-g"){
  tmp = .fasjem_g(tmp, lambda, epsilon, gamma, rho, iterMax)
  }
  if(method == "fasjem-i"){
    tmp = .fasjem_i(tmp, lambda, epsilon, gamma, rho, iterMax)
  }
  result = list()
  for (i in 1:dim(tmp)[3]){
    result[[i]] = tmp[, , i]
  }
  return(result)
}
