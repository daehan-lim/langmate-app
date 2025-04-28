import 'package:flutter/material.dart';

import 'app_cached_image.dart';

class ProfileImages extends StatelessWidget {
  final String? profileImageUrl;
  final bool isEditable;
  final VoidCallback? onImageTap;

  const ProfileImages({
    super.key,
    required this.profileImageUrl,
    this.isEditable = false,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/world_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: GestureDetector(
            onTap: isEditable ? onImageTap : null,
            child: Stack(
              children: [
                ClipOval(
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: AppCachedImage(
                        imageUrl: profileImageUrl ?? 'https://picsum.photos/200/200?random=1',
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (isEditable)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.black54),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
