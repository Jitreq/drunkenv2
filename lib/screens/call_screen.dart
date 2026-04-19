import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../widgets/app_top_padding.dart';
import '../widgets/xr_app_bar.dart';
import 'chat_screen.dart';

String _trackingRemainingLabel(DateTime? sessionEndTime) {
  if (sessionEndTime == null) return '';
  final remaining = sessionEndTime.difference(DateTime.now());
  if (remaining.isNegative) return '0m';
  if (remaining.inHours >= 1) {
    return '${remaining.inHours}h ${remaining.inMinutes.remainder(60)}m';
  }
  return '${remaining.inMinutes}m';
}

class CallScreen extends StatelessWidget {
  const CallScreen({
    super.key,
    required this.friendName,
    required this.trackingEnabled,
    required this.sessionEndTime,
    this.onShowOnMap,
  });

  final String friendName;
  final bool trackingEnabled;
  final DateTime? sessionEndTime;
  final VoidCallback? onShowOnMap;

  @override
  Widget build(BuildContext context) {
    return AppTopPadding(
      child: Scaffold(
        appBar: XrAppBar(
          title: Strings.callTitle,
          leading: Icons.arrow_back_ios_new,
          leadingTap: () => Navigator.of(context).pop(),
          actions: [
            if (trackingEnabled && sessionEndTime != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer.withValues(alpha: 0xE6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        '${Strings.trackingEndsIn} ${_trackingRemainingLabel(sessionEndTime)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          Strings.callSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        _CallHeaderActions(
                          onShowOnMap: onShowOnMap,
                          onMessage: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  friendName: friendName,
                                  trackingEnabled: trackingEnabled,
                                  sessionEndTime: sessionEndTime,
                                  onShowOnMap: onShowOnMap,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.primary.withAlpha(71),
                                    Colors.transparent,
                                  ],
                                  stops: const [0, 0.9],
                                ),
                              ),
                            ),
                            Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(56),
                                    blurRadius: 32,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  friendName.substring(0, 1),
                                  style: const TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          friendName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${Strings.callingLabel} $friendName...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _CallAction(
                              icon: Icons.mic_off,
                              label: 'Mute',
                            ),
                            _CallAction(
                              icon: Icons.dialpad,
                              label: 'Keypad',
                            ),
                            _CallAction(
                              icon: Icons.volume_up,
                              label: 'Speaker',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.onError,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(Strings.endCall),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _CallHeaderActions extends StatelessWidget {
  const _CallHeaderActions({
    required this.onShowOnMap,
    required this.onMessage,
  });

  final VoidCallback? onShowOnMap;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        if (onShowOnMap != null)
          FilledButton.icon(
            onPressed: onShowOnMap,
            icon: const Icon(Icons.location_on, size: 18),
            label: const Text(Strings.mapButton),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.surfaceVariant,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
        FilledButton.icon(
          onPressed: onMessage,
          icon: const Icon(Icons.message, size: 18),
          label: const Text(Strings.messageButton),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.surfaceVariant,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
      ],
    );
  }
}

class _CallAction extends StatelessWidget {
  const _CallAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(0x2E),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.onSurface, size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
