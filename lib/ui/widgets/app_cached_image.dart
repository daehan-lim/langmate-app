import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 공통 네트워크 이미지 위젯
///
/// CachedNetworkImage를 래핑한 위젯으로, placeholder와 error 처리 포함됨.
class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const AppCachedImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder:
          (context, url) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CupertinoActivityIndicator(
            color: Colors.grey,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      width: width,
      height: height,
      fit: fit,
    );
  }
}