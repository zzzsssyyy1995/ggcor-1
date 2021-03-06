
# ggcor

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `ggcor` is to to provide a set of functions that be used to
visualize simply and directly a correlation matrix based on ‘ggplot2’.

## Installation

Now `ggcor` is not on cran, You can install the development version of
ggcor from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("houyunhuang/ggcor")
```

## Draw correlation plot quickly

This is a basic example which shows you how to draw correlation plot
quickly:

``` r
library(ggplot2)
library(ggcor)
quickcor(mtcars) + geom_colour()
```

<img src="man/figures/README-example01-1.png" width="100%" />

``` r
quickcor(mtcars, type = "upper") + geom_circle2()
```

<img src="man/figures/README-example01-2.png" width="100%" />

``` r
quickcor(mtcars, cor.test = TRUE) +
  geom_square(data = get_data(type = "lower", show.diag = FALSE)) +
  geom_mark(data = get_data(type = "upper", show.diag = FALSE), size = 2.5) +
  geom_abline(slope = -1, intercept = 12)
```

<img src="man/figures/README-example01-3.png" width="100%" />

## Mantel test plot

``` r
library(vegan)
library(dplyr)
data("varechem")
data("varespec")
set.seed(20191224)
sam_grp <- sample(paste0("sample", 1:3), 24, replace = TRUE)
mantel01 <- fortify_mantel(varespec, varechem, group = sam_grp,
                           spec.select = list(spec01 = 1:5, 
                                              spec02 = 6:12,
                                              spec03 = 7:18,
                                              spec04 = 20:29,
                                              spec05 = 30:44),
                           mantel.fun = "mantel.randtest")
quickcor(mantel01, legend.title = "Mantel's r") + 
  geom_colour() + geom_cross() + facet_grid(rows = vars(.group))
```

<img src="man/figures/README-example03-1.png" width="100%" />

``` r
mantel02 <- fortify_mantel(varespec, varechem, 
                         spec.select = list(1:10, 5:14, 7:22, 9:32)) %>% 
  mutate(r = cut(r, breaks = c(-Inf, 0.25, 0.5, Inf), 
                 labels = c("<0.25", "0.25-0.5", ">=0.5"),
                 right = FALSE),
         p.value = cut(p.value, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                       labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">=0.05"),
                       right = FALSE))
quickcor(varechem, type = "upper") + geom_square() + 
  add_link(mantel02, mapping = aes(colour = p.value, size = r),
           diag.label = TRUE) +
  scale_size_manual(values = c(0.5, 1.5, 3)) +
  add_diag_label() + remove_axis("x")
#> Warning: `add_diag_label()` is deprecated. Use `geom_diag_label()` instead.
```

<img src="man/figures/README-example03-2.png" width="100%" />

# network

``` r
library(tidygraph)
library(ggraph)
net <- fast_correlate(varespec) %>% 
  as_tbl_graph(r.thres = 0.5, p.thres = 0.05) %>% 
  mutate(degree = tidygraph::centrality_degree(mode = "all"))

ggraph(net, "circle") + 
  geom_edge_fan(aes(edge_width = r, edge_linetype = r < 0), 
                edge_colour = "grey80", show.legend = FALSE) +
  geom_node_point(aes(size = degree, colour = name), 
                  show.legend = FALSE) +
  geom_node_text(aes(x = x * 1.08, y = y * 1.08, 
                     angle = -((-node_angle(x, y) + 90) %% 180) + 90, 
                     label = name), size = 4, hjust= "outward",
                 show.legend = FALSE)  +
  scale_edge_color_gradientn(colours = c("blue", "red")) +
  scale_edge_width_continuous(range = c(0.1, 1)) +
  coord_fixed(xlim = c(-1.5, 1.5), ylim = c(-1.5, 1.5)) +
  theme_graph()
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

# general heatmap

``` r
mat <- matrix(rnorm(120), nrow = 15)
cor_tbl(extra.mat = list(mat = mat)) %>% 
  quickcor(mapping = aes(fill = mat)) + geom_colour()
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

# upper and lower with different geom

``` r
d <- dist(t(mtcars))
correlate(mtcars, cor.test = TRUE) %>% 
  as_cor_tbl(extra.mat = list(dist = d)) %>% 
  quickcor() +
  geom_upper_square(aes(upper_fill = r, upper_r0 = r)) +
  geom_lower_colour(aes(lower_fill = dist)) +
  geom_diag_label() +
  remove_all_axis()
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
