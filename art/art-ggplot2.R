# Credit to https://fronkonstin.com/2017/11/07/drawing-10-million-points-with-ggplot-clifford-attractors/
library(Rcpp)
library(ggplot2)
library(tweenr)
library(gganimate)
library(dplyr)

cppFunction(
  'DataFrame createTrajectory(int n, double x0, double y0, double a, double b, double c, double d) {
  // create the columns
  NumericVector x(n);
  NumericVector y(n);
  x[0] = x0;
  y[0] = y0;
  for(int i = 1; i < n; ++i) {
    x[i] = sin(a * y[i-1]) + c * cos(a * x[i-1]);
    y[i] = sin(b * x[i-1]) + d * cos(b * y[i-1]);
  }
  // return a new data frame
  return DataFrame::create(_["x"] = x, _["y"] = y);
  }'
)




nsteps <- 3 # number of frames in the animation
npoints <- 1e6 # number of points to draw

# TODO: play with different ending parameter values
d1 <- createTrajectory(
  npoints, 0, 0, -1.1, -1.2, -1.5, -1.6
)




ds <- lapply(seq_len(nsteps), function(i) {
  cbind(createTrajectory(npoints, 0, 0, a[i], b[i], c[i], d[i]), id = seq_len(npoints), step = i)
})
d <- dplyr::bind_rows(ds)

p <- ggplot(d, aes(x, y, frame = step)) +
  geom_point(color="black", shape=46, alpha=0.1) +
  theme(
    legend.position  = "none",
    panel.background = element_rect(fill="white"),
    axis.ticks       = element_blank(),
    panel.grid       = element_blank(),
    axis.title       = element_blank(),
    axis.text        = element_blank()
  )
animation::ani.options(interval = 1)
gganimate(p, "parrondo.gif", title_frame = F, ani.width = 400,
          ani.height = 400)














library(ggplot2)

d <- data.frame(
  x = 0.5,
  y = 0.5,
  txt = "  Data driven \n development"
)
p <- ggplot(d, aes(x, y, label = txt)) +
  geom_text(size = 30, family = "Roboto Condensed") +
  theme_void()

# https://en.wikipedia.org/wiki/Display_resolution#Computer_monitors
tmp <- tempfile()
Cairo::CairoPNG(file = tmp, width = 1024, height = 768, dpi = 72 * 4)
print(p)
dev.off()
img <- magick::image_read(tmp)
r <- as.raster(img)
grid <- expand.grid(rev(seq_len(nrow(r))), seq_len(ncol(r)))
grid <- setNames(as.data.frame(grid), c("y", "x"))
grid$color <- c(r)

ggplot(grid, aes(x, y, color = color)) +
  geom_point(shape = 46) +
  scale_color_identity() +
  theme_void()
