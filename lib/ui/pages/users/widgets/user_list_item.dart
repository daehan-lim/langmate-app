import 'package:flutter/material.dart';

import '../../../../data/model/user.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('User'));
  }
}