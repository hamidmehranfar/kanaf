import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChooseItemImage extends StatelessWidget {
  final Function() onTap;
  final String text;
  final TextStyle? textStyle;
  final double width;
  final double height;
  final Color color;
  final double bottomPadding;
  final double topPadding;

  const ChooseItemImage({
    super.key,
    required this.onTap,
    required this.text,
    required this.width,
    required this.height,
    required this.color,
    required this.bottomPadding,
    required this.topPadding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
            width: width,
            height: height,
            child: SvgPicture.asset(
              'assets/images/calculate_button_svg.svg',
              width: width,
              height: height,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: topPadding,
            bottom: bottomPadding,
            child: Center(
              child: Text(
                text,
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
