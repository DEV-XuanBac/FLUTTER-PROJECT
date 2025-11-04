import 'package:flutter/material.dart';

mixin class ColorConstants {
  static const Color primaryLight10 = Color(0xffFEFCFB);
  static const Color primaryLight20 = Color(0xffFFF8F4);
  static const Color primaryLight30 = Color(0xffFFEDD5);
  static const Color primaryLight40 = Color(0xffFFE0BB);
  static const Color primaryLight50 = Color(0xffFFD3A4);
  static const Color primaryLight60 = Color(0xffFFC291);
  static const Color primaryLight70 = Color(0xffFFAA7D);
  static const Color primaryLight80 = Color(0xffED8A5C);
  static const Color primaryLight90 = Color(0xffF76808);
  static const Color primaryLight100 = Color(0xffED5F00);
  static const Color primaryLight110 = Color(0xff99543A);
  static const Color primaryLight120 = Color(0xff582D1D);

  static const Color primaryDark10 = Color(0xff1F1206);
  static const Color primaryDark20 = Color(0xff271504);
  static const Color primaryDark30 = Color(0xff341C0A);
  static const Color primaryDark40 = Color(0xff3F220D);
  static const Color primaryDark50 = Color(0xff4B2910);
  static const Color primaryDark60 = Color(0xff5D3213);
  static const Color primaryDark70 = Color(0xff7E4318);
  static const Color primaryDark80 = Color(0xffC36522);
  static const Color primaryDark90 = Color(0xffF76808);
  static const Color primaryDark100 = Color(0xffFF802B);
  static const Color primaryDark110 = Color(0xffFFA366);
  static const Color primaryDark120 = Color(0xffFFE0C2);

  static const Color neutralLight10 = Color(0xffFDFDFC);
  static const Color neutralLight20 = Color(0xffF9F9F8);
  static const Color neutralLight30 = Color(0xffF2F2F0);
  static const Color neutralLight40 = Color(0xffEBEBE9);
  static const Color neutralLight50 = Color(0xffE4E4E2);
  static const Color neutralLight60 = Color(0xffDDDDDA);
  static const Color neutralLight70 = Color(0xffD3D2CE);
  static const Color neutralLight80 = Color(0xffBCBBB5);
  static const Color neutralLight90 = Color(0xff8D8D86);
  static const Color neutralLight100 = Color(0xff80807A);
  static const Color neutralLight110 = Color(0xff63635E);
  static const Color neutralLight120 = Color(0xff21201C);

  static const Color neutralDark10 = Color(0xff181816);
  static const Color neutralDark20 = Color(0xff1B1B1A);
  static const Color neutralDark30 = Color(0xff282826);
  static const Color neutralDark40 = Color(0xff30302E);
  static const Color neutralDark50 = Color(0xff383734);
  static const Color neutralDark60 = Color(0xff403F3C);
  static const Color neutralDark70 = Color(0xff4C4B47);
  static const Color neutralDark80 = Color(0xff62605B);
  static const Color neutralDark90 = Color(0xff6F6D66);
  static const Color neutralDark100 = Color(0xff83817A);
  static const Color neutralDark110 = Color(0xffB2B1AA);
  static const Color neutralDark120 = Color(0xffEEEEEC);

  static const Color accentRed = Color(0xffFC2C2C);
  static const Color accentYellow = Color(0xffFDCF2B);
  static const Color accentGreen = Color(0xff12A142);

  static const ColorThemeExt colorThemeLightExt = ColorThemeExt(
    primaryColor1: primaryLight10,
    primaryColor2: primaryLight20,
    primaryColor3: primaryLight30,
    primaryColor4: primaryLight40,
    primaryColor5: primaryLight50,
    primaryColor6: primaryLight60,
    primaryColor7: primaryLight70,
    primaryColor8: primaryLight80,
    primaryColor9: primaryLight90,
    primaryColor10: primaryLight100,
    primaryColor11: primaryLight110,
    primaryColor12: primaryLight120,
    neutralColor1: neutralLight10,
    neutralColor2: neutralLight20,
    neutralColor3: neutralLight30,
    neutralColor4: neutralLight40,
    neutralColor5: neutralLight50,
    neutralColor6: neutralLight60,
    neutralColor7: neutralLight70,
    neutralColor8: neutralLight80,
    neutralColor9: neutralLight90,
    neutralColor10: neutralLight100,
    neutralColor11: neutralLight110,
    neutralColor12: neutralLight120,
  );

  static const ColorThemeExt colorThemeDarkExt = ColorThemeExt(
    primaryColor1: primaryDark10,
    primaryColor2: primaryDark20,
    primaryColor3: primaryDark30,
    primaryColor4: primaryDark40,
    primaryColor5: primaryDark50,
    primaryColor6: primaryDark60,
    primaryColor7: primaryDark70,
    primaryColor8: primaryDark80,
    primaryColor9: primaryDark90,
    primaryColor10: primaryDark100,
    primaryColor11: primaryDark110,
    primaryColor12: primaryDark120,
    neutralColor1: neutralDark10,
    neutralColor2: neutralDark20,
    neutralColor3: neutralDark30,
    neutralColor4: neutralDark40,
    neutralColor5: neutralDark50,
    neutralColor6: neutralDark60,
    neutralColor7: neutralDark70,
    neutralColor8: neutralDark80,
    neutralColor9: neutralDark90,
    neutralColor10: neutralDark100,
    neutralColor11: neutralDark110,
    neutralColor12: neutralDark120,
  );
}

