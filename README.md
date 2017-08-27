# doujinshiRepacker

# 開宗明義

~~你的幾百 G 的本子有救啦！~~

這個腳本是用來處理成噸的加密壓縮包本子文件的。

暫時無法保證穩定……

以及不能去重，不過經過一段時間使用，發現一般只有目錄那樣的包才會出現重名現象。

從某神社下下來的壓縮包，我們通常會導到手機或者平板上欣賞，而大部分閱讀軟件對於文件結構有一定的要求，一般要求傳進來的是一個加密或者不加密的壓縮包。

當然，我們大部分時間希望可以直接無密碼閱讀，不然太麻煩。
這些壓縮包很多時候結構不一，手動處理起來很累，幾個 G 的還好，但是你若是資深紳士，面對滿盤的本子……

經過對一些資源包結構的考察，發現這些資源往往是以以下結構存在的：

* 合集形式的壓縮包，壓縮包內存在多個壓縮文件:

```text
XX合集.rar
{
  x1.rar
  x2.rar
  x3.rar
  ...
}
```

* 單個壓縮包:

```text
XX本.rar
{
  1.jpg
  2.jpg
  3.jpg
  ...
}
```
 
* 壓縮包內存在單個或者多個文件夾，文件夾內直接存放了每個本子的所有圖片:

```text
XX合集.rar
{
  aa
  {
    1.jpg
    2.jpg
  }
    bb
  {
    1.jpg
    2.jpg
  }
}
```

基於以上目錄，這個腳本的目的是

* 將所有壓縮包的密碼去掉
* 所有的本子會被以單個壓縮包的形式存放，包括未處理的壓縮包內的壓縮本

# 使用

在使用腳本之前，最好自己對所有的本子分好類，腳本只關注一級分類。也就是說，如果一級分類下還有子分類，子分類中的本子也會被提升到一級分類中（所謂類型提升）。

比如分類成這樣：
```
ls ./
東方project 某科學的超電磁砲 艦コレクション
```
將腳本放入一級分類的根目錄，運行。

```shell
sh benzi.sh <password>
```
運行結束后，根目錄下會有一個名為`ex`的文件夾，文件夾下所有處理好的 zip 包被分別放在各自的分類中（分類只有一層哦），方便導入移動設備上的漫畫閱讀軟件。

```shell
#運行結束目錄結構
ls ./ 
ex 東方project 某科學的超電磁砲 艦コレクション
ls ./ex/
東方project 某科學的超電磁砲 艦コレクション
```
