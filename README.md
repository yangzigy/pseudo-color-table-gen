pseudo-color-table-gen
===========

生成伪彩色的颜色表，使用matplot的伪彩色方案

需要安装：
numpy
matplot

生成伪彩色的效果，见
http://matplotlib.org/examples/color/colormaps_reference.html

使用 generat.py 生成matplot的伪彩色代码C++文件，然后编译：

make

生成color.exe
执行后输出颜色表，格式为256个整形，低3字节为RGB值。



