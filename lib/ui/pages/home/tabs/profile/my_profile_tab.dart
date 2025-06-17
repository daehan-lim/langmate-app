import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lang_mate/ui/pages/profile_edit/profile_edit_page.dart';
import 'package:lang_mate/ui/user_global_view_model.dart';
import 'package:lang_mate/ui/widgets/profile_layout.dart';

import '../../../../../app/app_providers.dart';
import '../../../../widgets/logout_icon_button.dart';

class MyProfileTab extends StatelessWidget {
  const MyProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final user = ref.watch(userGlobalViewModelProvider)!;
        return ListView(
          children: [
            AppBar(
              title: Text('나의 프로필'),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileEditPage(user: user),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: SvgPicture.asset(
                      'assets/icons/edit_square.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF504347),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                LogoutIconButton(authService: ref.read(authServiceProvider)),
              ],
            ),
            ProfileLayout(user: user),
          ],
        );
      },
    );
  }
}
