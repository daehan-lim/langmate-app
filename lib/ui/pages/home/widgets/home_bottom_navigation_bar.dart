import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_veiw_model.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = ref.watch(homeViewModelProvider);
        final viewModel = ref.read(homeViewModelProvider.notifier);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 19,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            onTap: viewModel.onIndexChanged,
            iconSize: 28,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            selectedItemColor: Colors.blueAccent,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: '연결',
                tooltip: '연결',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_2),
                activeIcon: Icon(CupertinoIcons.chat_bubble_2_fill),
                label: '채팅',
                tooltip: '채팅',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_circle),
                activeIcon: Icon(CupertinoIcons.person_circle_fill),
                label: '프로필',
                tooltip: '프로필',
              ),
            ],
          ),
        );
      },
    );
  }
}
