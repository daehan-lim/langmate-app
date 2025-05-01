import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_mate/app/constants/app_styles.dart';
import 'package:lang_mate/core/utils/ui_util.dart';
import 'package:lang_mate/ui/pages/profile/user_profile_page.dart';
import 'package:lang_mate/ui/widgets/app_cached_image.dart';

import '../../../../../../app/constants/app_colors.dart';
import '../../../../../../data/model/app_user.dart';
import '../../../../../user_global_view_model.dart';
import 'list_text_button.dart';

class UserListItem extends StatelessWidget {
  final AppUser user;

  const UserListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.lightGrey,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UserProfilePage(user: user);
            },
          ),
        );
        // assignRandomLocations(context);
        // updateTestDistricts(context);
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
          const SizedBox(width: 12),

          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name, language, chat button
                _buildTopRow(),
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
                    Consumer(
                      builder: (
                        BuildContext context,
                        WidgetRef ref,
                        Widget? child,
                      ) {
                        return Text(
                          ref
                              .read(userGlobalViewModelProvider.notifier)
                              .calculateDistanceFrom(user.location) ?? '1.3 km',
                          style: AppStyles.usersListText,
                        );
                      },
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

  Row _buildTopRow() {
    return Row(
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
                  Icon(Icons.sync_alt_outlined, color: Colors.black, size: 17),
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
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ListTextButton(
              '채팅',
              onPressed: () {
                UIUtil.openConversationWithUser(
                  otherUser: user,
                  ref: ref,
                  context: context,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
