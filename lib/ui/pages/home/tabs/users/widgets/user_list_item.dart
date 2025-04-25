import 'package:flutter/material.dart';
import 'package:lang_mate/app/constants/app_styles.dart';
import 'package:lang_mate/ui/widgets/app_cached_image.dart';

import '../../../../../../app/constants/app_colors.dart';
import '../../../../../../data/model/app_user.dart';

class UserListItem extends StatelessWidget {
  final AppUser user;

  const UserListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.lightGrey,
      onTap: () {
        // addDebugUsersFromJson(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: AppCachedImage(
              imageUrl:
                  user.profileImage ?? 'https://picsum.photos/200/200?random=1',
              width: 66,
              height: 66,
              fit: BoxFit.cover,
            ),
          ),
          // CircleAvatar(
          //   radius: 33,
          //   backgroundImage: NetworkImage(
          //     user.profileImage ?? 'https://picsum.photos/200/200?random=1',
          //   ),
          // ),
          const SizedBox(width: 12),

          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and distance
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Language exchange
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.nativeLanguage ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.sync_alt_outlined,
                                color: Colors.black,
                                size: 17,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                user.targetLanguage ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        backgroundColor: Colors.blue.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        '채팅',
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // District
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${user.district ?? ''}  |  ',
                      style: AppStyles.usersListText,
                    ),
                    Text(
                      '8.3 km', // replace with actual distance
                      style: AppStyles.usersListText,
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                if (user.bio != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(
                      user.bio!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.usersListText,
                    ),
                  ),
                Divider(indent: 0, height: 35, color: Colors.grey[300]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
