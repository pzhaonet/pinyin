#' Convert strings of Chinese characters into Pinyin.
#'
#' @param char *Requrired* A input character string with chinese characters.
#' @param sep character. The seperator between the converted pinyin. Default: '_'
#' @param other_replace. The replacement for non-Chinese characters
#' @param dic The preloaded dictionary for conversion. Default: "pinyin::pinyin2"
#' @param other_replace
#'
#' @return A character vector of the converted pinyin string.
#' @export
#'
#' @examples py("hello word")
#'
as.pinyin <- function(char,
                      sep = '_',
                      other_replace = NULL,
                      dic = pinyin::pinyin2) {
  sapply(char,
         chn2py,
         other_replace = NULL,
         sep = sep,
         dic = dic)
}

chn2py = function(char = '',
                  sep = '_',
                  other_replace = NULL,
                  dic) {
  mycharsingle = strsplit(char, split = '')[[1]]
  mymaches = dic$value[match(mycharsingle, dic$key)]
  converted = paste0(sep, mymaches)
  converted[is.na(mymaches)] = mycharsingle[is.na(mymaches)]

  if(!is.null(other_replace)) {
    converted[is.na(mymaches)] = other_replace
  }
  else{
    converted[is.na(mymaches)] = mycharsingle[is.na(mymaches)]
  }

  converted = paste0(converted, collapse = "")

  return(converted)
}


