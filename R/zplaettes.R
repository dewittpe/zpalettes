#' Zealot Palettes
#'
#' Quick access to color palettes of professional sports clubs,
#' University/Colleges, movies, etc.
#'
#'
#' @examples
#' 
#' # get a list of the available palettes
#' zpalettes()
#'
#' @export
zpalettes <- function() {
  summary(.zpalettes)
}

#' NHL Palettes
#'
#' Active and retired color palettes for current and former teams of the
#' National Hockey League.
#' 
#'
#' @param name character string to (fuzzy) match to the team names. If
#' \code{NULL} (default) all teams are returned.
#' @param active if \code{TRUE} return only active color palettes, if
#' \code{FALSE} then return only retired color palettess.  If \code{NULL}
#' (default) return both active and retired color palettes.
#' @param hex_only If \code{TRUE} and the combination of \code{name} and
#' \code{active} return only one match then return a named character vector for
#' the color palette hex codes.  Otherwise, return a \code{data.frame}.
#'
#' @examples
#'
#' # All NHL palettes:
#' nhl_palettes()
#'
#' # Return all active palettes
#' nhl_palettes(active = TRUE)
#'
#' # Get the palettes for the Colorado Avalanche
#' nhl_palettes(name = "Colorado Avalanche")  # Using Full Team Name
#' nhl_palettes(name = "Avs")                 # Using fuzzy matching
#'
#' # Get the active palette for the Colorado Avalanche
#' nhl_palettes(name = "Avs", active = TRUE)
#' nhl_palettes(name = "Avs", active = TRUE, hex_only = FALSE)
#'
#' @export
nhl_palettes <- function(name = NULL, active = NULL, hex_only = TRUE) {
  p <- .zpalettes$nhl_palettes

  if (!is.null(active)) {
    p <- subset(p, p$active == 1, drop = TRUE)
  }

  if (!is.null(name)) {
    p <- p[agrep(name, p$name), ]
  }

  if (nrow(p) == 1L & hex_only) {
    p <- p$palette_hex[[1]]
  }

  p
}
