# pinyin: an R package for converting Chineses characters into pinyin 

## Introduction

This is an R package for converting Chinese characters into pinyin. An brief introduction to pinyin can be found in [Wikipedia](https://en.wikipedia.org/wiki/Pinyin):

> Pinyin, or Hànyǔ Pīnyīn, is the official romanization system for Standard Chinese in mainland China, Malaysia, Singapore, and Taiwan. It is often used to teach Standard Chinese, which is normally written using Chinese characters. The system includes four diacritics denoting tones. Pinyin without tone marks is used to spell Chinese names and words in languages written with the Latin alphabet, and also in certain computer input methods to enter Chinese characters.
>
> The pinyin system was developed in the 1950s by many linguists, including Zhou Youguang, based on earlier forms of romanization of Chinese. It was published by the Chinese government in 1958 and revised several times. The International Organization for Standardization (ISO) adopted pinyin as an international standard in 1982, followed by the United Nations in 1986. The system was adopted as the official standard in Taiwan in 2009, where it is used for romanization alone (in part to make areas more English-friendly) rather than for educational and computer-input purposes.

Since this package deals with Chinese characters, it is presumed that the users speak Chinese. Therefore I wrote the instruction in Chinese. In case that some uses do not speak Chinese and want to use this package as well, please feel free to contact me via email, although the R codes in this document are self-explanary. 


这个 R 语言包粗暴地用拼音取名为 [pinyin](https://github.com/pzhaonet/pinyin/)，作用是把汉字转换成拼音。

## Installation 安装方法 [ān zhuānɡ fānɡ fǎ]

```{r, eval=FALSE}
install.packages('pinyin')
# or
devtools::install_github("pzhaonet/pinyin")
```

安装时可能会出现一些关于 locale 的警告，净吓唬人，无视。

## Funtions 函数 [hán shù]

函数的用法当然可以看帮助信息就行了。可惜帮助信息里好像没法写中文，而一个处理中文的包的帮助信息和示例却写不了中文，十分遗憾。好在这里可以用中文解释一下。

pinyin 1.0.0版包含4个函数.`pinyin()`是主函数，可以把一个带汉字的字符串转换成拼音。可以选择:

-   转换成标准的全拼 (默认 `method = 'quanpin'`)，或
-   以数字表示声调 (`method = 'tone'`) , 或
-   不含声调(`method = 'toneless'`),
-   也可以选择仅保留每个字的首字母(`only_first_letter = TRUE`),
-   可以自定义相邻两字拼音的分隔符号(`sep = '_'`),
-   如果汉字字符串里边包含非汉字字符，可以选择将这些字符保留原样(`nonezh_replace = NULL`)还是转换成指定字符(如`nonezh_replace = '-'`)。

其他3个函数，其实是 `pinyin()` 的延伸和示例：

- `file.rename2py()`用来对文件重命名，将文件名里的汉字转换成拼音。
- `file2py()` 用来将指定文件夹里的一个或多个文本文件里的汉字全部转换成拼音。 
- `bookdown2py()`是专门为 bookdown 包服务的，作用是为章节的中文标题自动添加个对应的拼音ID `{#biaotipinyin}`，避免在生成网页文件时文件名里出现一大堆乱码，并且解决[标题里中英文混合的问题](https://disqus.com/home/discussion/yihui/_yihui_xie_679/#comment-3175332429)。--- 当然这事儿手动完全可以处理，只是手动处理的过程毫无乐趣可言罢了。

## Examples 示例 [shì lì]

以参数的默认值进行转换：

``` r
library('pinyin')
pinyin('羌笛何须怨杨柳春风不度玉门关')
```

    ## [1] "qiānɡ_dí_hé_xū_yuàn_yánɡ_liǔ_chūn_fēnɡ_bú_dù_yù_mén_ɡuān"

更改相邻拼音之间的分隔符号：

``` r
pinyin('羌笛何须怨杨柳春风不度玉门关', sep = ' ')
```

    ## [1] "qiānɡ dí hé xū yuàn yánɡ liǔ chūn fēnɡ bú dù yù mén ɡuān"

用数字表示声调：

``` r
pinyin('羌笛何须怨杨柳春风不度玉门关', sep = ' ', method = 'tone')
```

    ## [1] "qiang1 di2 he2 xu1 yuan4 yang2 liu3 chun1 feng1 bu2 du4 yu4 men2 guan1"

不使用声调：

``` r
pinyin('羌笛何须怨杨柳春风不度玉门关', sep = ' ', method = 'toneless')
```

    ## [1] "qiang di he xu yuan yang liu chun feng bu du yu men guan"

每个拼音只输出首字母：

``` r
pinyin('羌笛何须怨杨柳春风不度玉门关', sep = '', only_first_letter = TRUE)
```

    ## [1] "qdhxyylcfbdymɡ"

非汉字或汉语标点的字符保留原型：

``` r
pinyin('羌笛何须怨?杨柳春风,不度玉门关.', sep = '', nonezh_replace = NULL)
```

    ## [1] "qiānɡdíhéxūyuàn?yánɡliǔchūnfēnɡ,búdùyùménɡuān."


汉语标点符号会自动转换成对应的英文标点符号：

``` r
pinyin('羌笛何须怨？杨柳春风，不度玉门关。', sep = '', nonezh_replace = NULL)
```

    ## [1] "qiānɡdíhéxūyuàn?yánɡliǔchūnfēnɡ,búdùyùménɡuān."

如果自变量是多个字符串的向量，那么只会转换第一个字符串：

``` r
pinyin(c('羌笛何须怨杨柳', '春风不度玉门关'))
```

    ## [1] "qiānɡ_dí_hé_xū_yuàn_yánɡ_liǔ"

这怎么行？哎，用 `sapply()` 嘛：

``` r
sapply(c('羌笛何须怨杨柳', '春风不度玉门关'), pinyin)
```

    ##                 羌笛何须怨杨柳                 春风不度玉门关 
    ## "qiānɡ_dí_hé_xū_yuàn_yánɡ_liǔ"  "chūn_fēnɡ_bú_dù_yù_mén_ɡuān"

## Pinyin library 拼音库 [pīn yīn kù]

拼音库我试了好几个，最后选定了[wangyanhan整理制作的42856字拼音表](http://bbs.unispim.com/forum.php?mod=viewthread&tid=31644)，直接处理文本文件，简单粗暴，转换起来可能有点慢，会愣一下。如果转换比较大的文本文件，请保持耐心。


我写这个包的环境是 windows 7 下区域设置为中国，别的环境没测试，估计会有不少坑。我这里就有一些，比如不知道哪里设置有问题，包的函数里居然不能出现中文字符，弄得我自变量的默认值和example部分只好空着。再比如多音字的问题，目前完全没处理。所以，转换`春眠不觉晓`的结果会让人愣一下，再转换`处处闻啼鸟`……

结果好尴尬。

所以这时请用`pinyin()`的参数`multi = TRUE`，这样就把多个读音都列出来，然后请自便。

## Updates

- 2017-06-19. **Version 1.0.2**. Published on CRAN!
- 2017-06-01. **Version 1.0.0**. `zh2py()` has been removed. Now the main function is `pinyin()`. Submitted to CRAN!
- 2017-05-29. **Version 0.2.0**. `zh2py(multi = TRUE)` to display multiple procounciations of a Chinese character.
- 2017-05-29. **Version 0.1.0**. A new function `file2py()` was created according to Dong's comment. 
- 2017-05-26. **Version 0.0.0**. Preliminary.
