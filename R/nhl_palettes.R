
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
#'
#' # get only the named hex codes
#' nhl_palettes(name = "Avs", active = TRUE)$palette_hex[[1]]
#'
#' # You can plot the palettes to see the colors with ease:
#' plot(nhl_palettes(name = "Avs"))
#' plot(nhl_palettes(name = "Avs", active = TRUE))
#' plot(nhl_palettes(name = "Avs", active = FALSE))
#'
#' @export
nhl_palettes <- function(name = NULL, active = NULL) {
  p <- .zpalettes$nhl_palettes

  if (!is.null(active)) {
    if (active) {
      p <- subset(p, p$active == 1)
    } else {
      p <- subset(p, p$active == 0)
    }
  }

  if (!is.null(name)) {
    p <- p[agrep(name, p$name), ]
  }

  class(p) <- c("zpalettes_nhl_palettes", "zpalettes", class(p))
  p
}

#' @export
plot.zpalettes_nhl_palettes <- function(x, ...) {

  nms <- x$name
  introduced <- as.character(x$introduced)
  retired    <- as.character(x$retired)
  introduced[is.na(introduced)] <- ""
  retired[is.na(retired)] <- ""
  palettes <- x$palette_hex

  old.opts <- graphics::par(no.readonly = TRUE)

  graphics::par(mfrow = c(ceiling(sqrt(nrow(x))), floor(sqrt(nrow(x)))))

  for (p in seq_along(nms)) {
    columns <- floor(sqrt(length(palettes[[p]])))
    rows    <- ceiling(sqrt(length(palettes[[p]])))

    plot(c(0,rows), c(0,columns), type = "n", axes = FALSE, xaxt = "n", yaxt = "n", ann = FALSE)
    graphics::title(main = paste0(nms[p], "\n", paste(introduced[p], retired[p], sep = " - ")))
    this <- 1
    for (j in seq(1, columns, by = 1) ) {
      for(i in seq(1, rows, by = 1)) {
        graphics::rect(xleft = i - 1, ybottom = j - 1, xright = i, ytop = j, col = palettes[[p]][[this]])
        if (this < length(palettes[[p]])) {
          this <- this + 1
        } else {
          break
        }
      }
    }
  }

  on.exit(graphics::par(old.opts))
  invisible()
}


