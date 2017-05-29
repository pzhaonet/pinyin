# pinyin

This is an R package for converting Chinese characters into pinyin. Therefore I wrote the instruction in Chinese.

今天新写了个R包，粗暴地取名为 [pinyin](https://github.com/pzhaonet/pinyin/)，作用是把汉字转换成拼音。

## 安装方法

``` r
devtools::install_github("pzhaonet/pinyin")
```

安装时可能会出现一些关于 locale 的警告，净吓唬人，无视。

## 使用方法

pinyin 0.0.0版包含4个函数.`zh2py()`是主函数，可以把一个带汉字的字符串转换成拼音。可以选择:

-   转换成标准的全拼 (默认 `method = 'quanpin'`)，或
-   以数字表示声调 (`method = 'tone'`) , 或
-   不含声调(`method = 'toneless'`),
-   也可以选择仅保留每个字的首字母(`only_first_letter = TRUE`),
-   可以自定义相邻两字拼音的分隔符号(`sep = '_'`),
-   如果汉字字符串里边包含非汉字字符，可以选择将这些字符保留原样(`nonezh_replace = NULL`)还是转换成指定字符(如`nonezh_replace = '-'`)。

举例如下：

``` r
library('pinyin')
zh2py('羌笛何须怨杨柳春风不度玉门关')
```

    ## [1] "qiānɡ_dí_hé_xū_yuàn_yánɡ_liǔ_chūn_fēnɡ_bú_dù_yù_mén_ɡuān"

``` r
zh2py('羌笛何须怨杨柳春风不度玉门关', sep = ' ')
```

    ## [1] "qiānɡ dí hé xū yuàn yánɡ liǔ chūn fēnɡ bú dù yù mén ɡuān"

``` r
zh2py('羌笛何须怨杨柳春风不度玉门关', sep = ' ', method = 'tone')
```

    ## [1] "qiang1 di2 he2 xu1 yuan4 yang2 liu3 chun1 feng1 bu2 du4 yu4 men2 guan1"

``` r
zh2py('羌笛何须怨杨柳春风不度玉门关', sep = ' ', method = 'toneless')
```

    ## [1] "qiang di he xu yuan yang liu chun feng bu du yu men guan"

``` r
zh2py('羌笛何须怨杨柳春风不度玉门关', sep = '', only_first_letter = TRUE)
```

    ## [1] "qdhxyylcfbdymɡ"

``` r
zh2py('羌笛何须怨?杨柳春风,不度玉门关.', sep = '')
```

    ## [1] "qiānɡdíhéxūyuàn?yánɡliǔchūnfēnɡ,búdùyùménɡuān."

如果自变量是多个字符串的向量，那么只会转换第一个字符串：

``` r
zh2py(c('羌笛何须怨杨柳', '春风不度玉门关'))
```

    ## [1] "qiānɡ_dí_hé_xū_yuàn_yánɡ_liǔ"

这怎么行？哎，用 `sapply()` 嘛：

``` r
sapply(c('羌笛何须怨杨柳', '春风不度玉门关'), zh2py)
```

    ##                 羌笛何须怨杨柳                 春风不度玉门关 
    ## "qiānɡ_dí_hé_xū_yuàn_yánɡ_liǔ"  "chūn_fēnɡ_bú_dù_yù_mén_ɡuān"

其他3个函数，其实是 `zh2py()` 的延伸和示例：

- `file.rename2py()`用来将文件名里的汉字转换成拼音。
- `file2py()` 用来将指定文件夹里的一个文件或多个文件里的汉字全部转换成拼音。 
- `bookdown2py()`是专门为 bookdown 包服务的，作用是为章节的中文标题自动添加个对应的拼音ID `{#biaotipinyin}`，避免在生成网页文件时文件名里出现一大堆乱码，并且解决[标题里中英文混合的问题](https://disqus.com/home/discussion/yihui/_yihui_xie_679/#comment-3175332429)。这事儿已经让我惦记三个月了。--- 当然这事儿手动完全可以处理，只是手动处理的过程毫无乐趣可言罢了。

拼音库我试了好几个，最后选定了[wangyanhan整理制作的42856字拼音表](http://bbs.unispim.com/forum.php?mod=viewthread&tid=31644)，直接处理文本文件，简单粗暴，转换起来可能有点慢，会顿一下，但已经够我自用了。

我写这个包的环境是 windows 7 下区域设置为中国，别的环境没测试，估计会有不少坑。我这里就有一些，比如不知道哪里设置有问题，包的函数里居然不能出现中文字符，弄得我自变量的默认值和example部分只好空着。再比如多音字的问题，目前完全没处理。所以，转换`春眠不觉晓`的结果会让人愣一下，再转换`处处闻啼鸟`……

结果好尴尬。

所以这时请用`zh2py()`的参数`multi = TRUE`，这样就把多个读音都列出来，请自选。

## Updates

- 2017-05-29. **Version 0.2.0**. `zh2py(multi = TRUE)` to display multiple procounciations of a Chinese character.
- 2017-05-29. **Version 0.1.0**. A new function `file2py()` was created according to Dong's comment. 
- 2017-05-26. **Version 0.0.0**. Preliminary.
