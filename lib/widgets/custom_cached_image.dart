import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CustomCachedImage({super.key, required this.url,
    this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,width: width,height: height,fit: fit,
      errorWidget: (context, text, object){
        return Image.asset("assets/images/default_image.png");
      },
    );
  }
}
