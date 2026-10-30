# 验证记录

日期：2026-10-31。

## 设计读取

- Pixso 插件直读文件：`Eatko food delivery ui kit`。
- 当前文件页面分类：`xd page`（`0:1`），共 25 个手机界面。
- 原稿逻辑尺寸：375×812；全部 Frame 逐页导出至 `docs/design/`。
- 插画、菜品图、分类图标、头像、Logo 从原稿节点单独导出为透明 PNG，App 使用本地资源，非整页图片覆盖界面。
- 使用 Barlow Regular/SemiBold 与 Poppins Medium，字体授权见 `assets/fonts/*-LICENSE.txt`。

## 自动化检查

| 检查 | 结果 | 覆盖范围 |
| --- | --- | --- |
| `flutter analyze` | 通过，No issues found | 全部 Dart 代码、测试与驱动 |
| `flutter test --concurrency=1` | 6 项测试通过 | 双尺寸 25 路由布局、搜索/空状态、键盘弹出后滚动、购物车合并与规格价格、订单金额快照、本地持久化 |
| Android 模拟器端到端测试 | 通过 | 25 路由截图、数量增加、加入购物车、填写地址、选择支付方式、填写银行卡、确认模拟付款、清空购物车、配送评价 |
| 截图完整性 | 通过 | 25 张 PNG，均为 750×1624，无重复文件内容 |
| Android debug 构建 | 通过 | 已安装并运行于模拟器 |
| Android release 构建 | 通过 | 51.7 MB 演示包；已安装并从正常入口完成引导、登录与首页启动 |

布局测试尺寸为 375×812 和 320×640，50 次页面渲染均未出现 Flutter 布局异常。测试使用实际字体，避免默认测试字体改变测量宽度。输入页采用系统输入法，不照搬原稿中的静态键盘图层。

## 模拟器与复现

- Android Emulator：Android 15 / API 35、x86_64。
- 本次设备：`emulator-5554`。
- 模拟器截屏分辨率：750×1624，像素密度 320 dpi，即 Flutter 375×812 逻辑尺寸。
- Flutter：3.47.7 stable；Dart：3.13.5；Android 编译 SDK：36。
- 测试截图是 Flutter 实际运行画面；未包含系统状态栏及手势栏。目录中的 `overview_*.jpg` 为这些截图的缩略拼图。

```powershell
flutter pub get
flutter analyze
flutter test --concurrency=1
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d emulator-5554
flutter build apk --release
```

截图驱动在路由切换完成后额外等待绘制，再保存当前帧。首次测试曾发现部分截图抓取前一页，已修正等待顺序并重新检查全部图片；加入购物车的短暂提示会覆盖底部区域，测试会清除提示后继续结算。

## 与设计稿的合理调整

1. 修复原稿多行标题高度不足造成的重叠，使用正常行高。
2. 搜索结果数量由本地菜单实时计算，为 7 道示例菜品，而非固定 224。
3. 原稿初始购物车合计 29.50 与单价不一致，按整数美分计算为 29.48。
4. 原稿多处数量数字与加减图标重叠；实现分开排列，并对最小数量/删除进行处理。
5. 系统键盘按用户输入时机出现，屏幕可滚动。
6. 地图为忠于原稿视觉风格的路径示意，无在线地图瓦片或实时定位。
7. 部分原稿未定义的交互使用对话框/空状态补齐，如编辑资料、食物搜索、模拟支付确认和联系骑手。

## 当前交付边界

完成 Flutter UI 与本地业务交互。没有真实用户鉴权、短信发送、密码恢复服务、支付通道、餐厅后台或骑手定位。银行卡、CVV、密码均不保存在设备中；评价、购物车、收藏和资料由 SharedPreferences 保存。

iOS 目录已生成，本次在 Windows 环境未编译 iOS。Web 目录保留作为浏览器运行入口，本次验收以 Android 模拟器为准。Android release 包使用开发签名，正式发布需替换签名配置。

## 安装包

[Eatko-1.0.0-demo.apk](../dist/Eatko-1.0.0-demo.apk)

SHA-256：`14B07FDA06C45953504297F16185871B1DBD21A683058D2634BC58B8BB185A25`。
