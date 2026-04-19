import 'dart:async';

import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/app_top_padding.dart';
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
  Friend? trackedFriend;
  bool trackingEnabled = false;
  bool gpsAvailable = false;
  int trackingHours = 6;
  DateTime? sessionEndTime;
  Timer? _trackingTimer;

  static const pageTitles = [
    Strings.settingsTitle,
    Strings.mapTitle,
    Strings.friendsTitle,
  ];

  void _showFriendOnMap(Friend friend) {
    setState(() {
      selectedFriend = friend;
      selectedIndex = 1;
    });
  }

  void _toggleTracking(Friend friend) {
    setState(() {
      if (trackedFriend == friend) {
        trackedFriend = null;
      } else {
        trackedFriend = friend;
      }
      selectedIndex = 1;
    });
  }

  void _openSettings() {
    setState(() {
      selectedIndex = 0;
    });
  }

  void _updateTrackingHours(int hours) {
    setState(() {
      trackingHours = hours;
    });
  }

  void _startTrackingSession() {
    _trackingTimer?.cancel();
    setState(() {
      trackingEnabled = true;
      sessionEndTime = DateTime.now().add(Duration(hours: trackingHours));
    });
    _trackingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        _trackingTimer?.cancel();
        return;
      }
      if (sessionEndTime == null || DateTime.now().isAfter(sessionEndTime!)) {
        _stopTrackingSession();
      } else {
        setState(() {});
      }
    });
  }

  void _stopTrackingSession() {
    _trackingTimer?.cancel();
    setState(() {
      trackingEnabled = false;
      sessionEndTime = null;
    });
  }

  void _clearRoute() {
    setState(() {
      selectedFriend = null;
      trackedFriend = null;
    });
  }

  void _updateGpsStatus(bool available) {
    if (gpsAvailable == available) return;
    setState(() {
      gpsAvailable = available;
    });
  }

  String _trackingRemainingLabel() {
    if (sessionEndTime == null) return '';
    final remaining = sessionEndTime!.difference(DateTime.now());
    if (remaining.isNegative) return '0m';
    if (remaining.inHours >= 1) {
      return '${remaining.inHours}h ${remaining.inMinutes.remainder(60)}m';
    }
    return '${remaining.inMinutes}m';
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No new notifications yet.')),
    );
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTopPadding(
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: XrAppBar(
            title: pageTitles[selectedIndex],
            actions: [
              if (trackingEnabled && sessionEndTime != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer.withValues(alpha: 0xE6),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text(
                          '${Strings.trackingEndsIn} ${_trackingRemainingLabel()}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.notifications, color: AppColors.textPrimary),
                onPressed: _showNotifications,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                IndexedStack(
                  index: selectedIndex,
                  children: [
                    ProfileScreen(
                      onLogout: widget.onLogout,
                      trackingEnabled: trackingEnabled,
                      gpsAvailable: gpsAvailable,
                      trackingDurationHours: trackingHours,
                      sessionEndTime: sessionEndTime,
                      onDurationChanged: _updateTrackingHours,
                      onStartTracking: _startTrackingSession,
                      onShareLocationChanged: (value) {
                        if (!value) {
                          _stopTrackingSession();
                        }
                      },
                    ),
                    MapScreen(
                      selectedFriend: selectedFriend,
                      trackedFriend: trackedFriend,
                      trackingEnabled: trackingEnabled,
                      onOpenSettings: _openSettings,
                      onClearRoute: _clearRoute,
                      onShowFriendOnMap: _showFriendOnMap,
                      onTrackFriend: _toggleTracking,
                      onGpsStatusChanged: _updateGpsStatus,
                    ),
                    HomeScreen(
                      trackedFriend: trackedFriend,
                      onShowFriendOnMap: _showFriendOnMap,
                      onTrackFriend: _toggleTracking,
                      trackingEnabled: trackingEnabled,
                      sessionEndTime: sessionEndTime,
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) => setState(() => selectedIndex = value),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: Strings.settingsTitle,
              ),
              NavigationDestination(icon: Icon(Icons.map), label: Strings.mapTitle),
              NavigationDestination(icon: Icon(Icons.group), label: Strings.friendsTitle),
            ],
          ),
        ),
      ),
    );
  }
}