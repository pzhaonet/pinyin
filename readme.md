# pinyin: an R package for converting Chinese characters into pinyin~~,and more~~

## Introduction

This is a fork of @pzhaonet's R package pinyin, but faster.

A simple package like this should not have to many dependencies, so I removed them ALL.

I consider the following functions to be of little to no use to most users, so I removed them ALL.

- pydic, read a dictionary(key-value pairs).
- load_dic, load a customized dictionary
- file.rename2py, rename files according to a given dictionary. 
- bookdown2py, convert the chinese headers of bookdown Rmd files in to pinyin
- file2py, convert the characters in an entire files according to a given dictionary

## Installation & Example



```{r, eval=FALSE}
remotes::install_github("tcgriffith/pinyin")
#> Skipping install of 'pinyin' from a github remote, the SHA1 (1449a0a3) has not changed since last install.
#>   Use `force = TRUE` to force installation

pinyin::py("我喜欢旅游 abcasdfasdfa")
#>           我喜欢旅游 abcasdfasdfa 
#> "_wo_xi_huan_lv_you abcasdfasdfa"
```

## Usage

The only function in this package is `py()`. see `help(pinyin::py)`


## Updates

- 2019-10-20. **version 1.1.6**  Remove a lot, add a little. Speedup (100x faster) (@tcgriffith)
- 2018-12-16. **version 1.1.5**. Compatible with the deprecated function `pinyin()`. Support vector calculation.
- 2018-10-15. **version 1.1.4**. Support self-defined dictionaries.
- 2018-10-09. **version 1.1.3**. Faster. Users can preload the library. A simple library was added. Four-corner codes are supported. A co-author joined.
- 2018-01-17. **version 1.1.1**. Remove the vignettes.
- 2017-06-19. **Version 1.1.0**. On CRAN. Fixed some bugs.
- 2017-06-19. **Version 1.0.2**. Released on CRAN!
- 2017-06-01. **Version 1.0.0**. `zh2py()` has been removed. Now the main function is `pinyin()`. Submitted to CRAN!
- 2017-05-29. **Version 0.2.0**. `zh2py(multi = TRUE)` to display multiple procounciations of a Chinese character.
- 2017-05-29. **Version 0.1.0**. A new function `file2py()` was created according to Dong's comment. 
- 2017-05-26. **Version 0.0.0**. Preliminary.