# pinyin: an R package for converting Chinese characters into pinyin, and more


 ![CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/pinyin)

## Introduction

This is an R package for converting Chinese characters into pinyin, four-corner codes, five-stroke codes, and more.



An brief introduction to pinyin can be found in [Wikipedia](https://en.wikipedia.org/wiki/Pinyin):

> Pinyin, or Hànyǔ Pīnyīn, is the official romanization system for Standard Chinese in mainland China, Malaysia, Singapore, and Taiwan. It is often used to teach Standard Chinese, which is normally written using Chinese characters. The system includes four diacritics denoting tones. Pinyin without tone marks is used to spell Chinese names and words in languages written with the Latin alphabet, and also in certain computer input methods to enter Chinese characters.
>
> The pinyin system was developed in the 1950s by many linguists, including Zhou Youguang, based on earlier forms of romanization of Chinese. It was published by the Chinese government in 1958 and revised several times. The International Organization for Standardization (ISO) adopted pinyin as an international standard in 1982, followed by the United Nations in 1986. The system was adopted as the official standard in Taiwan in 2009, where it is used for romanization alone (in part to make areas more English-friendly) rather than for educational and computer-input purposes.

Since this package deals with Chinese characters, it is presumed that the users speak Chinese. Therefore I wrote the instruction in Chinese. In case that some users do not speak Chinese and want to use this package as well, please feel free to contact me via email, although the R codes in this document are self-explanatory. 


这个 R 语言包粗暴地用拼音取名为 [pinyin](https://github.com/pzhaonet/pinyin/)，作用是把汉字转换成拼音。从 v1.1.3 开始，增加了将汉字转换成四角号码或五笔字型的功能。从 v1.1.4 开始，用户可以指定自己的字典，随意转换。


## Installation 安装方法 [ān zhuānɡ fānɡ fǎ]

```{r, eval=FALSE}
install.packages('pinyin')
# or
devtools::install_github("pzhaonet/pinyin")
```

安装时可能会出现一些关于 locale 的警告，净吓唬人，无视。

## Funtions 函数 [hán shù]

函数的用法当然可以看帮助信息就行了。可惜帮助信息里好像没法写中文，而一个处理中文的包的帮助信息和示例却写不了中文，十分遗憾。好在这里可以用中文解释一下。

pinyin 1.1.4 版包含 3 个主函数：

- `pydic()` 用来载入内置的拼音字典（包括拼音，四角，五笔）。

- 如果内置字典不能满足用户需要，用户可以用`load_dic()` 来载入自定义字典。这里提供了四角，五笔 86、五笔 98 三个自定义字典。当然，用户可以自制字典，只需按上述几个字典的格式来制作即可。

- `py()` 用来将指定字符通过查询所载入的字典来转换成对应的拼音、四角或五笔符号。



使用 `pydic()`载入拼音字典时，可以选择以下参数:

- 转换成标准的全拼 (默认 `method = 'quanpin'`)，或
- 以数字表示声调 (`method = 'tone'`) , 或
- 不含声调(`method = 'toneless'`),
- 也可以选择仅保留每个字的首字母(`only_first_letter = TRUE`),
- 要不要显示多音字的多个读音(`multi = FALSE`),
- 有两个字典可选(`dic = c("pinyin", "pinyin2")`)。



使用`py()` 转换汉字时，

- 可以自定义相邻两字拼音的分隔符号(`sep = '_'`),
- 如果汉字字符串里边包含非汉字字符，可以选择将这些字符保留原样(`nonezh_replace = NULL`)还是转换成指定字符(如`nonezh_replace = '-'`)。



使用`load_dic()`载入自定义字典时，目前有三个可用字典（欢迎提交新字典）：

- 四角号码字典：<https://github.com/pzhaonet/pinyin/raw/master/inst2/sijiao.txt>
- 五笔 98：<https://github.com/pzhaonet/pinyin/raw/master/inst2/wubi98.txt>
- 五笔 86：<https://github.com/pzhaonet/pinyin/raw/master/inst2/wubi86.txt>



另外还有 3 个订制函数，是 `py()` 的延伸和示例：

- `file.rename2py()`用来对文件重命名，将文件名里的汉字按载入的字典转换。
- `file2py()` 用来将指定文件夹里的一个或多个文本文件里的汉字按载入的字典全部转换。 
- `bookdown2py()`是专门为 bookdown 包服务的，作用是为章节的中文标题自动添加个对应的字符 ID `{#biaotipinyin}`，避免在生成网页文件时文件名里出现一大堆乱码，并且解决[标题里中英文混合的问题](https://disqus.com/home/discussion/yihui/_yihui_xie_679/#comment-3175332429)。--- 当然这事儿手动完全可以处理，只是手动处理的过程毫无乐趣可言罢了。


## Examples 示例 [shì lì]

以参数的默认值进行转换：

``` r
library('pinyin')
mypy <- pydic() # 载入默认字典
py("春眠不觉晓，处处闻啼鸟", dic = mypy) # 转换

dic_sj <- 'https://github.com/pzhaonet/pinyin/raw/master/inst2/sijiao.txt' #自定义字典链接
mysj <- load_dic(dic_file = dic_sj) # 载入自定义字典
py("春眠不觉晓，处处闻啼鸟", sep = '_', dic = mysj) # 转换
```



## Updates

- 2018-10-15. **version 1.1.4**. Support self-defined dictionaries.
- 2018-10-09. **version 1.1.3**. Faster. Users can preload the library. A simple library was added. Four-corner codes are supported. A co-author joined.
- 2018-01-17. **version 1.1.1**. Remove the vignettes.
- 2017-06-19. **Version 1.1.0**. On CRAN. Fixed some bugs.
- 2017-06-19. **Version 1.0.2**. Released on CRAN!
- 2017-06-01. **Version 1.0.0**. `zh2py()` has been removed. Now the main function is `pinyin()`. Submitted to CRAN!
- 2017-05-29. **Version 0.2.0**. `zh2py(multi = TRUE)` to display multiple procounciations of a Chinese character.
- 2017-05-29. **Version 0.1.0**. A new function `file2py()` was created according to Dong's comment. 
- 2017-05-26. **Version 0.0.0**. Preliminary.
