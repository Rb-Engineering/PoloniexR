# PoloniexR

This is an R package which wraps a few of the public API methods for Poloniex.

## Installation

1. If you haven't already, install `devtools` from CRAN with `install.packages("devtools")`.
2. Install `PoloniexR` with:
```r
devtools::install_github("Rb-Engineering/PoloniexR")
```

## Basic use

Here's a quick gist to get you started:

```r
library(PoloniexR)

# First, let's get some OHLCV (Open-High-Low-Close-Volume) data:
getOHLCV('BTC', 'ETH', 1800, 1483228800)  # args(getOHLCV)
getOHLCV('ETH', 'GNT', 1800, 1488326400)

# The getOHLCV() function stores a data.frame named after the inputted pair in the .ohlc environment:
ls(.ohlc)
# [1] "ETHBTC" "GNTETH"

tail(.ohlc$ETHBTC, 10)  # Returns:

#                     date       high        low       open      close    volume quoteVolume weightedAverage
# 5882 2017-05-03 05:30:00 0.05299030 0.05281839 0.05290112 0.05287978  284.7604    5384.073      0.05288939
# 5883 2017-05-03 06:00:00 0.05329995 0.05281800 0.05286224 0.05320999  656.4557   12377.530      0.05303608
# 5884 2017-05-03 06:30:00 0.05340570 0.05300029 0.05320000 0.05323603  837.1148   15716.126      0.05326470
# 5885 2017-05-03 07:00:00 0.05421000 0.05324995 0.05324996 0.05417200  841.0405   15654.357      0.05372564
# 5886 2017-05-03 07:30:00 0.05460623 0.05411992 0.05417000 0.05435000 1369.3285   25195.319      0.05434852
# 5887 2017-05-03 08:00:00 0.05437000 0.05368025 0.05432700 0.05422497 1007.7421   18653.944      0.05402300
# 5888 2017-05-03 08:30:00 0.05459991 0.05413610 0.05422497 0.05431603  863.9467   15887.373      0.05437945
# 5889 2017-05-03 09:00:00 0.05445497 0.05381655 0.05435310 0.05383000  700.4407   12917.184      0.05422549
# 5890 2017-05-03 09:30:00 0.05405300 0.05300000 0.05383004 0.05317000 1340.3158   25067.603      0.05346804
# 5891 2017-05-03 10:00:00 0.05380000 0.05291016 0.05317000 0.05291016  835.5071   15643.530      0.05340911

# If you want to save this data locally, simply do:
write.csv(.ohlc$ETHBTC, './ETHBTC_OHLCV.csv', row.names = F)

# Next, let's get a snapshot of the order book:
ob <- getOrderBook('BTC', 'ETH', 2500)  # args(getOrderBook)
head(ob)  # Returns:

#           price   amountETH cumulativeSumETH    amountBTC cumulativeSumBTC side
# 2500 0.04271000   0.2995655         72660.64 0.0127944425         3526.306  Bid
# 2499 0.04272704    0.832633         72660.34 0.0355759435         3526.293  Bid
# 2498 0.04273000  0.30180851         72659.50 0.0128962776         3526.258  Bid
# 2497 0.04273694  0.00852939         72659.20 0.0003645200         3526.245  Bid
# 2496 0.04274000 11.69864295         72659.19 0.4999999997         3526.244  Bid
# 2495 0.04274185  0.00465597         72647.49 0.0001990048         3525.744  Bid

tail(ob)  # Returns:

#           price   amountETH cumulativeSumETH    amountBTC cumulativeSumBTC side
# 4995 0.06089553       0.019         44831.79 0.0011570151         2552.806  Ask
# 4996 0.06089554      0.0095         44831.80 0.0005785076         2552.806  Ask
# 4997 0.06089560      0.0095         44831.80 0.0005785082         2552.807  Ask
# 4998 0.06089605      0.0095         44831.81 0.0005785125         2552.807  Ask
# 4999 0.06089883 16.69481691         44848.51 1.0166948169         2553.824  Ask
# 5000 0.06089990  0.02759121         44848.54 0.0016803019         2553.826  Ask

# Finally, let's get the loan book:
lb <- getLoanOrders('BTC')

head(lb)

#          rate      amount rangeMin rangeMax cumulativeSum    side
# 21 0.00001000  0.13045184        2        2      154.2223 Demands
# 20 0.00002000 17.14751050        2        2      154.0919 Demands
# 19 0.00005000  0.20350337        2        2      136.9444 Demands
# 18 0.00010000  2.17086262        2        2      136.7409 Demands
# 17 0.00012000  0.10603728        2        2      134.5700 Demands
# 16 0.00015000  0.13000000        2        2      134.4640 Demands

tail(lb)

#            rate     amount rangeMin rangeMax cumulativeSum   side
# 1329 0.04010899 0.04109978        7        7      4871.436 Offers
# 1330 0.04500000 0.20000000       60       60      4871.636 Offers
# 1331 0.04933900 0.01000000       60       60      4871.646 Offers
# 1332 0.04998300 0.01000000       60       60      4871.656 Offers
# 1333 0.04999500 0.15000000       60       60      4871.806 Offers
# 1334 0.05000000 2.91480218        2       60      4874.721 Offers
```

## Additional resources

* [Poloniex API documentation](https://poloniex.com/support/api/)
* [R packages for finance](https://cran.r-project.org/web/views/Finance.html)
* [/r/EthTrader](https://www.reddit.com/r/ethtrader)
* [/r/BitcoinMarkets](https://www.reddit.com/r/bitcoinmarkets)

License
----

MIT