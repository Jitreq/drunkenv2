import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.selectedFriend});

  final Friend? selectedFriend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.mapTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              Strings.mapSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 22),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF181E18), Color(0xFF10140F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.surfaceVariant.withAlpha(36),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    top: 36,
                    child: _MapMarker(
                      label: Strings.youLabel,
                      color: AppColors.secondary,
                    ),
                  ),
                  Positioned(
                    right: 26,
                    top: 86,
                    child: _MapMarker(
                      label: 'Emilia',
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    left: 48,
                    bottom: 90,
                    child: _MapMarker(label: 'Sara', color: AppColors.success),
                  ),
                  Positioned(
                    right: 40,
                    bottom: 120,
                    child: _MapMarker(label: 'Mikko', color: AppColors.outline),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer.withAlpha(230),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        border: Border.all(
                          color: AppColors.outline.withAlpha(77),
                        ),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.routeSummaryTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            selectedFriend != null
                                ? '${Strings.routeSummaryTitle}: ${selectedFriend!.name} (${selectedFriend!.distance})'
                                : Strings.routeSummaryEmpty,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              FilledButton(
                                onPressed: selectedFriend != null
                                    ? () {}
                                    : null,
                                child: const Text(Strings.centerLocation),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: selectedFriend != null
                                    ? () {}
                                    : null,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  side: BorderSide(
                                    color: AppColors.outline.withAlpha(179),
                                  ),
                                  minimumSize: const Size(130, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(Strings.clearRoute),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(89),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(Icons.place, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
