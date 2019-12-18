import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'thumb_painter.dart';

//btn转圈和文字的问题
class SwitchButton extends StatefulWidget {
  const SwitchButton({
    Key key,
    @required this.value, //开 关
    @required this.onChanged, //状态改变调用
    this.activeColor, //开的颜色
    @required this.showIndicator, //是否显示转圈
    @required this.showText, //是否显示字
    this.onText,
    this.offText,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final bool showIndicator;
  final bool showText;
  final String onText;
  final String offText;

  _SwitchButtonState createState() => _SwitchButtonState();

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value',
        value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
  }
}

class _SwitchButtonState extends State<SwitchButton>
    with TickerProviderStateMixin {
  AnimationController indicaterPosition;

  void initState() {
    super.initState();
    indicaterPosition = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    if (widget.showIndicator) {
      indicaterPosition.repeat();
    }
  }

  void didUpdateWidget(SwitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        indicaterPosition.repeat();
      } else {
        indicaterPosition.stop();
      }
    }
  }

  void dispose() {
    if (indicaterPosition != null) {
      indicaterPosition.dispose();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    return _SwitchButtonRenderObjectWidget(
      value: widget.value,
      activeColor: widget.activeColor ?? CupertinoColors.activeGreen,
      onChanged: widget.onChanged,
      vsync: this,
      showIndicator: widget.showIndicator,
      indicatorPosition: indicaterPosition,
      showText: widget.showText,
      onText: widget.onText,
      offText: widget.offText,
    );
  }
}

class _SwitchButtonRenderObjectWidget extends LeafRenderObjectWidget {
  const _SwitchButtonRenderObjectWidget({
    Key key,
    this.value,
    this.activeColor,
    this.onChanged,
    this.vsync,
    this.showIndicator,
    this.indicatorPosition,
    this.showText,
    this.onText,
    this.offText,
  }) : super(key: key);

  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;
  final TickerProvider vsync;
  final bool showIndicator;
  final Animation<double> indicatorPosition;
  final bool showText;
  final String onText;
  final String offText;

  @override
  _RenderSwitchButton createRenderObject(BuildContext context) {
    return _RenderSwitchButton(
      value: value,
      activeColor: activeColor,
      onChanged: onChanged,
      textDirection: Directionality.of(context),
      vsync: vsync,
      showIndicator: showIndicator,
      indicatorPosition: indicatorPosition,
      showText: showText,
      onText: onText,
      offText: offText,
    );
  }

  void updateRenderObject(
      BuildContext context, _RenderSwitchButton renderObject) {
    renderObject
      ..value = value
      ..activeColor = activeColor
      ..onChanged = onChanged
      ..textDirection = Directionality.of(context)
      ..vsync = vsync
      ..showIndicator = showIndicator
      ..indicatorPosition = indicatorPosition
      ..showText = showText
      ..onText = onText
      ..offText = offText;
  }
}

const double _kBoxWidth = 80.0;
const double _kBoxHeight = 60.0;
const double _kTrackWidth = 50.0;
const double _kTrackHeight = 26.0;
const double _kTrackRadius = _kTrackHeight / 2.0;
const double _kTrackInnerStart = _kTrackHeight / 2.0;
const double _kTrackInnerEnd = _kTrackWidth - _kTrackInnerStart;
const double _kTrackInnerLength = _kTrackInnerEnd - _kTrackInnerStart;
//const double _kSwitchWidth = 50.0;
//const double _kSwitchHeight = 22.0;
const double _kMaxTextSize = 11.5;
const double _kMinTextSize = 0.0;

const Color _kTrackColor = const Color(0xFFD6D6D6);
const Duration _kReactionDuration = const Duration(milliseconds: 300);
const Duration _kToggleDuration = Duration(milliseconds: 200);

