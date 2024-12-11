# 开源的个人足迹

## 前言

启动这个项目的动机很简单，我想知道我曾经踏足过哪些地方，并制作一张地图将其可视化。
受到 “[世界迷雾- Fog of World](https://apps.apple.com/cn/app/%E4%B8%96%E7%95%8C%E8%BF%B7%E9%9B%BE/id505367096)”  这个应用程序的启发，曾经使用过这个app但是又因为懒得备份数据而丢失了记录。我决定用自己的方式留下足迹。
在这个大数据时代，个人曾经的数据或在不知不觉中留下痕迹、或在有意地精心记录。但是只要想，还是能忠实还原我的足迹的。

### 徒步路线记录：Alltrails

这个的导出有一点点麻烦，未来可以考虑自动化。
在 Alltrails 中，您可以导出过去的活动痕迹。在查看记录的活动时，可以点击三个点的按钮，进入 “下载路线”，选择 “GPX 轨迹”，然后就能得到一个 *.gpx 文件。对不同的活动重复此操作，直到满意为止。
当然，你也可能忘记记录自己的活动。您可以下载 “官方 ”路径，并将其重命名为带有日期的文件，例如 your_filename_#20240101。这样，您的活动也会被记录下来。(虽然没有现实中那么准确，但也是个不错的近似值！）。

导出文件夹：将所有 Alltrails 导出的 GPX 文件放到一个文件夹中，如果 GPX 文件中不包含时间数据，则可以用时间标签重命名，这样会更准确。

文件夹示例：TBA

输出示例： Example Output:
[My hiking history](https://kepler.gl/demo/map?mapUrl=https://dl.dropboxusercontent.com/scl/fi/k72pmlbsuptnu14275cf8/keplergl_p8l9r2g.json?rlkey=pcwgiqd32n1ppuao6awiuqu6i&dl=0)

### 谷歌地图时间轴导出: My Timeline

##### 2024 年之前的数据

谷歌地图之前提供了一个在云上非常好的时间轴存储，直到 2024 年中，如果你碰巧之前导出过（就像我做的那样）,使用谷歌浏览器插件
[Timeline Exporter](https://chromewebstore.google.com/detail/timeline-exporter/afalbippddliaaomolohcbfogogbjpkk?hl=en-US&utm_source=ext_sidebar)可以生成CSV数据文件。
并保存到网盘上。

##### 2024 年后的数据

谷歌可以从自己的设备直接导出Json文件。里边大概分为两种格式，一种是路线记录，另外一种是在某个固定地点。

有了自己的数据，那么接下来就要处理并可视化了，

### Project OSRM：开源路线规划机---追踪你的驾驶历史

谷歌地图时间轴存储的历史数据是离散地理点格式，这意味着它并不是完整的路线。不过这也可以理解，几个点足够从有限的可能中找到实际的驾车路线了。幸好OSRM提供了绝佳的网络API，因此我们使用这个工具将我们的时间线补全。

### BRouter: 高级开源地图路线规划---提供铁路旅行的路线导出

[BRouter: Advanced OSM Routing](https://brouter.damsy.net/latest/#map=6/46.672/120.779/standard&profile=rail)
这个神奇的开源项目最初是为了规划骑行路线的，因为这个市场并不大但是路线选项却异常复杂。幸运的是，除了骑行路线它还提供了铁路路线的生成，那么这样就能轻而易举得获取。

## 结果

