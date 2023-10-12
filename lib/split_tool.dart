
import 'package:flutter/material.dart';

enum CaculateEnum {
  normal,
  noleading,
  notrailing,
}

class TextSpanSplitTool {
  TextPosition position;
  TextSpan textSpan;
  CaculateEnum caculateEnum;
  bool noNeedCaculate = false;
  bool splitImmdiately;
  final List<InlineSpan> _leadingTextSpans = [];
  final List<InlineSpan> _trailingTextSpans = [];
  TextSpan? _leadingTextSpan;
  TextSpan? _trailingTextSpan;

  TextSpan get leadingTextSpan {
    return _leadingTextSpan ??= TextSpan(children: _leadingTextSpans);
  }

  TextSpan get trailingTextSpan {
    return _trailingTextSpan ??= TextSpan(children: _trailingTextSpans);
  }

  TextSpanSplitTool({
    required this.textSpan,
    required this.position,
    this.caculateEnum = CaculateEnum.normal,
    this.splitImmdiately = true,
  }) {
    if (splitImmdiately) {
      splitSpan();
    }
  }
  factory TextSpanSplitTool.noLeading(TextSpan textSpan) {
    return TextSpanSplitTool(
        textSpan: textSpan,
        position: const TextPosition(offset: 0),
        caculateEnum: CaculateEnum.noleading);
  }

  /// 拆分textSpan
  void splitSpan() {
    InlineSpan newSpan = createSpanFrom(textSpan);
    if (newSpan is! TextSpan) {
      newSpan = TextSpan(children: [newSpan]);
    }
    switch (caculateEnum) {
      case CaculateEnum.noleading:
        _trailingTextSpan = newSpan;
        break;
      case CaculateEnum.notrailing:
        _leadingTextSpan = newSpan;
        break;
      case CaculateEnum.normal:
        _splitSpanInPosition(newSpan, position);
    }
  }

  void _splitSpanInPosition(TextSpan textSpan, TextPosition position) {
    final Accumulator offset = Accumulator();
    InlineSpan? result;
    textSpan.visitChildren((InlineSpan span) {
      if (result != null) {
        _trailingTextSpans.add(createSpanFrom(span, removeChildren: true));
        return true;
      } else {
        result = _doSplitSpanInPosition(span, position, offset);
        if (result == null) {
          _leadingTextSpans.add(createSpanFrom(span, removeChildren: true));
        }
      }
      return true;
    });
  }

  InlineSpan? _doSplitSpanInPosition(
    InlineSpan textSpan,
    TextPosition position,
    Accumulator offset,
  ) {
    InlineSpan? leadSpan;
    InlineSpan? trailSpan;

    final TextAffinity affinity = position.affinity;
    final int targetOffset = position.offset;
    int endOffset = 0;
    if (textSpan is WidgetSpan) {
      endOffset = offset.value + 1;
      if (offset.value == targetOffset && affinity == TextAffinity.downstream ||
          endOffset == targetOffset && affinity == TextAffinity.upstream) {
        if (offset.value == targetOffset &&
            affinity == TextAffinity.downstream) {
          trailSpan = textSpan;
        } else {
          leadSpan = textSpan;
        }
        if (leadSpan != null) {
          _leadingTextSpans.add(leadSpan);
        }
        if (trailSpan != null) {
          _trailingTextSpans.add(trailSpan);
        }
        return textSpan;
      }
      offset.increment(1);
      return null;
    }

    textSpan as TextSpan;
    final text = textSpan.text;
    if (text == null) {
      return null;
    }
    endOffset = offset.value + text.length;

    if (offset.value == targetOffset && affinity == TextAffinity.downstream ||
        offset.value < targetOffset && targetOffset < endOffset ||
        endOffset == targetOffset && affinity == TextAffinity.upstream) {
      if (offset.value < targetOffset && targetOffset < endOffset) {
        final beforeStr = text.substring(0, targetOffset - offset.value);
        final afterStr = text.substring(targetOffset - offset.value);
        leadSpan = createSpanFrom(textSpan,
            removeChildren: true, replaceText: beforeStr) as TextSpan;
        trailSpan = createSpanFrom(textSpan,
            removeChildren: true, replaceText: afterStr) as TextSpan;
      } else if (offset.value == targetOffset &&
          affinity == TextAffinity.downstream) {
        leadSpan =
            createSpanFrom(textSpan, removeChildren: true, replaceText: "")
                as TextSpan;
        trailSpan = createSpanFrom(textSpan, removeChildren: true) as TextSpan;
      } else if (endOffset == targetOffset &&
          affinity == TextAffinity.upstream) {
        leadSpan = createSpanFrom(textSpan, removeChildren: true) as TextSpan;
        trailSpan =
            createSpanFrom(textSpan, removeChildren: true, replaceText: "")
                as TextSpan;
      }
      if (leadSpan != null) {
        _leadingTextSpans.add(leadSpan);
      }
      if (trailSpan != null) {
        _trailingTextSpans.add(trailSpan);
      }
      return textSpan;
    }
    offset.increment(text.length);
    return null;
  }

  static InlineSpan createSpanFrom(
    InlineSpan inlineSpan, {
    bool removeChildren = false,
    String? replaceText,
    TextStyle? parentTextStyle,
  }) {
    final effectStyle =
        parentTextStyle?.merge(inlineSpan.style) ?? inlineSpan.style;
    if (inlineSpan is WidgetSpan) {
      return inlineSpan;
    } else if (inlineSpan is TextSpan) {
      String? effectText =
          replaceText == "" ? null : replaceText ?? inlineSpan.text;
      return TextSpan(
        text: effectText,
        children: removeChildren
            ? null
            : inlineSpan.children
                ?.map(
                    (e) => createSpanFrom(e, parentTextStyle: inlineSpan.style))
                .toList(),
        locale: inlineSpan.locale,
        mouseCursor: inlineSpan.mouseCursor,
        onEnter: inlineSpan.onEnter,
        onExit: inlineSpan.onExit,
        recognizer: inlineSpan.recognizer,
        semanticsLabel: inlineSpan.semanticsLabel,
        spellOut: inlineSpan.spellOut,
        style: effectStyle,
      );
    }
    throw ErrorDescription("有除了TextSpan和WidgetSpan以外的Span,需要额外处理");
  }
}
