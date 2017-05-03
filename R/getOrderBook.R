#' Get order book
#'
#' This function returns the order book for a given pair in the form of a data.frame
#' @param .symbol1 Symbol 1
#' @param .symbol2 Symbol 2
#' @param .depth Depth
#' @keywords OrderBook
#' @export
#' @examples
#' getOrderBook()
getOrderBook <- function(.symbol1 = "BTC", .symbol2 = "ETH", .depth = 5000) {
  .pair <- paste0(.symbol2, .symbol1)
  .url <- paste0("https://poloniex.com/public?command=returnOrderBook&currencyPair=", .symbol1, "_", .symbol2, "&depth=", .depth)
  orderBook <- lapply(httr::content(httr::GET(.url))[c("asks", "bids")], function(x) {
      matrix(unlist(x), ncol = 2, byrow = T)
  })  # Named list of length 4: asks, bids, isFrozen, seq
  obSums <- lapply(orderBook[c("asks", "bids")], function(x) {
      data.frame(x, cumsum(x[, 2]), as.numeric(as.character(x[, 1])) * as.numeric(as.character(x[, 2])), cumsum(as.numeric(as.character(x[, 1])) * as.numeric(as.character(x[, 2]))))
  })  # Add cumulative sums; see: http://stackoverflow.com/questions/3418128/how-to-convert-a-factor-to-an-integer-numeric-without-a-loss-of-information
  obSums$asks$side <- rep("Ask", nrow(obSums$asks))  # Add side label
  obSums$bids$side <- rep("Bid", nrow(obSums$bids))
  stack <- rbind(obSums$bids[order(as.numeric(obSums$bids[, 1])), ], obSums$asks)  # Note the explicit ordering.
  names(stack)[1:5] <- c("price", paste0("amount", .symbol2), paste0("cumulativeSum", .symbol2), paste0("amount", .symbol1), paste0("cumulativeSum", .symbol1))
  cat(paste0(Sys.time(), " ", .pair, " Order Book updated.\n\n"))
  return(stack)
}
