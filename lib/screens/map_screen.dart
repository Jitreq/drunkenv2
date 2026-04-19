import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/profile_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.selectedFriend});

  final Friend? selectedFriend;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  void _showFriendProfile(Friend friend) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileSheet(
        name: friend.name,
        subtitle: '${friend.location} · ${friend.lastSeen}',
        location: friend.location,
        status: friend.sharesLocation
            ? 'Sharing location'
            : 'Location hidden',
        friendsSince: friend.friendsSince,
        email: '${friend.name.toLowerCase()}@example.me',
        avatarColor: AppColors.primaryContainer,
      ),
    );
  }

  void _showUserProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileSheet(
        name: currentUser.name,
        subtitle: currentUser.status,
        location: currentUser.location,
        status: currentUser.status,
        friendsSince: currentUser.friendsSince,
        email: currentUser.email,
        avatarColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedFriend = widget.selectedFriend;
    final hasRoute = selectedFriend != null && selectedFriend.sharesLocation;

    final markers = [
      Marker(
        width: 92,
        height: 96,
        point: LatLng(currentLatitude, currentLongitude),
        builder: (_) => GestureDetector(
          onTap: _showUserProfile,
          child: const _MapPin(label: Strings.youLabel, color: AppColors.success),
        ),
      ),
      ...friends
          .where((friend) => friend.sharesLocation)
          .map(
            (friend) => Marker(
              width: 92,
              height: 96,
              point: LatLng(friend.latitude, friend.longitude),
              builder: (_) => GestureDetector(
                onTap: () => _showFriendProfile(friend),
                child: _MapPin(label: friend.name, color: AppColors.primary),
              ),
            ),
          ),
    ];

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: LatLng(currentLatitude, currentLongitude),
                          zoom: 14,
                          minZoom: 5,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'fi.lappeenranta.drunken_flutter',
                            backgroundColor: const Color(0xFF181E24),
                          ),
                          if (hasRoute)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: [
                                    LatLng(currentLatitude, currentLongitude),
                                    LatLng(
                                      selectedFriend.latitude,
                                      selectedFriend.longitude,
                                    ),
                                  ],
                                  strokeWidth: 4,
                                  color: AppColors.secondary,
                                  isDotted: true,
                                ),
                              ],
                            ),
                          MarkerLayer(markers: markers),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.routeSummaryTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hasRoute
                        ? '${selectedFriend.name} · ${selectedFriend.location} · ${selectedFriend.distance}'
                        : Strings.routeSummaryEmpty,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            _mapController.move(
                              LatLng(currentLatitude, currentLongitude),
                              14,
                            );
                          },
                          child: const Text(Strings.centerLocation),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 130,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: hasRoute ? () {} : null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: BorderSide(
                              color: AppColors.outline.withAlpha(179),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(Strings.clearRoute),
                        ),
                      ),
                    ],
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

class _MapPin extends StatelessWidget {
  const _MapPin({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(90),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(Icons.place, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
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
