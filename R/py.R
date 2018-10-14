#' Convert Chinese characters into Pinyin.
#'
#' @param char character. A Chinese character or string to convert to pinyin
#' @param sep character. Seperation between the converted pinyin.
#' @param other_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param dic the preloaded pinyin library using the `pylib()` function.
#'
#' @return pinyin of the given Chinese character.
#' @importFrom stats setNames
#' @export
#' @examples py(dic = NA)
py <- function(char = '',
               sep = '_',
               other_replace = NULL,
               dic = NA) {
  if(class(dic)!= 'environment')  return(message('"dic" must be an environment.'))
  mycharsingle <- strsplit(char, split = '')[[1]]
  myreplace <- function(x) {
    if(is.null(dic[[x]])) ifelse(is.null(other_replace), x, other_replace) else dic[[x]]
  }
  converted <- paste(sapply(mycharsingle, myreplace), collapse = sep)
  return(converted)
}

#' Load a Pinyin library
#'
#' @param method character. The value can be:
#' - 'quanpin', for the standard form of pinyin (tones above letters),
#' - 'tone', for tones expressed with numbers,
#' - 'toneless', without tones
#' @param multi logical. Whether display multiple pronounciations of a Chinese character or only the first pronounciation.
#' @param only_first_letter logical. Wheter only the first letter in pinyin.
#' @param dic character. Choose the dictionary.
#'
#' @return character. a Pinyin library.
#' @export
#' @examples pydic()
pydic <- function(method = c('quanpin', 'tone', 'toneless'),
                  multi = FALSE,
                  only_first_letter = FALSE,
                  dic = c('pinyin', 'pinyin2')) {
  method <- match.arg(method)
  dic <- match.arg(dic)
  mypath <- paste0(.libPaths(), '/pinyin/lib/', dic, '.txt')
  lib <- readLines(mypath[file.exists(mypath)][1], encoding = 'UTF-8')
  if(dic == 'pinyin') {
    lib <- lib[-grep('^#', lib)] # remove headers
    lib <- lib[-which(nchar(lib) == 0)] # remove blank lines
    zh <- substr(lib, 1, 1) # chinese char
    bracketloc <- regexpr('\\(', lib)
    if (multi) {
      qp <- substr(lib, 3, bracketloc - 1)
      mylib <-  switch( # extract all pinyins
        method,
        quanpin = qp,
        tone = substr(lib, bracketloc + 1, nchar(lib) - 1),
        toneless = gsub('[1-4]', '', substr(lib, bracketloc + 1, nchar(lib) - 1))
      )
      mylib <- ifelse(grepl(' ', qp), paste0('[', mylib, ']'), mylib)
    } else {
      mylib <-  switch( # extract the first pinyin if multiple
        method,
        quanpin = sapply(substr(lib, 3, bracketloc - 1), strsplit2),
        tone = sapply(substr(lib, bracketloc + 1, nchar(lib) - 1), strsplit2),
        toneless = gsub('[1-4]', '', sapply(substr(lib, bracketloc + 1, nchar(lib) - 1), strsplit2))
      )
    }
  }
  if(dic == 'pinyin2'){
    zh <- substr(lib, 1, 1)
    if(multi){
      qp <- substr(lib, 2, nchar(lib))
      mylib <-  switch( # extract all pinyins
        method,
        quanpin = qp,
        tone = qp,
        toneless = gsub('[1-4]', '', qp)
      )
      mylib <- ifelse(grepl(' ', qp), paste0('[', mylib, ']'), mylib)
    } else {
      qp <- sapply(substr(lib, 2, nchar(lib)), strsplit2)
      mylib <- switch(method,
                      quanpin = qp,
                      tone = qp,
                      toneless = gsub("[1-4]","", qp))
      mylib <- sapply(mylib, strsplit2)
    }
  }
  if (only_first_letter) mylib <- substr(mylib, 1, 1)
  mylib <- list2env(setNames(as.list(mylib),zh))
  return(mylib)
}

#' Load a customized dictionary.
#'
#' @param dic_file The path of a dictionary file.
#' @param select The option to choose from the dictionary.
#'
#' @return A dictionary
#' @importFrom splitstackshape cSplit
#' @importFrom data.table as.data.table
#' @export
#'
#' @examples load_dic()
load_dic <- function(dic_file = paste0(.libPaths(), '/pinyin/lib/wubi86.txt'), select = 1) {
  # read the dictionary file
  dic <- readLines(dic_file, encoding = 'UTF-8')
  # get the format code
  fileformat <- dic[grep('format', dic)]
  fileformat <- gsub('.*format.*([[:digit:]])', '\\1', fileformat)
  # remove the comments
  dic <- dic[-1]
  dic <- dic[!grepl('^#', dic)] # remove headers
  # remove blank lines
  dic <- dic[nchar(dic)!= 0]
  if(fileformat == 1){
    zh <- sapply(dic, strsplit2, nth = 1, sep = ',')
    mylib <- sapply(dic, strsplit2, nth = 2, sep = ',')
    mylib <- sapply(mylib, strsplit2, nth = select)
  } else if(fileformat == 2){
    dic <- splitstackshape::cSplit(data.table::as.data.table(dic), "dic", " ")
    colnames(dic) <- c("Code","Chars")
    dic$Chars <- as.character(dic$Chars)
    n.char <- sapply(dic$Chars, nchar)
    mylib <- rep(dic$Code, n.char)
    zh <- unlist(sapply(dic$Chars, strsplit,""))
  } else return(message('I cannot get the format of your dictionary.'))
  myenv <- list2env(setNames(as.list(mylib), zh))
  return(myenv)
}