class ColorThemeExt extends ThemeExtension<ColorThemeExt> {
  final Color primaryColor1;
  final Color primaryColor2;
  final Color primaryColor3;
  final Color primaryColor4;
  final Color primaryColor5;
  final Color primaryColor6;
  final Color primaryColor7;
  final Color primaryColor8;
  final Color primaryColor9;
  final Color primaryColor10;
  final Color primaryColor11;
  final Color primaryColor12;
  final Color neutralColor1;
  final Color neutralColor2;
  final Color neutralColor3;
  final Color neutralColor4;
  final Color neutralColor5;
  final Color neutralColor6;
  final Color neutralColor7;
  final Color neutralColor8;
  final Color neutralColor9;
  final Color neutralColor10;
  final Color neutralColor11;
  final Color neutralColor12;

  const ColorThemeExt({
    required this.primaryColor1,
    required this.primaryColor2,
    required this.primaryColor3,
    required this.primaryColor4,
    required this.primaryColor5,
    required this.primaryColor6,
    required this.primaryColor7,
    required this.primaryColor8,
    required this.primaryColor9,
    required this.primaryColor10,
    required this.primaryColor11,
    required this.primaryColor12,
    required this.neutralColor1,
    required this.neutralColor2,
    required this.neutralColor3,
    required this.neutralColor4,
    required this.neutralColor5,
    required this.neutralColor6,
    required this.neutralColor7,
    required this.neutralColor8,
    required this.neutralColor9,
    required this.neutralColor10,
    required this.neutralColor11,
    required this.neutralColor12,
  });

  @override
  ThemeExtension<ColorThemeExt> copyWith() {
    throw UnimplementedError();
  }

  @override
  ThemeExtension<ColorThemeExt> lerp(
    covariant ThemeExtension<ColorThemeExt>? other,
    double t,
  ) {
    if (other is! ColorThemeExt) {
      return this;
    }
    return ColorThemeExt(
      primaryColor1:
          Color.lerp(primaryColor1, other.primaryColor1, t) ?? primaryColor1,
      primaryColor2:
          Color.lerp(primaryColor2, other.primaryColor2, t) ?? primaryColor2,
      primaryColor3:
          Color.lerp(primaryColor3, other.primaryColor3, t) ?? primaryColor3,
      primaryColor4:
          Color.lerp(primaryColor4, other.primaryColor4, t) ?? primaryColor4,
      primaryColor5:
          Color.lerp(primaryColor5, other.primaryColor5, t) ?? primaryColor5,
      primaryColor6:
          Color.lerp(primaryColor6, other.primaryColor6, t) ?? primaryColor6,
      primaryColor7:
          Color.lerp(primaryColor7, other.primaryColor7, t) ?? primaryColor7,
      primaryColor8:
          Color.lerp(primaryColor8, other.primaryColor8, t) ?? primaryColor8,
      primaryColor9:
          Color.lerp(primaryColor9, other.primaryColor9, t) ?? primaryColor9,
      primaryColor10:
          Color.lerp(primaryColor10, other.primaryColor10, t) ?? primaryColor10,
      primaryColor11:
          Color.lerp(primaryColor11, other.primaryColor11, t) ?? primaryColor11,
      primaryColor12:
          Color.lerp(primaryColor12, other.primaryColor12, t) ?? primaryColor12,
      neutralColor1:
          Color.lerp(neutralColor1, other.neutralColor1, t) ?? neutralColor1,
      neutralColor2:
          Color.lerp(neutralColor2, other.neutralColor2, t) ?? neutralColor2,
      neutralColor3:
          Color.lerp(neutralColor3, other.neutralColor3, t) ?? neutralColor3,
      neutralColor4:
          Color.lerp(neutralColor4, other.neutralColor4, t) ?? neutralColor4,
      neutralColor5:
          Color.lerp(neutralColor5, other.neutralColor5, t) ?? neutralColor5,
      neutralColor6:
          Color.lerp(neutralColor6, other.neutralColor6, t) ?? neutralColor6,
      neutralColor7:
          Color.lerp(neutralColor7, other.neutralColor7, t) ?? neutralColor7,
      neutralColor8:
          Color.lerp(neutralColor8, other.neutralColor8, t) ?? neutralColor8,
      neutralColor9:
          Color.lerp(neutralColor9, other.neutralColor9, t) ?? neutralColor9,
      neutralColor10:
          Color.lerp(neutralColor10, other.neutralColor10, t) ?? neutralColor10,
      neutralColor11:
          Color.lerp(neutralColor11, other.neutralColor11, t) ?? neutralColor11,
      neutralColor12:
          Color.lerp(neutralColor12, other.neutralColor12, t) ?? neutralColor12,
    );
  }
}
