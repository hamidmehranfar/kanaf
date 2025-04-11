import 'dart:io';
import 'package:flutter/material.dart';

class ImageContainerWithDismiss extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;
  final File avatarImage;

  const ImageContainerWithDismiss({
    super.key,
    required this.onTap,
    required this.width,
    required this.height,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              left: 5,
              child: SizedBox(
                width: width - 10,
                height: height - 10,
                child: ClipOval(
                  child: Image.file(
                    avatarImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
