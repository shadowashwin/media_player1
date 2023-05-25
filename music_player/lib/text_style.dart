import 'dart:ui';
import 'colors.dart';


const logo = "logo";

OurStyle({family = logo,double? size = 14.0,color = primary}){
  return TextStyle(
      fontSize: size,
      color: color,
    fontFamily: family
  );
}