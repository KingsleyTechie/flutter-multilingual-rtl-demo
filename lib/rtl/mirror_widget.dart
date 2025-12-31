import 'package:flutter/material.dart';

class MirrorIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final TextDirection? textDirection;
  
  const MirrorIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool shouldMirror = _shouldMirror(context);
    
    if (!shouldMirror) {
      return Icon(
        icon,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
      );
    }
    
    return Transform(
      transform: Matrix4.identity()
        ..scale(-1.0, 1.0, 1.0), // Mirror horizontally
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
      ),
    );
  }
  
  bool _shouldMirror(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar' ||
                  locale.languageCode == 'fa' ||
                  locale.languageCode == 'he' ||
                  locale.languageCode == 'ur';
    
    if (!isRTL) return false;
    
    // Mirror only directional icons
    final directionalIcons = {
      Icons.chevron_left,
      Icons.chevron_right,
      Icons.arrow_back,
      Icons.arrow_forward,
      Icons.arrow_back_ios,
      Icons.arrow_forward_ios,
      Icons.keyboard_arrow_left,
      Icons.keyboard_arrow_right,
      Icons.navigate_before,
      Icons.navigate_next,
      Icons.skip_previous,
      Icons.skip_next,
      Icons.first_page,
      Icons.last_page,
      Icons.play_arrow, // Sometimes needs mirroring
    };
    
    return directionalIcons.contains(icon);
  }
}

class MirrorIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double? iconSize;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool enableFeedback;
  final BoxConstraints? constraints;
  final ButtonStyle? style;
  
  const MirrorIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback = true,
    this.constraints,
    this.style,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool shouldMirror = _shouldMirror(context);
    
    if (!shouldMirror) {
      return IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        iconSize: iconSize,
        color: color,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        disabledColor: disabledColor,
        focusNode: focusNode,
        autofocus: autofocus,
        tooltip: tooltip,
        enableFeedback: enableFeedback,
        constraints: constraints,
        style: style,
      );
    }
    
    return Transform(
      transform: Matrix4.identity()
        ..scale(-1.0, 1.0, 1.0), // Mirror horizontally
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        iconSize: iconSize,
        color: color,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        disabledColor: disabledColor,
        focusNode: focusNode,
        autofocus: autofocus,
        tooltip: tooltip,
        enableFeedback: enableFeedback,
        constraints: constraints,
        style: style,
      ),
    );
  }
  
  bool _shouldMirror(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar' ||
                  locale.languageCode == 'fa' ||
                  locale.languageCode == 'he' ||
                  locale.languageCode == 'ur';
    
    if (!isRTL) return false;
    
    // Mirror only directional icons
    final directionalIcons = {
      Icons.chevron_left,
      Icons.chevron_right,
      Icons.arrow_back,
      Icons.arrow_forward,
      Icons.arrow_back_ios,
      Icons.arrow_forward_ios,
      Icons.keyboard_arrow_left,
      Icons.keyboard_arrow_right,
      Icons.navigate_before,
      Icons.navigate_next,
    };
    
    return directionalIcons.contains(icon);
  }
}

class MirrorDrawer extends StatelessWidget {
  final Widget child;
  final double? elevation;
  final Color? shadowColor;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double? widthPercentage;
  final bool semanticLabel;
  
  const MirrorDrawer({
    super.key,
    required this.child,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.shape,
    this.widthPercentage,
    this.semanticLabel = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isRTL = _isRTL(context);
    
    return Drawer(
      child: child,
      elevation: elevation,
      shadowColor: shadowColor,
      backgroundColor: backgroundColor,
      shape: shape,
      width: widthPercentage != null
          ? MediaQuery.of(context).size.width * widthPercentage!
          : null,
      semanticLabel: semanticLabel ? 'Navigation Drawer' : null,
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

class MirrorEndDrawer extends StatelessWidget {
  final Widget child;
  final double? elevation;
  final Color? shadowColor;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double? widthPercentage;
  final bool semanticLabel;
  
  const MirrorEndDrawer({
    super.key,
    required this.child,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.shape,
    this.widthPercentage,
    this.semanticLabel = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isRTL = _isRTL(context);
    
    return isRTL ? Drawer(
      child: child,
      elevation: elevation,
      shadowColor: shadowColor,
      backgroundColor: backgroundColor,
      shape: shape,
      width: widthPercentage != null
          ? MediaQuery.of(context).size.width * widthPercentage!
          : null,
      semanticLabel: semanticLabel ? 'End Drawer' : null,
    ) : EndDrawer(
      child: child,
      elevation: elevation,
      shadowColor: shadowColor,
      backgroundColor: backgroundColor,
      shape: shape,
      width: widthPercentage != null
          ? MediaQuery.of(context).size.width * widthPercentage!
          : null,
      semanticLabel: semanticLabel ? 'End Drawer' : null,
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
