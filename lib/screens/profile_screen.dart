import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onLogout,
    required this.trackingEnabled,
    required this.ghostModeEnabled,
    required this.trackingDurationHours,
    required this.sessionEndTime,
    required this.onDurationChanged,
    required this.onStartTracking,
    required this.onEnableGhostMode,
    required this.onDisableGhostMode,
  });

  final VoidCallback onLogout;
  final bool trackingEnabled;
  final bool ghostModeEnabled;
  final int trackingDurationHours;
  final DateTime? sessionEndTime;
  final ValueChanged<int> onDurationChanged;
  final VoidCallback onStartTracking;
  final VoidCallback onEnableGhostMode;
  final VoidCallback onDisableGhostMode;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool shareLocation = true;
  bool visibleToFriends = true;
  late int selectedHours;

  @override
  void initState() {
    super.initState();
    selectedHours = widget.trackingDurationHours;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trackingDurationHours != widget.trackingDurationHours) {
      selectedHours = widget.trackingDurationHours;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.settingsTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              Strings.settingsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: AppColors.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.profileName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            Strings.profileStatus,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.trackingDurationTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Strings.trackingDurationSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text('6h', style: Theme.of(context).textTheme.bodyMedium),
                        Expanded(
                          child: Slider(
                            activeColor: AppColors.secondary,
                            inactiveColor: AppColors.outline.withAlpha(140),
                            value: selectedHours.toDouble(),
                            min: 6,
                            max: 24,
                            divisions: 18,
                            label: '${selectedHours}h',
                            onChanged: widget.trackingEnabled || widget.ghostModeEnabled
                                ? null
                                : (value) {
                                    setState(() {
                                      selectedHours = value.round();
                                    });
                                    widget.onDurationChanged(selectedHours);
                                  },
                          ),
                        ),
                        Text('24h', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (widget.trackingEnabled && !widget.ghostModeEnabled)
                      FilledButton(
                        onPressed: widget.onEnableGhostMode,
                        child: const Text(Strings.enableGhostModeButton),
                      )
                    else if (widget.ghostModeEnabled)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.ghostModeActiveLabel,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  Strings.ghostModeActiveSubtitle,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          FilledButton(
                            onPressed: widget.onDisableGhostMode,
                            child: const Text(Strings.disableGhostModeButton),
                          ),
                        ],
                      )
                    else
                      FilledButton(
                        onPressed: widget.onStartTracking,
                        child: const Text(Strings.startTrackingButton),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: shareLocation,
                    onChanged: (value) => setState(() => shareLocation = value),
                    title: const Text(Strings.shareLocationTitle),
                    subtitle: const Text(Strings.shareLocationSubtitle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    value: visibleToFriends,
                    onChanged: (value) =>
                        setState(() => visibleToFriends = value),
                    title: const Text(Strings.visibleToFriendsTitle),
                    subtitle: const Text(Strings.visibleToFriendsSubtitle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.generalTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                      ),
                      title: const Text(Strings.locationSharing),
                      subtitle: const Text(Strings.locationSharingSubtitle),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.notifications,
                        color: AppColors.secondary,
                      ),
                      title: const Text(Strings.notifications),
                      subtitle: const Text(Strings.notificationsSubtitle),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: widget.onLogout,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.surfaceVariant,
                foregroundColor: AppColors.textPrimary,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text(Strings.logoutButton),
            ),
          ],
        ),
      ),
    );
  }
}
