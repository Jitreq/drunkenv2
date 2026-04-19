import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.friend,
    required this.onShowMap,
    required this.onCall,
    required this.onMessage,
    required this.onProfile,
    this.distanceLabel,
  });

  final Friend friend;
  final VoidCallback onShowMap;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onProfile;
  final String? distanceLabel;

  @override
  Widget build(BuildContext context) {
    final statusWidget = friend.sharesLocation
        ? _StatusPill(text: Strings.sharingLocation, color: AppColors.success)
        : _StatusPill(text: Strings.hiddenLocation, color: AppColors.outline);

    return Card(
      color: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppColors.outline.withAlpha(0x66)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onProfile,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    friend.name.substring(0, 1),
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        distanceLabel != null
                            ? '${friend.location} · ${friend.lastSeen} · $distanceLabel'
                            : '${friend.location} · ${friend.lastSeen}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            statusWidget,
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: constraints.maxWidth,
                      ),
                      child: _ActionButton(
                        label: Strings.callButton,
                        icon: Icons.phone,
                        onPressed: onCall,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: constraints.maxWidth,
                      ),
                      child: _ActionButton(
                        label: Strings.messageButton,
                        icon: Icons.message,
                        onPressed: onMessage,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: constraints.maxWidth,
                      ),
                      child: _ActionButton(
                        label: Strings.mapButton,
                        icon: Icons.map,
                        onPressed: onShowMap,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(0x2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withAlpha(0x4D)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.surfaceVariant,
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