class _RenderSwitchButton extends RenderConstrainedBox {
  _RenderSwitchButton({
    @required bool value,
    @required Color activeColor,
    ValueChanged<bool> onChanged,
    @required TextDirection textDirection,
    @required TickerProvider vsync,
    bool showIndicator,
    Animation<double> indicatorPosition,
    bool showText,
    String onText,
    String offText,
  })  : assert(value != null),
        assert(activeColor != null),
        assert(vsync != null),
        _value = value,
        _activeColor = activeColor,
        _onChanged = onChanged,
        _textDirection = textDirection,
        _vsync = vsync,
        _showIndicator = showIndicator,
        _showText = showText,
        _onText = onText,
        _offText = offText,
        super(
            additionalConstraints: const BoxConstraints.tightFor(
                width: _kBoxWidth, height: _kBoxHeight)) {
    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTap = _handleTap
      ..onTapUp = _handleTapUp
      ..onTapCancel = _handleTapCancel;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd;
    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: value ? 1.0 : 0.0,
      vsync: vsync,
    );
    _position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.linear,
    )
      ..addListener(markNeedsPaint)
      ..addStatusListener(_handlePositionStateChanged);
    _reactionController = AnimationController(
      duration: _kReactionDuration,
      vsync: vsync,
    );
    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.ease,
    )..addListener(markNeedsPaint);

    //this.showIndicator = showIndicator;
    this.indicatorPosition = indicatorPosition;

    //_thumbPainter.showIndicator = showIndicator;
    //_thumbPainter.position = indicatorPosition;
  }

  AnimationController _positionController;
  CurvedAnimation _position;

  AnimationController _reactionController;
  Animation<double> _reaction;

  Animation<double> _indicatorPosition;
  Animation<double> get indicatorPosition => _indicatorPosition;
  set indicatorPosition(Animation<double> value) {
    _indicatorPosition = value;
    _thumbPainter.position = value;
    markNeedsPaint();
  }

  bool _showIndicator;
  bool get showIndicator => _showIndicator;
  set showIndicator(bool value) {
    if (_showIndicator == value) return;
    _showIndicator = value;
    markNeedsPaint();
  }

  bool get value => _value;
  bool _value;
  set value(bool value) {
    assert(value != null);
    if (value == _value) return;
    _value = value;
    markNeedsSemanticsUpdate();
    _position
      ..curve = Curves.ease
      ..reverseCurve = Curves.ease.flipped;
    if (value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
  }

  TickerProvider get vsync => _vsync;
  TickerProvider _vsync;
  set vsync(TickerProvider value) {
    assert(value != null);
    if (value == _vsync) return;
    _vsync = value;
    _positionController.resync(vsync);
    _reactionController.resync(vsync);
  }

  Color get activeColor => _activeColor;
  Color _activeColor;
  set activeColor(Color value) {
    assert(value != null);
    if (value == _activeColor) return;
    _activeColor = value;
    markNeedsPaint();
  }

  ValueChanged<bool> get onChanged => _onChanged;
  ValueChanged<bool> _onChanged;
  set onChanged(ValueChanged<bool> value) {
    if (value == _onChanged) return;
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    assert(value != null);
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  bool _showText = false;
  bool get showText => _showText;
  set showText(bool value) {
    if (_showText == value) return;
    _showText = value;
    markNeedsPaint();
  }

  String _onText = '';
  String get onText => _onText;
  set onText(String value) {
    if (_onText == value) return;
    _onText = value;
    markNeedsPaint();
  }

  String _offText = '';
  String get offText => _offText;
  set offText(String value) {
    if (_offText == value) return;
    _offText = value;
    markNeedsPaint();
  }

  bool get isInteractive => onChanged != null;

  TapGestureRecognizer _tap;
  HorizontalDragGestureRecognizer _drag;

  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (value) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
    if (isInteractive) {
      switch (_reactionController.status) {
        case AnimationStatus.forward:
          _reactionController.forward();
          break;
        case AnimationStatus.reverse:
          _reactionController.reverse();
          break;
        case AnimationStatus.dismissed:
          break;
        case AnimationStatus.completed:
          break;
      }
    }
  }

  void detach() {
    _positionController.stop();
    _reactionController.stop();
    super.detach();
  }

  void _handlePositionStateChanged(AnimationStatus status) {
    if (isInteractive) {
      if (status == AnimationStatus.completed && !_value) {
        onChanged(true);
      } else if (status == AnimationStatus.dismissed && _value) {
        onChanged(false);
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) {
      _reactionController.forward();
    }
  }

  void _handleTap() {
    if (showIndicator) return;
    if (isInteractive) {
      onChanged(!_value);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (isInteractive) {
      _reactionController.reverse();
    }
  }

  void _handleTapCancel() {
    if (isInteractive) {
      _reactionController.reverse();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      _reactionController.forward();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      _position
        ..curve = null
        ..reverseCurve = null;
      final double delta = details.primaryDelta / _kTrackInnerLength;
      switch (textDirection) {
        case TextDirection.rtl:
          _positionController.value -= delta;
          break;
        case TextDirection.ltr:
          _positionController.value += delta;
          break;
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_position.value >= 0.5) {
      _positionController.forward();
    } else {
      _positionController.reverse();
    }
    _reactionController.reverse();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      _drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    if (isInteractive) {
      config.onTap = _handleTap;
    }
    config.isEnabled = isInteractive;
    config.isToggled = _value;
  }

  ThumbPainter _thumbPainter = ThumbPainter();

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double currentValue = _position.value;
    final double currentReactionValue = _reaction.value;

    double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Color trackColor = _value ? activeColor : _kTrackColor;

    final Paint paint = Paint()..color = trackColor;

    final Rect trackRect = Rect.fromLTWH(
      offset.dx + (size.width - _kTrackWidth) / 2.0,
      offset.dy + (size.height - _kTrackHeight) / 2.0,
      _kTrackWidth,
      _kTrackHeight,
    );
    final RRect rRect = RRect.fromRectAndRadius(
        trackRect, const Radius.circular(_kTrackRadius));
    canvas.drawRRect(rRect, paint);

    final double currentThumbExtension =
        ThumbPainter.extension * currentReactionValue;
    final double thumbLeft = lerpDouble(
      trackRect.left + _kTrackInnerStart - ThumbPainter.radius,
      trackRect.left +
          _kTrackInnerEnd -
          ThumbPainter.radius -
          currentThumbExtension,
      visualPosition,
    );
    final double thumbRight = lerpDouble(
      trackRect.left +
          _kTrackInnerStart +
          ThumbPainter.radius +
          currentThumbExtension,
      trackRect.left + _kTrackInnerEnd + ThumbPainter.radius,
      visualPosition,
    );
    final double thumbCenterY = offset.dy + size.height / 2.0;
    _thumbPainter.paintThumb(
        canvas,
        Rect.fromLTRB(
          thumbLeft,
          thumbCenterY - ThumbPainter.radius,
          thumbRight,
          thumbCenterY + ThumbPainter.radius,
        ));

    if (_showText) {
      final double maxWidth = trackRect.size.width - 2 * ThumbPainter.radius;
      double actureWidth;
      if (value) {
        actureWidth = thumbLeft - trackRect.left;
      } else {
        actureWidth = trackRect.right - thumbRight;
      }
      final double textSize = lerpDouble(
        _kMinTextSize,
        _kMaxTextSize,
        actureWidth / maxWidth,
      );
      final TextSpan span = TextSpan(
        text: value ? _onText : _offText,
        style: TextStyle(
          color: value ? const Color(0xFFFFFFFF) : const Color(0xFFB0AEAE),
          fontSize: textSize,
          inherit: false,
        ),
      );
      TextAlign textAlign;
      if (value) {
        textAlign = TextAlign.right;
      } else {
        textAlign = TextAlign.left;
      }
      final TextPainter textPainter = TextPainter(
          text: span, textAlign: textAlign, textDirection: TextDirection.ltr);
      textPainter.layout();

      double textLeft;
      if (value) {
        textLeft = thumbLeft -
            textPainter.size.width -
            (thumbLeft - trackRect.left - textPainter.size.width) / 2 +
            1.0;
      } else {
        textLeft = thumbRight +
            (trackRect.right - thumbRight - textPainter.size.width) / 2.0 -
            1.0;
      }
      double textTop = thumbCenterY - textPainter.size.height / 2.0;

      textPainter.paint(canvas, Offset(textLeft, textTop));
    }

    if (_showIndicator) {
      final Offset indicatorOffset = Offset(
        thumbLeft + (thumbRight - thumbLeft) / 2.0,
        thumbCenterY,
      );
      _thumbPainter.paintIndicatoer(canvas, indicatorOffset);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(FlagProperty('value',
        value: value, ifTrue: 'checked', ifFalse: 'unchecked', showName: true));
    description.add(FlagProperty('isInteractive',
        value: isInteractive,
        ifTrue: 'enabled',
        ifFalse: 'disabled',
        showName: true,
        defaultValue: true));
  }
}