#' Rename files according to a given dictionary
#'
#' @param folder character. The folder in which the files are to be renamed.
#' @param dic See `help(pinyin)`.
#'
#' @return files with new names.
#' @export
#' @examples
#' mydir <- paste0(tempdir(), '/py')
#' dir.create(mydir)
#' file.create(paste0(mydir, '/test.txt'))
#' file.rename2(mydir)
file.rename2py <- function(folder = 'py', dic = NA) {
  if (dir.exists(folder)) {
    if(class(dic)!= 'environment')  return(message('"dic" must be an environment.'))
    oldname <- dir(folder, full.names = TRUE)
    newname <- paste(folder,
                     sapply(dir(folder), py,  sep = '', other_replace = NULL, dic = dic),
                     sep = '/')
    file.rename(oldname, newname)
  } else {message(paste('The directory', folder, 'does not exist!'))}

}

#' Convert the Chinese headers of bookdown .Rmd files into Pinyin
#'
#' @param folder character. The folder in which the files are to be converted.
#' @param remove_curly_bracket logical. Whether to remove existing curly brackets in the headers.
#' @param other_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param dic See `help(pinzin)`.
#'
#' @return new .Rmd files with Pinyin headers.
#' @export
#' @examples
#' mydir <- paste0(tempdir(), '/py')
#' dir.create(mydir)
#' file.create(paste0(mydir, '/test.txt'))
#' writeLines(text = '# test\n', paste0(mydir, '/test.txt'))
#' bookdown2py(mydir)
bookdown2py <- function(folder = 'py',
                      remove_curly_bracket = TRUE,
                      other_replace = NULL,
                      dic = NA) {
  if (dir.exists(folder)) {
    dic <- match.arg(dic)
    if(class(dic)!= 'environment')  return(message('"dic" must be an environment.'))

    for (filename in dir(folder, full.names = TRUE)) {
      file.copy(filename, to = paste0('backup', filename))
      md <- readLines(filename, encoding = 'UTF-8')
      headerloc <- grep('^#+', md)
      codeloc <- grep('^```', md)
      # exclude the lines begining with # but in code
      if (length(codeloc) > 0) headerloc <- headerloc[!sapply(headerloc, function(x) sum(x > codeloc[seq(1, length(codeloc), by = 2)] & x < codeloc[seq(2, length(codeloc), by = 2)])) == 1]
      if (remove_curly_bracket) md[headerloc] <- gsub(pattern = '\\{.*\\}', '', md[headerloc])
      for (i in headerloc){
        headerpy <- py(mychar = sub('^#* ', '', md[i]), dic = dic,
                           sep = '',
                           other_replace = other_replace)
        headerpy <- tolower(headerpy)
        headerpy <- gsub('[^a-z]', '_', headerpy)
        md[i] <- paste(md[i], ' {#', headerpy, '}', sep = '')
      }
      writeLines(text = md, filename, useBytes = TRUE)
    }
  } else {message(paste('The directory', folder, 'does not exist!'))}
}

#' Convert the characters in an entire files according to a given dictionary
#'
#' @param folder character. The folder in which the files are to be converted.
#' @param backup logical. Whether the original files should be saved as backups.
#' @param sep character. Seperation between the converted pinyin.
#' @param other_replace NULL or character. Define how to convert non-Chinese characters in mychar. NULL means 'let it be'.
#' @param encoding character. The encoding of the input files. 'UTF-8' by default.
#' @param dic See `help(pinzin)`.
#'
#' @return files converted to Pinyin.
#' @export
#' @examples
#' mydir <- paste0(tempdir(), '/py')
#' dir.create(mydir)
#' file.create(paste0(mydir, '/test.txt'))
#' writeLines(text = 'test\n', paste0(mydir, '/test.txt'))
#' file2py(mydir)
file2py <- function(folder = 'py',
                    backup = TRUE,
                    sep = ' ',
                    other_replace = NULL,
                    encoding = 'UTF-8',
                    dic = NA) {
  if (dir.exists(folder)) {
    method <- match.arg(method)
    dic <- match.arg(dic)
    if(class(dic)!= 'environment')  return(message('"dic" must be an environment.'))
    i <- 0
    filedir <- dir(folder, full.names = TRUE)
    filenr <- length(filedir)
    message(paste('Start.', filenr, 'file(s) to convert. It might take a while. Please be patient.'))
    for (filename in filedir) {
      i <- i + 1
      if (backup) file.copy(filename, to = paste0(filename, 'backup'))
      oldfile <- readLines(filename, encoding = encoding)
      newfile <- sapply(oldfile, py, dic = dic, sep = sep, other_replace = other_replace)
      writeLines(text = newfile, filename, useBytes = TRUE)
      message(paste(filename, 'converted.',  i, '/', filenr))
    }
    message('Done!')
  } else {message(paste('The directory', folder, 'does not exist!'))}
}
