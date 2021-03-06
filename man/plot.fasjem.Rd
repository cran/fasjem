\name{plot.fasjem}
\alias{plot.fasjem}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Plotting functions for displaying the list of multiple graphs generated by the fasjem algorithm
}
\description{
  Plotting function for fasjem objects.
  This function plots either the shared graph, the task-specific networks, the networks or the neighborhood networks for a certain node. Please run demo(fasjem) to learn the basic functions provided by this package.  For further details, please read the original paper:  <http://proceedings.mlr.press/v54/wang17e/wang17e.pdf>. }
\usage{
  \method{plot}{fasjem}(x, type="graph", subID=NULL, index=NULL, ...)
}
\arguments{
  \item{x}{
    fasjem object
  }
  \item{type}{
    Plotting type. This argument defines which type of network(s) to plot. There are four options:
    "graph": plot the networks. The different colors represent the different graphs.

    "share": plot the shared graph.

    "sub": plot subject-specific networks.

    "neighbor": plot the neighborhood networks for a given node. The different colors represent the different graphs.
  }
  \item{subID}{
    If \code{type="sub"}, \code{subID} indicates to plot the task-specific network for the task whose index == subID.
  }
  \item{index}{
    If \code{type="neighbor"}, \code{index} indicates the row number of the node to be investigated. This function plots its neighborhood subgraphs from each graph of the multiple graphs generated by fasjem algorithm.
  }
  \item{...}{
    Additional arguments to pass to plot function
  }
}
\details{
  Plotting function for fasjem objects. It plots the results obtained from running fasjem algorithm.
}
\references{
Beilun Wang, Ji Gao, Yanjun Qi (2017). A Fast and Scalable Joint Estimator for Learning Multiple Related Sparse Gaussian Graphical Models. <http://proceedings.mlr.press/v54/wang17e/wang17e.pdf>
}
\author{
  Beilun Wang and Yanjun Qi
}
\seealso{
  \code{\link{fasjem}}
}
\examples{
  \dontrun{
    data(exampleData)
    results = fasjem(X = exampleData, method = "fasjem-g", 0.1, 0.1, 0.1, 0.05, 10)
    plot.fasjem(results)
    plot.fasjem(results, type="share")
    plot.fasjem(results, type="sub", subID=1)
    plot.fasjem(results, type="neighbor", index=50)
  }
}
\keyword{ fasjem }
