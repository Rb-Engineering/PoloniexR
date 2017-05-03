#' Get OHLCV data
#'
#' This function returns Open-High-Low-Close-Volume data for a given pair.
#' @param .symbol1 Symbol 1
#' @param .symbol2 Symbol 2
#' @param .period Time-series data interval in seconds; default 30 minutes
#' @param .start Unix start time to be passed into API call; default 1483228800
#' @param .end Unix end time; default 9999999999
#' @keywords OHLCV
#' @export
#' @examples
#' getOHLCV()
getOHLCV <- function(.symbol1 = "BTC", .symbol2 = "ETH", .period = 1800, .start = 1483228800, .end = 9999999999) {
  if (!exists('.ohlc')) .ohlc <<- new.env()  # Initialize separate environment to store data
  .pair <- paste0(.symbol2, .symbol1)
  if (!exists(.pair, envir = .ohlc)) {
      .url <- paste0("https://poloniex.com/public?command=returnChartData&currencyPair=", .symbol1, "_", .symbol2, "&start=", .start, "&end=", .end, "&period=", .period)
      .ohlcv <- plyr::ldply(httr::content(httr::GET(.url)), data.frame)  # Get OHLCV data via 'returnChartData' API call
      .ohlcv$date <- as.POSIXct(.ohlcv$date, origin = "1970-01-01")  # is.OHLCV(.ohlcv)
      assign(x = .pair, value = .ohlcv, envir = .ohlc)
      cat(paste0(Sys.time(), " ", .pair, " Poloniex OHLCV data downloaded.\n\n"))
      return(.ohlcv)
  } else {
      .existing <- utils::head(get(.pair, envir = .ohlc), -1)
      .url <- paste0("https://poloniex.com/public?command=returnChartData&currencyPair=", .symbol1, "_", .symbol2, "&start=", as.integer(max(.existing$date)), "&end=", .end, "&period=", .period)
      .diff <- plyr::ldply(httr::content(httr::GET(.url)), data.frame)
      .diff$date <- as.POSIXct(.diff$date, origin = "1970-01-01")
      .ohlcv <- rbind(.existing, .diff)
      assign(x = .pair, value = .ohlcv, envir = .ohlc)
      cat(paste0(Sys.time(), " ", .pair, " Poloniex OHLCV data updated.\n\n"))
      return(.ohlcv)
  }
}