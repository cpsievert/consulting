# Credit to https://fronkonstin.com/2017/11/07/drawing-10-million-points-with-ggplot-clifford-attractors/
library(Rcpp)
library(plotly)
library(dplyr)

cppFunction(
'DataFrame createTrajectory(int n, double x0, double y0, double a, double b, double c, double d) {
  // create the columns
  NumericVector x(n);
  NumericVector y(n);
  x[0] = x0;
  y[0] = y0;
  for(int i = 1; i < n; ++i) {
    x[i] = sin(a*y[i-1])+c*cos(a*x[i-1]);
    y[i] = sin(b*x[i-1])+d*cos(b*y[i-1]);
  }
  // return a new data frame
  return DataFrame::create(_["x"]= x, _["y"]= y);
}'
)


# number of frames in the animation
# TODO: play with different ending parameter values
nsteps <- 30
a <- seq(-1.1, -1.24458046630025, length.out = nsteps)
b <- seq(-1.1, -1.25191834103316, length.out = nsteps)
c <- seq(-1.7, -1.81590817030519, length.out = nsteps)
d <- seq(-1.8, -1.90866735205054, length.out = nsteps)

# number of points to draw
npoints <- 1000000
ds <- lapply(seq_len(nsteps), function(i) {
  cbind(createTrajectory(npoints, 0, 0, a[i], b[i], c[i], d[i]), id = seq_len(npoints), step = i)
})
d <- dplyr::bind_rows(ds)

# blank axis
ax <- list(
  title = "",
  showticklabels = FALSE,
  showgrid = FALSE,
  zeroline = FALSE
)

plot_ly(
  d, x = ~x, y = ~y, frame = ~step, ids = ~id,
  type = "scattergl", mode = "markers",
  marker = list(size = 0.7, color = I("white"))
) %>%
  layout(
    plot_bgcolor = "black",
    xaxis = c(ax, list(scaleanchor = "y")),
    yaxis = ax
  ) %>%
  animation_opts(33, redraw = FALSE, easing = "cubic")
