#' Convert strings of Chinese characters into Pinyin.
#'
#' @param char a string vector
#' @param sep character. Seperation between the converted pinyin.
#' @param other_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param dic the preloaded pinyin library using the `pylib()` function.
#' 
#' @return pinyin of the given Chinese string.
#' @export
#'
#' @examples py(dic = NA)
py <- function(char = '',
               sep = '_',
               other_replace = NULL,
               dic = pinyin::pinyin2) {
  sapply(char, py_single, sep = sep, other_replace = other_replace, dic = dic)
}

#' Convert a string of Chinese characters into Pinyin.
#'
#' @param char character. A Chinese character or string to convert to pinyin
#' @param sep character. Seperation between the converted pinyin.
#' @param other_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param dic the preloaded pinyin library using the `pylib()` function.
#'
#' @return pinyin of the given Chinese string.
#' @importFrom stats setNames

py_single <- function(char = '',
                       sep = '_',
                       other_replace = NULL,
                       dic = pinyin::pinyin2) {
  mycharsingle <- strsplit(char, split = '')[[1]]
  
  mymaches = dic$value[match(mycharsingle, dic$key)]
  converted = paste0(sep,mymaches)
  
  if(!is.null(other_replace)) converted[is.na(mymaches)] = other_replace
  else converted[is.na(mymaches)] = mycharsingle[is.na(mymaches)]

  converted = paste0(converted, collapse="")

  return(converted)
}
