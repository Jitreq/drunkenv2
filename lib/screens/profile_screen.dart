import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onLogout,
    required this.trackingEnabled,
    required this.trackingDurationHours,
    required this.sessionEndTime,
    required this.gpsAvailable,
    required this.onDurationChanged,
    required this.onStartTracking,
    required this.onShareLocationChanged,
  });

  final VoidCallback onLogout;
  final bool trackingEnabled;
  final bool gpsAvailable;
  final int trackingDurationHours;
  final DateTime? sessionEndTime;
  final ValueChanged<int> onDurationChanged;
  final VoidCallback onStartTracking;
  final ValueChanged<bool> onShareLocationChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.gps_fixed,
                                size: 16,
                                color: widget.gpsAvailable
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.gpsAvailable
                                    ? Strings.gpsWorking
                                    : Strings.gpsFallback,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                              ),
                            ],
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DurationControl(
                          value: selectedHours,
                          onChanged: widget.trackingEnabled
                              ? null
                              : (value) {
                                  setState(() {
                                    selectedHours = value.clamp(0, 24);
                                  });
                                  widget.onDurationChanged(selectedHours);
                                },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${selectedHours}h',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (widget.trackingEnabled)
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
                                  Strings.trackingActiveLabel,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  Strings.shareLocationActiveSubtitle,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  '${Strings.trackingEndsIn} ${widget.sessionEndTime == null ? '0m' : _trackingRemainingLabel()}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          FilledButton(
                            onPressed: () => widget.onShareLocationChanged(false),
                            child: const Text(Strings.stopSharingButton),
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
                    value: widget.trackingEnabled,
                    onChanged: widget.trackingEnabled
                        ? (value) => widget.onShareLocationChanged(value)
                        : null,
                    title: const Text(Strings.shareLocationTitle),
                    subtitle: Text(
                      widget.trackingEnabled
                          ? Strings.shareLocationActiveSubtitle
                          : Strings.shareLocationLockedSubtitle,
                    ),
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

  String _trackingRemainingLabel() {
    if (widget.sessionEndTime == null) return '0m';
    final remaining = widget.sessionEndTime!.difference(DateTime.now());
    if (remaining.isNegative) return '0m';
    if (remaining.inHours >= 1) {
      return '${remaining.inHours}h ${remaining.inMinutes.remainder(60)}m';
    }
    return '${remaining.inMinutes}m';
  }
}

class _DurationControl extends StatelessWidget {
  const _DurationControl({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: onChanged == null ? null : () => onChanged!((value - 1).clamp(0, 24)),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.surfaceVariant,
                foregroundColor: AppColors.textPrimary,
                minimumSize: const Size(44, 44),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
              ),
              child: const Icon(Icons.remove, size: 20),
            ),
            const SizedBox(width: 12),
            Flexible(
              fit: FlexFit.loose,
              child: Slider(
                min: 0,
                max: 24,
                divisions: 24,
                value: value.toDouble(),
                activeColor: AppColors.secondary,
                inactiveColor: AppColors.outline.withAlpha(140),
                onChanged: onChanged == null
                    ? null
                    : (double newValue) => onChanged!(newValue.round()),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onChanged == null ? null : () => onChanged!((value + 1).clamp(0, 24)),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.surfaceVariant,
                foregroundColor: AppColors.textPrimary,
                minimumSize: const Size(44, 44),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
              ),
              child: const Icon(Icons.add, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          Strings.trackingDurationControlHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
