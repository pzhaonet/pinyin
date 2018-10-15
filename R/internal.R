#' Title insert a character(s) before all lattin letters in a string
#'
#' @param oldchar the old string
#' @param insertchar the character(s) to insert
#'
#' @return a new string
insert <- function(oldchar, insertchar = ','){
  seploc <- min(gregexpr('[a-z]+', oldchar)[[1]])
  paste(substr(oldchar, 1, seploc - 1), substr(oldchar, seploc, nchar(oldchar)), sep = insertchar)
  }


#' split a string and extract the *n*th string
#'
#' @param x The string to split
#' @param sep The separated character
#' @param nth The *n*th string to extract
#'
#' @return a new string
strsplit2 <- function(x, sep = ' ', nth = 1) {
  y <- strsplit(x, split = sep)[[1]]
  return(ifelse(length(y) >= nth, y[nth], NA))
}
