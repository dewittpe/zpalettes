files <- list.files(normalizePath("./data-raw"), pattern = "*\\.json", full.names = TRUE)
names(files) <- sub("\\.json", "", basename(files))
.zpalettes <- lapply(files, jsonlite::fromJSON)
for( i in seq_along(.zpalettes)) {
  rownames(.zpalettes[[i]]) <- NULL
}
save(.zpalettes, file = "./R/sysdata.rda")



#nhl_palettes <- jsonlite::read_json("./data-raw/nhl_palettes.json")
#nhl_palettes <- jsonlite::fromJSON("./data-raw/nhl_palettes.json")
#
#rownames(nhl_palettes) <- NULL
#
#nhl_palettes |>
#  subset(name == "Colorado Avalanche") |>
#  subset(active == 1) |>
#  getElement("palette_hex") |>
#  getElement(1)
#
