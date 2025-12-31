import 'package:flutter/material.dart';

class ArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  
  const ArabicText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.right,
    this.textDirection = TextDirection.rtl,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
        fontFamily: 'NotoNaskhArabic', // Recommended Arabic font
        letterSpacing: 0,
      ) ?? TextStyle(
        fontFamily: 'NotoNaskhArabic',
        letterSpacing: 0,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

class PersianText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  
  const PersianText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.right,
    this.textDirection = TextDirection.rtl,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
        fontFamily: 'Vazir', // Popular Persian font
        letterSpacing: 0,
      ) ?? TextStyle(
        fontFamily: 'Vazir',
        letterSpacing: 0,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

class UrduText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  
  const UrduText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.right,
    this.textDirection = TextDirection.rtl,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
        fontFamily: 'JameelNooriNastaleeq', // Beautiful Urdu font
        letterSpacing: 0,
      ) ?? TextStyle(
        fontFamily: 'JameelNooriNastaleeq',
        letterSpacing: 0,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

class RTLCurrencyText extends StatelessWidget {
  final num amount;
  final String currencyCode;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool showSymbol;
  
  const RTLCurrencyText({
    super.key,
    required this.amount,
    required this.currencyCode,
    this.style,
    this.textAlign,
    this.showSymbol = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final bool isRTL = _isRTL(context);
    final String formattedAmount = _formatAmount(amount);
    final String symbol = _getCurrencySymbol(currencyCode);
    
    String displayText;
    if (isRTL) {
      displayText = showSymbol ? '$formattedAmount $symbol' : formattedAmount;
    } else {
      displayText = showSymbol ? '$symbol$formattedAmount' : formattedAmount;
    }
    
    return Text(
      displayText,
      style: style,
      textAlign: textAlign ?? (isRTL ? TextAlign.right : TextAlign.left),
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
    );
  }
  
  String _formatAmount(num amount) {
    // Format with thousand separators
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }
  
  String _getCurrencySymbol(String currencyCode) {
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'SAR': 'ر.س',
      'AED': 'د.إ',
      'IQD': 'ع.د',
      'IRR': '﷼',
      'PKR': '₨',
      'INR': '₹',
      'CNY': '¥',
    };
    
    return symbols[currencyCode] ?? currencyCode;
  }
  
  bool _isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ||
           locale.languageCode == 'fa' ||
           locale.languageCode == 'he' ||
           locale.languageCode == 'ur';
  }
}
     
