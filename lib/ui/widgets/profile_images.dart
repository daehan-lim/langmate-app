import 'package:flutter/material.dart';
import 'package:lang_mate/ui/widgets/app_cached_image.dart';

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
        // Banner/Cover image
        Container(
          height: 170,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/world_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Profile image
        Positioned(
          bottom: -50,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: GestureDetector(
            onTap: isEditable ? onImageTap : null,
            child: ClipOval(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.white,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    ClipOval(
                      child:
                          profileImageUrl != null
                              ? AppCachedImage(
                                imageUrl: profileImageUrl!,
                                width: 92,
                                height: 92,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                width: 92,
                                height: 92,
                                color: Colors.grey[200],
                                child: const Icon(Icons.person, size: 50),
                              ),
                    ),
                    if (isEditable)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
