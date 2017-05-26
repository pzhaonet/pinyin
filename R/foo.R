#' Concert Chinese characters into Pinyin.
#'
#' @param mychar character. A Chinese character or string to convert to pinyin
#' @param method character. The value can be:
#' - 'quanpin', when '汉字' is to be converted to 'hàn zì',
#' - 'tone', when '汉字' is to be converted to han4 zi4,
#' - 'toneless', when '汉字' is to be converted to 'han zi'
#' @param sep character. Seperation between the converted pinyin.
#' @param nonezh_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param only_first_letter logical. Wheter only the first letter in pinyin.
#'
#' @return pinyin of the given Chinese character.
#' @export
#' @examples zh2py()
zh2py <- function(mychar, method = c('quanpin', 'tone', 'toneless')[1], sep = '_', nonezh_replace = NULL, only_first_letter = FALSE) {
  py <- pylib(method = method, first = TRUE, only_first_letter)
  mycharsingle <- strsplit(mychar, split = '')[[1]]
  myreplace <- function(x) {
    if (sum(x == zh) == 0) ifelse(is.null(nonezh_replace), x, nonezh_replace) else py[x == zh]
  }
  zh2py <- paste(sapply(mycharsingle, myreplace), collapse = sep)
  return(zh2py)
}


#############################################################
#' A Pinyin library
#'
#' @param method character. The value can be:
#' - 'quanpin', when '汉字' is to be converted to 'hàn zì',
#' - 'tone', when '汉字' is to be converted to han4 zi4,
#' - 'toneless', when '汉字' is to be converted to 'han zi'
#' @param first logical. Whether only display the first pronounciation of multiple pronounciations of a Chinese character.
#' @param only_first_letter logical. Wheter only the first letter in pinyin.
#'
#' @return a Pinyin library.
#' @export
#'
#' @examples pylib()
#' pylib(first = FALSE)
pylib <- function(method = c('quanpin', 'tone', 'toneless')[1], first = TRUE, only_first_letter = FALSE) {
  mystrsplit <- function(x) strsplit(x, split = ' ')[[1]][1]
  lib <- readLines(paste0(.libPaths(), '/pinyin/lib/zh.txt'), encoding = 'UTF-8', skip = 48) # read source file
  lib <- lib[49:length(lib)] # skip lines
  lib <- lib[-grep('^#', lib)] # remove headers
  lib <- lib[-which(nchar(lib) == 0)] # remove blank lines
  zh <- substr(lib, 1, 1) # chinese char
  bracketloc <- regexpr('\\(', lib)
  if (first) {
    pylib <-  switch( # extract the first pinyin if multiple
      method,
      quanpin = sapply(substr(lib, 3, bracketloc - 1), mystrsplit),
      tone = sapply(substr(lib, bracketloc + 1, nchar(lib) - 1), mystrsplit),
      toneless = gsub('[1-4]', '', sapply(substr(lib, bracketloc + 1, nchar(lib) - 1), mystrsplit))
    )
  } else {
    pylib <-  switch( # extract all pinyins
      method,
      quanpin = substr(lib, 3, bracketloc - 1),
      tone = substr(lib, bracketloc + 1, nchar(lib) - 1),
      toneless = gsub('[1-4]', '', substr(lib, bracketloc + 1, nchar(lib) - 1))
    )
  }
  if (only_first_letter) pylib <- substr(pylib, 1, 1)
  return(pylib)
}


#############################################################
#' Renames files with Chinese characters to pinyin
#'
#' @param mydir character. The folder in which the files are to be renamed.
#'
#' @return files with new names.
#' @export
#'
#' @examples file.rename2py()
file.rename2py <- function(mydir = '/') {
  oldname <- dir(mydir, full.names = TRUE)
  newname <- paste(mydir, sapply(dir(mydir), zh2py, method = 'toneless', sep = '', nonezh_replace = NULL, only_first_letter = TRUE), sep = '/')
  file.rename(oldname, newname)
}

#############################################################
#' Convert the Chinese headers of bookdown .Rmd files into Pinyin
#'
#' @param folder character. The folder in which the files are to be converted.
#' @param remove_curly_bracket logical. Whether to remove existing curly brackets in the headers.
#'
#' @return new .Rmd files with Pinyin headers.
#' @export
#'
#' @examples bookdown2py()
bookdown2py <- function(folder = 'mm', remove_curly_bracket = TRUE) {
  for (filename in dir(folder, full.names = TRUE)) {
    # filename <- dir(folder, full.names = TRUE)[1]
    file.copy(filename, to = paste0(filename, 'backup'))
    md <- readLines(filename, encoding = 'UTF-8')
    headerloc <- grep('^#+', md)
    codeloc <- grep('^```', md)
    # exclude the lines begining with # but in code
    if (length(codeloc) > 0) headerloc <- headerloc[!sapply(headerloc, function(x) sum(x > codeloc[seq(1, length(codeloc), by = 2)] & x < codeloc[seq(2, length(codeloc), by = 2)])) == 1]
    if (remove_curly_bracket) md[headerloc] <- gsub(pattern = '\\{.*\\}', '', md[headerloc])
    for (i in headerloc){
      headerpy <- zh2py(mychar = sub('^#* ', '', md[headerloc]), method = 'toneless', sep = '', nonezh_replace = '', only_first_letter = TRUE)
      md[headerloc] <- paste(md[headerloc], ' {#', headerpy, '}', sep = '')
    }
    writeLines(text = md, filename, useBytes = TRUE)
  }
}
