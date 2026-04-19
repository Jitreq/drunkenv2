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
  });

  final Friend friend;
  final VoidCallback onShowMap;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    final statusWidget = friend.sharesLocation
        ? _StatusPill(text: Strings.sharingLocation, color: AppColors.success)
        : _StatusPill(text: Strings.hiddenLocation, color: AppColors.outline);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    friend.name.substring(0, 1),
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
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
                        '${friend.location} · ${friend.lastSeen}',
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
            Row(
              children: [
                _ActionButton(
                  label: Strings.callButton,
                  icon: Icons.phone,
                  onPressed: onCall,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  label: Strings.messageButton,
                  icon: Icons.message,
                  onPressed: onMessage,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  label: Strings.mapButton,
                  icon: Icons.map,
                  onPressed: onShowMap,
                ),
              ],
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(43),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
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
    return Expanded(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.surfaceVariant,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
