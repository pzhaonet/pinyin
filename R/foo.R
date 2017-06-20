#' Convert Chinese characters into Pinyin.
#'
#' @param mychar character. A Chinese character or string to convert to pinyin
#' @param method character. The value can be:
#' - 'quanpin', for the standard form of pinyin (tones above letters),
#' - 'tone', for tones expressed with numbers,
#' - 'toneless', without tones
#' @param sep character. Seperation between the converted pinyin.
#' @param nonezh_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param multi logical. Whether display multiple pronounciations of a Chinese character or only the first pronounciation.
#' @param only_first_letter logical. Wheter only the first letter in pinyin.
#'
#' @return pinyin of the given Chinese character.
#' @export
#' @examples pinyin()
pinyin <- function(mychar = '', method = c('quanpin', 'tone', 'toneless'), sep = '_', nonezh_replace = NULL, multi = FALSE, only_first_letter = FALSE) {
  method <- match.arg(method)
  py <- pylib(method = method, multi = multi, only_first_letter = only_first_letter)
  zh <- names(py)
  mycharsingle <- strsplit(mychar, split = '')[[1]]
  myreplace <- function(x) {
    if (sum(x == zh) == 0) ifelse(is.null(nonezh_replace), x, nonezh_replace) else py[x == zh]
  }
  pinyin <- paste(sapply(mycharsingle, myreplace), collapse = sep)
  return(pinyin)
}

#############################################################
#' A Pinyin library
#'
#' @param method character. The value can be:
#' - 'quanpin', for the standard form of pinyin (tones above letters),
#' - 'tone', for tones expressed with numbers,
#' - 'toneless', without tones
#' @param multi logical. Whether display multiple pronounciations of a Chinese character or only the first pronounciation.
#' @param only_first_letter logical. Wheter only the first letter in pinyin.
#'
#' @return character. a Pinyin library.
#' @export
#' @examples pylib()
pylib <- function(method = c('quanpin', 'tone', 'toneless'), multi = FALSE, only_first_letter = FALSE) {
  method <- match.arg(method)
  mystrsplit <- function(x) strsplit(x, split = ' ')[[1]][1]
  mypath <- paste0(.libPaths(), '/pinyin/lib/zh.txt')
  lib <- readLines(mypath[file.exists(mypath)][1], encoding = 'UTF-8') # read source file.   # for ubuntu users
  lib <- lib[49:length(lib)] # skip lines
  lib <- lib[-grep('^#', lib)] # remove headers
  lib <- lib[-which(nchar(lib) == 0)] # remove blank lines
  zh <- substr(lib, 1, 1) # chinese char
  bracketloc <- regexpr('\\(', lib)
  if (multi) {
    qp <- substr(lib, 3, bracketloc - 1)
    pylib <-  switch( # extract all pinyins
      method,
      quanpin = qp,
      tone = substr(lib, bracketloc + 1, nchar(lib) - 1),
      toneless = gsub('[1-4]', '', substr(lib, bracketloc + 1, nchar(lib) - 1))
    )
    pylib <- ifelse(grepl(' ', qp), paste0('[', pylib, ']'), pylib)
  } else {
    pylib <-  switch( # extract the first pinyin if multiple
      method,
      quanpin = sapply(substr(lib, 3, bracketloc - 1), mystrsplit),
      tone = sapply(substr(lib, bracketloc + 1, nchar(lib) - 1), mystrsplit),
      toneless = gsub('[1-4]', '', sapply(substr(lib, bracketloc + 1, nchar(lib) - 1), mystrsplit))
    )
  }
  if (only_first_letter) pylib <- substr(pylib, 1, 1)
  names(pylib) <- zh
  return(pylib)
}


#############################################################
#' Rename files with Chinese characters to pinyin
#'
#' @param folder character. The folder in which the files are to be renamed.
#'
#' @return files with new names.
#' @export
#' @examples file.rename2py()
file.rename2py <- function(folder = 'py') {
  if (dir.exists(folder)) {
    oldname <- dir(folder, full.names = TRUE)
    newname <- paste(folder, sapply(dir(folder), pinyin, method = 'toneless', sep = '', nonezh_replace = NULL, only_first_letter = TRUE), sep = '/')
    file.rename(oldname, newname)
  } else {message(paste('The directory', folder, 'does not exist!'))}

}

#############################################################
#' Convert the Chinese headers of bookdown .Rmd files into Pinyin
#'
#' @param folder character. The folder in which the files are to be converted.
#' @param remove_curly_bracket logical. Whether to remove existing curly brackets in the headers.
#'
#' @return new .Rmd files with Pinyin headers.
#' @export
#' @examples bookdown2py()
bookdown2py <- function(folder = 'py', remove_curly_bracket = TRUE) {
  if (dir.exists(folder)) {
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
        headerpy <- pinyin(mychar = sub('^#* ', '', md[headerloc]), method = 'toneless', sep = '', nonezh_replace = '', only_first_letter = TRUE)
        md[headerloc] <- paste(md[headerloc], ' {#', headerpy, '}', sep = '')
      }
      writeLines(text = md, filename, useBytes = TRUE)
    }
  } else {message(paste('The directory', folder, 'does not exist!'))}
}

#############################################################
#' Convert entire files into Pinyin
#'
#' @param folder character. The folder in which the files are to be converted.
#' @param backup logical. Whether the original files should be saved as backups.
#' @param method character. The value can be:
#' - 'quanpin', for the standard form of pinyin (tones above letters),
#' - 'tone', for tones expressed with numbers,
#' - 'toneless', without tones
#' @param sep character. Seperation between the converted pinyin.
#' @param nonezh_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param only_first_letter logical. Wheter only the first letter in pinyin.
#' @param multi logical. Whether display multiple pronounciations of a Chinese character or only the first pronounciation.
#' @param encoding character. The encoding of the input files. 'UTF-8' by default.
#'
#' @return files converted to Pinyin.
#' @export
#' @examples file2py()
file2py <- function(folder = 'py', backup = TRUE, method = c('quanpin', 'tone', 'toneless'), sep = ' ', nonezh_replace = NULL, only_first_letter = FALSE, multi = FALSE, encoding = 'UTF-8') {
  if (dir.exists(folder)) {
    method <- match.arg(method)
    i <- 0
    filedir <- dir(folder, full.names = TRUE)
    filenr <- length(filedir)
    message(paste('Start.', filenr, 'file(s) to convert. It might take a while. Please be patient.'))
    for (filename in filedir) {
      i <- i + 1
      if (backup) file.copy(filename, to = paste0(filename, 'backup'))
      oldfile <- readLines(filename, encoding = encoding)
      newfile <- sapply(oldfile, pinyin, method = method, sep = sep, nonezh_replace = nonezh_replace, only_first_letter = only_first_letter, multi = multi)
      writeLines(text = newfile, filename, useBytes = TRUE)
      message(paste(filename, 'converted.',  i, '/', filenr))
    }
    message('Done!')
  } else {message(paste('The directory', folder, 'does not exist!'))}
}
