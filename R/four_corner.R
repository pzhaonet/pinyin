#' A Four-corner library
#'
#' @return A Four-Corner library
#' @importFrom splitstackshape cSplit
#' @importFrom data.table as.data.table
#' @export
#'
#' @examples fclib()
fclib <- function() {
  mypath <- paste0(.libPaths(), '/pinyin/lib/four_corner.txt')
  lib <- readLines(mypath[file.exists(mypath)][1], encoding = 'UTF-8')
  lib <- lib[nchar(lib)!= 0]
  lib <- splitstackshape::cSplit(data.table::as.data.table(lib), "lib", " ")
  colnames(lib) <- c("Code","Chars")
  lib$Chars <- as.character(lib$Chars)
  n.char <- sapply(lib$Chars, nchar)
  FCcode <- rep(lib$Code, n.char)
  FCchar <- unlist(sapply(lib$Chars, strsplit,""))
  environment_FC <- list2env(setNames(as.list(FCcode), FCchar))
  return(environment_FC)
}

#' Get the four-corner code of a string
#'
#' @param mychar character. A Chinese character or string to convert to four-corner codes.
#' @param sep character. Seperation between the converted four-corner codes.
#' @param nonezh_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param fc A four-corner library
#'
#' @return the four-corner codes
#' @export
#'
#' @examples four_corner()
four_corner <- function(mychar = "",  sep = "_",  nonezh_replace = NULL, fc = fclib()){
  mycharsingle <- strsplit(mychar, split = "")[[1]]
  myreplace <- function(x) {
    if (is.null(fc[[x]]))
      ifelse(is.null(nonezh_replace), x, nonezh_replace)
    else fc[[x]]
  }
  FC <- paste(sapply(mycharsingle, myreplace), collapse = sep)
  return(FC)
}
