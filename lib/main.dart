// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:demo/article.dart';
import 'package:demo/split_tool.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const MTRichText(),
    );
  }
}

class MTRichText extends StatefulWidget {
  const MTRichText({super.key});

  @override
  State<MTRichText> createState() => _MTRichTextState();
}

class _MTRichTextState extends State<MTRichText> {
  Rect imgRect = const Rect.fromLTWH(0, 100, 213, 612);
  late TextSpan textSpan;
  double maxWidth = 400;
  Size wSize = const Size(80, 80);
  String link = "http://www.baidu.com";
  @override
  void initState() {
    super.initState();
    RichText;
    WidgetSpan;
    ColoredBox;
    Container;

    textSpan = TextSpan(
        text: "嘻嘻\n",
        children: [
          TextSpan(
            text: '${tianlong.first}\n',
            style: const TextStyle(
                fontSize: 30, color: Color.fromARGB(255, 22, 20, 2)),
          ),
          TextSpan(children: [
            TextSpan(
              text: tianlong[1],
              style: const TextStyle(color: Colors.blueGrey),
            ),
            TextSpan(
              text: tianlong[2],
              style: const TextStyle(color: Colors.blueGrey),
            ),
            TextSpan(
                style: TextStyle(color: Colors.amber[600], fontSize: 24),
                children: const [
                  TextSpan(
                    text: "\n望庐山瀑布\n",
                    style: TextStyle(fontSize: 30),
                  ),
                  TextSpan(
                    text: "--李白\n",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                  ),
                  TextSpan(
                    text: "日照香炉生紫烟,\n遥看瀑布挂前川,\n飞流直下三千尺,\n疑是银河落九天.\n",
                    style: TextStyle(color: Color.fromARGB(255, 12, 209, 183)),
                  ),
                ]),
          ], style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
          TextSpan(children: [
            TextSpan(
              text: tianlong[3],
              style: const TextStyle(color: Colors.blueGrey),
            ),
            TextSpan(
              text: tianlong[4],
              style: const TextStyle(color: Colors.blueGrey),
            ),
            TextSpan(
                text: link,
                style: const TextStyle(
                    color: Color.fromARGB(255, 46, 168, 230),
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.wavy,
                    decorationThickness: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse(link));
                  }),
          ], style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
          WidgetSpan(
              child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('你点击了图片哦！')));
            },
            child: SizedBox(
              width: wSize.width,
              height: wSize.height,
              child: Image.network(
                  "http://img.duoziwang.com/2017/06/03/B78109670.jpg"),
            ),
          )),
          TextSpan(children: [
            TextSpan(
              text: tianlong[5],
              style: const TextStyle(color: Colors.blueGrey),
            ),
            TextSpan(
              text: tianlong[6],
              style: const TextStyle(color: Colors.blueGrey),
            ),
            TextSpan(
              text: tianlong[7],
              style: const TextStyle(color: Colors.blueGrey),
            ),
          ], style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
        ],
        style: const TextStyle(color: Colors.black26));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // 计算上边界矩形
                    assert(constraints.maxWidth.isFinite);
                    final parentWidth = constraints.maxWidth;

                    /// top
                    final topRect = Rect.fromLTWH(
                        0, 0, parentWidth.clamp(0, parentWidth), imgRect.top);
                    final topTool = renderTextSpan(textSpan, topRect);

                    /// left
                    final leftRect = Rect.fromLTWH(0, imgRect.top,
                        imgRect.left.clamp(0, parentWidth), imgRect.height);
                    final leftTool =
                        renderTextSpan(topTool.trailingTextSpan, leftRect);

                    /// right
                    final rightRect = imgRect.topRight &
                        Size(
                            (parentWidth - imgRect.right).clamp(0, parentWidth),
                            imgRect.height.clamp(0, imgRect.height));
                    final rightTool =
                        renderTextSpan(leftTool.trailingTextSpan, rightRect);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// top
                        if (topRect.width != 0 && topRect.height != 0)
                          SizedBox(
                            width: topRect.width,
                            height: topRect.height,
                            child: RichText(text: topTool.leadingTextSpan),
                          ),
                        Row(
                          children: [
                            /// left
                            if (leftRect.width != 0 && leftRect.height != 0)
                              SizedBox(
                                width: leftRect.width,
                                height: leftRect.height,
                                child: RichText(text: leftTool.leadingTextSpan),
                              ),

                            /// middle
                            Container(
                              color: Colors.orangeAccent,
                              width: imgRect.width,
                              height: imgRect.height,
                              child: const Center(
                                  child: Text(
                                "占",
                                style: TextStyle(fontSize: 22),
                              )),
                            ),

                            /// right
                            SizedBox(
                              width: rightRect.width,
                              height: rightRect.height,
                              child: RichText(text: rightTool.leadingTextSpan),
                            ),
                          ],
                        ),
                        RichText(text: rightTool.trailingTextSpan),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
        sliders(),
      ],
    );
  }

  Widget sliders() {
    return Column(
      children: [
        Row(
          children: [
            const Text("x:"),
            Expanded(
              child: Slider(
                value: imgRect.left,
                min: 0,
                max: maxWidth,
                onChanged: (value) {
                  setState(() {
                    imgRect = Rect.fromLTWH(
                        value, imgRect.top, imgRect.width, imgRect.height);
                  });
                },
                overlayColor: MaterialStateProperty.all(Colors.amber),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text("y:"),
            Expanded(
              child: Slider(
                value: imgRect.top,
                min: 0,
                max: maxWidth,
                onChanged: (value) {
                  setState(() {
                    imgRect = Rect.fromLTWH(
                        imgRect.left, value, imgRect.width, imgRect.height);
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text("width:"),
            Expanded(
              child: Slider(
                value: imgRect.width.clamp(10, maxWidth),
                min: 10,
                max: maxWidth,
                onChanged: (value) {
                  setState(() {
                    imgRect = Rect.fromLTWH(imgRect.left, imgRect.top,
                        value.clamp(10, maxWidth), imgRect.height);
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text("height:"),
            Expanded(
              child: Slider(
                value: imgRect.height.clamp(10, maxWidth),
                min: 10,
                max: maxWidth,
                onChanged: (value) {
                  setState(() {
                    imgRect = Rect.fromLTWH(imgRect.left, imgRect.top,
                        imgRect.width, value.clamp(10, maxWidth));
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 1.给定区域内绘制InlineSpan，
  /// 2.分割Span
  TextSpanSplitTool renderTextSpan(TextSpan textSpan, Rect rect) {
    rect = Rect.fromLTWH(
        rect.left.ceilToDouble(),
        rect.top.ceilToDouble(),
        max(rect.width.floorToDouble(), 0),
        max(0, rect.height.floorToDouble()));
    late TextSpanSplitTool tool;

    if (rect.width == 0 || rect.height == 0) {
      tool = TextSpanSplitTool.noLeading(textSpan);
      return tool;
    }
    final txPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    final List<WidgetSpan> allWidgetSpans = <WidgetSpan>[];
    textSpan.visitChildren((InlineSpan span) {
      if (span is WidgetSpan) {
        allWidgetSpans.add(span);
      }
      return true;
    });
    List<PlaceholderDimensions> dimentions = [];
    for (var span in allWidgetSpans) {
      final dimention = PlaceholderDimensions(
        size: wSize,
        alignment: span.alignment,
        baseline: span.baseline,
        baselineOffset: null,
      );
      dimentions.add(dimention);
    }
    txPainter.setPlaceholderDimensions(dimentions);
    txPainter.layout(maxWidth: rect.width);

    final textBoxes = txPainter.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 1000),
        boxWidthStyle: BoxWidthStyle.max);

    bool aContainB(Rect a, Rect b) {
      if (b.bottom.ceilToDouble() <= a.bottom) {
        return true;
      }
      return false;
    }

    TextBox? lastBox;
    Rect containerRect = Rect.fromLTWH(0, 0, rect.width, rect.height);
    for (var i = 0; i < textBoxes.length; i++) {
      final textBox = textBoxes[i];
      final txBox = textBox.toRect();
      if (aContainB(containerRect, txBox)) {
        lastBox = textBox;
      } else {
        break;
      }
    }
    if (lastBox == null) {
      tool = TextSpanSplitTool.noLeading(textSpan);
    } else {
      final bottomRightTxPos = txPainter
          .getPositionForOffset(Offset(lastBox.right - 1, lastBox.bottom - 1));
      tool = TextSpanSplitTool(textSpan: textSpan, position: bottomRightTxPos);
    }
    return tool;
  }
}
