# Read the renv.lock file and use {pak} to determine which system dependencies 
# Docker needs to install before installing R packages

if (!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(
  "dockerfiler",
  "renv",
  "pak",
  "here",
  install = TRUE
)

renv_file <- here::here("why-donors-donate/renv.lock")

# This takes a while...
dock <- dockerfiler::dock_from_renv(
  renv_file,
  FROM = "rocker/tidyverse", AS = "renv-base",
  repos = c(
    CRAN = "https://cran.rstudio.com/",
    Stan = "https://mc-stan.org/r-packages"
  ),
  use_pak = TRUE
)
dock
