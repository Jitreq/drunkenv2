import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/xr_app_bar.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int selectedIndex = 1;
  Friend? selectedFriend;

  static const pageTitles = [
    Strings.settingsTitle,
    Strings.homeTitle,
    Strings.mapTitle,
  ];

  void _showFriendOnMap(Friend friend) {
    setState(() {
      selectedFriend = friend;
      selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: XrAppBar(title: pageTitles[selectedIndex]),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          ProfileScreen(onLogout: widget.onLogout),
          HomeScreen(onShowFriendOnMap: _showFriendOnMap),
          MapScreen(selectedFriend: selectedFriend),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setState(() => selectedIndex = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: Strings.settingsTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: Strings.homeTitle,
          ),
          NavigationDestination(icon: Icon(Icons.map), label: Strings.mapTitle),
        ],
      ),
    );
  }
}
