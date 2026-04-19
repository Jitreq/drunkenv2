import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';

class ProfileSheet extends StatelessWidget {
  const ProfileSheet({
    super.key,
    required this.name,
    required this.subtitle,
    required this.location,
    required this.status,
    required this.friendsSince,
    required this.email,
    required this.avatarColor,
    this.onCall,
    this.onMessage,
    this.onShowOnMap,
    this.actionLabel,
    this.onAction,
  });

  final String name;
  final String subtitle;
  final String location;
  final String status;
  final String friendsSince;
  final String email;
  final Color avatarColor;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  final VoidCallback? onShowOnMap;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.outline.withAlpha(90),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 18),
          CircleAvatar(
            radius: 30,
            backgroundColor: avatarColor,
            child: Text(
              name.substring(0, 1),
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          _ProfileRow(label: 'Location', value: location),
          const SizedBox(height: 10),
          _ProfileRow(label: 'Status', value: status),
          const SizedBox(height: 10),
          _ProfileRow(label: 'Friends since', value: friendsSince),
          const SizedBox(height: 10),
          _ProfileRow(label: 'Email', value: email),
          if (onCall != null || onMessage != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                if (onCall != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCall,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: AppColors.outline),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(Icons.call),
                      label: const Text(Strings.callButtonLabel),
                    ),
                  ),
                if (onCall != null && onMessage != null)
                  const SizedBox(width: 12),
                if (onMessage != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onMessage,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: AppColors.outline),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: const Icon(Icons.message),
                      label: const Text(Strings.dmButton),
                    ),
                  ),
              ],
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.onPrimary,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(actionLabel!),
            ),
          ],
          if (onShowOnMap != null) ...[
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onShowOnMap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.outline),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.location_on),
              label: const Text('Show on map'),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
