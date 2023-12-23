import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppTextStyle {
  static Function regular =
      (Color color, double size) => _style(color, size, FontWeight.w400);

  static Function light =
      (Color color, double size) => _style(color, size, FontWeight.w500);

  static Function bold =
      (Color color, double size) => _style(color, size, FontWeight.w700);

  static Function extrabold =
      (Color color, double size) => _style(color, size, FontWeight.w900);

  static TextStyle _style(Color color, double size, FontWeight fontWeight) {
    return _textStyle("QuickSand", color, size, fontWeight);
  }

  static TextStyle _textStyle(
      String fontFamily, Color color, double size, FontWeight fontWeight) {
    return TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontSize: size,
        fontWeight: fontWeight);
  }
}


Widget getPhotos({
  String? imageUrl,
  double radius = 10.0,
  Widget? placeHolderImage,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl!,
    imageBuilder: (context, imageProvider) => Container(
      height: 50,
      width: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
        ), //cover
      ),
    ),
    placeholder: (context, url) => Container(
      child: placeHolderImage,
    ),
  );
}

