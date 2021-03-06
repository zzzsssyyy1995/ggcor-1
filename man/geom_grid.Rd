% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom-grid.R
\name{geom_grid}
\alias{geom_grid}
\alias{add_grid}
\title{Add panel grid line on correlation plot}
\usage{
geom_grid(data = NULL, colour = "grey50", size = 0.25, ...,
  color = NULL)

add_grid(...)
}
\arguments{
\item{data}{NULL (default) or a cor_tbl object.}

\item{colour, color}{colour of grid lines.}

\item{size}{size of grid lines.}

\item{...}{extra params for \code{\link[ggplot2]{geom_segment}}.}
}
\description{
\code{geom_grid} is mainly used with \code{ggcor} or \code{quickcor}
    function to add a panel grid line on plot region.
}
\examples{
df <- fortify_cor(mtcars)
ggcor(df) + geom_grid()
require(ggplot2, quietly = TRUE)
ggplot(df, aes(x, y)) + geom_grid()
}
\author{
Houyun Huang, Lei Zhou, Jian Chen, Taiyun Wei
}
