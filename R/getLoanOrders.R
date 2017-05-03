#' Get lending data
#'
#' This function returns the loan orders for a given symbol in the form of a data.frame
#' @param .symbol Symbol
#' @param .limit Limit
#' @keywords LoanOrders
#' @export
#' @examples
#' getLoanOrders()
getLoanOrders <- function(.symbol = "BTC", .limit = 10000) {
  loans <- httr::content(httr::GET(paste0("https://poloniex.com/public?command=returnLoanOrders&currency=", .symbol, "&limit=", .limit)))  # Note: Poloniex's API documentation doesn't mention a limit parameter, but this works hmm... -_-
  if (length(loans$demands) > 0) {
      loanBook <- lapply(loans[c("offers", "demands")], function(x) {
          matrix(unlist(x), ncol = 4, byrow = T)
      })  # Named list of length 2: offers, demands
      lbSums <- lapply(loanBook[c("offers", "demands")], function(x) {
          data.frame(x, cumulativeSum = cumsum(x[, 2]))
      })
      lbSums$offers$side <- rep("Offers", nrow(lbSums$offers))  # Add side label
      lbSums$demands$side <- rep("Demands", nrow(lbSums$demands))
      stack <- rbind(lbSums$demands[order(as.numeric(lbSums$demands[, 1])), ], lbSums$offers)  # Again, note the explicit sort order.
  } else {
      # Deal with case when there are no loan demands
      loanOffers <- matrix(unlist(loans$offers), ncol = 4, byrow = T)
      stack <- data.frame(loanOffers, cumulativeSum = cumsum(loanOffers[, 2]), side = rep("Offers", nrow(loanOffers)))
  }
  names(stack)[1:4] <- c("rate", "amount", "rangeMin", "rangeMax")
  cat(paste0(Sys.time(), " ", .symbol, " Lending Book updated.\n\n"))
  return(stack)
}
