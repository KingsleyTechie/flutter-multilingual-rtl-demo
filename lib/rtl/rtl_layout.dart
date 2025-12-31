import 'package:flutter/material.dart';

class RTLLayout extends StatelessWidget {
  final Widget child;
  final bool forceRTL;
  final AlignmentGeometry alignment;
  
  const RTLLayout({
    super.key,
    required this.child,
    this.forceRTL = false,
    this.alignment = Alignment.topCenter,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isRTL = forceRTL || _isRTL(context);
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
  
  bool _isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ||
           locale.languageCode == 'fa' ||
           locale.languageCode == 'he' ||
           locale.languageCode == 'ur';
  }
}

class RTLText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final Locale? locale;
  final TextScaler? textScaler;
  final bool? semanticsLabel;
  
  const RTLText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.textScaler,
    this.semanticsLabel,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isRTL = _isRTLLanguage(text) || _isRTL(context);
    
    return Text(
      text,
      style: style,
      textAlign: textAlign ?? (isRTL ? TextAlign.right : TextAlign.left),
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textDirection: textDirection ?? (isRTL ? TextDirection.rtl : TextDirection.ltr),
      locale: locale,
      textScaler: textScaler,
      semanticsLabel: semanticsLabel == true ? text : null,
    );
  }
  
  bool _isRTLLanguage(String text) {
    // Check if text contains Arabic, Persian, Hebrew, or Urdu characters
    final rtlRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\u0590-\u05FF\u0780-\u07BF\u0800-\u083F]',
    );
    return rtlRegex.hasMatch(text);
  }
  
  bool _isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ||
           locale.languageCode == 'fa' ||
           locale.languageCode == 'he' ||
           locale.languageCode == 'ur';
  }
}

class MirrorWidget extends StatelessWidget {
  final Widget child;
  final AxisDirection mirrorDirection;
  
  const MirrorWidget({
    super.key,
    required this.child,
    this.mirrorDirection = AxisDirection.left,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool shouldMirror = _shouldMirror(context);
    
    if (!shouldMirror) {
      return child;
    }
    
    return Transform(
      transform: Matrix4.identity()
        ..scale(-1.0, 1.0, 1.0), // Mirror horizontally
      alignment: Alignment.center,
      child: child,
    );
  }
  
  bool _shouldMirror(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar' ||
                  locale.languageCode == 'fa' ||
                  locale.languageCode == 'he' ||
                  locale.languageCode == 'ur';
    
    // Only mirror for RTL languages
    if (!isRTL) return false;
    
    // Check if widget should be mirrored based on type
    if (child is IconButton || child is Icon) {
      return mirrorDirection == AxisDirection.left;
    }
    
    return false;
  }
}

class RTLRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  
  const RTLRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isRTL = _isRTL(context);
    
    return Row(
      children: isRTL ? children.reversed.toList() : children,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection ?? (isRTL ? TextDirection.rtl : TextDirection.ltr),
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
    );
  }
  
  bool _isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ||
           locale.languageCode == 'fa' ||
           locale.languageCode == 'he' ||
           locale.languageCode == 'ur';
  }
}

class RTLSafeArea extends StatelessWidget {
  final Widget child;
  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;
  
  const RTLSafeArea({
    super.key,
    required this.child,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isRTL = _isRTL(context);
    
    return SafeArea(
      child: child,
      left: isRTL ? right : left,
      top: top,
      right: isRTL ? left : right,
      bottom: bottom,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
    );
  }
  
  bool _isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ||
           locale.languageCode == 'fa' ||
           locale.languageCode == 'he' ||
           locale.languageCode == 'ur';
  }
}
