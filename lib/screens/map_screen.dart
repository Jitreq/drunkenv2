import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/profile_sheet.dart';
import 'call_screen.dart';
import 'chat_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.selectedFriend,
    required this.trackingEnabled,
    required this.ghostModeEnabled,
    required this.onOpenSettings,
    required this.onDisableGhostMode,
    required this.onClearRoute,
    this.onShowFriendOnMap,
  });

  final Friend? selectedFriend;
  final bool trackingEnabled;
  final bool ghostModeEnabled;
  final VoidCallback onOpenSettings;
  final VoidCallback onDisableGhostMode;
  final VoidCallback onClearRoute;
  final ValueChanged<Friend>? onShowFriendOnMap;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  Friend? _trackedFriend;
  double _currentLatitude = currentLatitude;
  double _currentLongitude = currentLongitude;
  late LatLng _mapCenter;
  double _mapZoom = 14;

  Friend? get _activeFriend {
    if (widget.trackingEnabled && _trackedFriend != null) {
      return _trackedFriend;
    }
    return widget.selectedFriend ?? _trackedFriend;
  }

  @override
  void initState() {
    super.initState();
    _mapCenter = LatLng(_currentLatitude, _currentLongitude);
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _mapCenter = LatLng(position.latitude, position.longitude);
      });
    } catch (_) {
      // Fallback to the hard-coded location if GPS is unavailable.
    }
  }

  void _centerOnFriend(Friend friend) {
    final midpoint = LatLng(
      (_currentLatitude + friend.latitude) / 2,
      (_currentLongitude + friend.longitude) / 2,
    );
    _mapController.move(midpoint, 13);
  }

  void _toggleTracking(Friend friend) {
    setState(() {
      if (_trackedFriend == friend) {
        _trackedFriend = null;
      } else {
        _trackedFriend = friend;
      }
    });
  }

  void _clearRoute() {
    setState(() {
      _trackedFriend = null;
    });
    widget.onClearRoute();
  }

  void _showFriendProfile(Friend friend) {
    final tracking = _trackedFriend == friend;
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
        onCall: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CallScreen(
                friendName: friend.name,
                onShowOnMap: friend.sharesLocation
                    ? () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        widget.onShowFriendOnMap?.call(friend);
                      }
                    : null,
              ),
            ),
          );
        },
        onMessage: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                friendName: friend.name,
                onShowOnMap: friend.sharesLocation
                    ? () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        widget.onShowFriendOnMap?.call(friend);
                      }
                    : null,
              ),
            ),
          );
        },
        actionLabel: tracking ? 'Untrack friend' : 'Track friend',
        onAction: () {
          Navigator.of(context).pop();
          _toggleTracking(friend);
        },
        onShowOnMap: friend.sharesLocation
            ? () {
                Navigator.of(context).pop();
                widget.onShowFriendOnMap?.call(friend);
              }
            : null,
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
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trackingEnabled && widget.selectedFriend != null &&
        widget.selectedFriend != oldWidget.selectedFriend) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerOnFriend(widget.selectedFriend!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedFriend = _activeFriend;
    final canShowRoute = selectedFriend != null &&
        selectedFriend.sharesLocation &&
        (widget.trackingEnabled || _trackedFriend != null);

    final markers = [
      Marker(
        width: 92,
        height: 96,
        point: LatLng(_currentLatitude, _currentLongitude),
        builder: (_) => GestureDetector(
          onTap: _showUserProfile,
          child: const _MapPin(label: Strings.youLabel, color: AppColors.success),
        ),
      ),
      ...friends
          .where((friend) => friend.sharesLocation)
          .map(
            (friend) {
              final isTracked = _trackedFriend == friend;
              return Marker(
                width: 92,
                height: 96,
                point: LatLng(friend.latitude, friend.longitude),
                builder: (_) => GestureDetector(
                  onTap: () => _showFriendProfile(friend),
                  child: _MapPin(
                    label: friend.name,
                    color: AppColors.primary,
                    isTracked: isTracked,
                  ),
                ),
              );
            },
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
                          center: _mapCenter,
                          zoom: _mapZoom,
                          minZoom: 5,
                          onPositionChanged: (position, hasGesture) {
                            if (!mounted) return;
                            setState(() {
                              _mapCenter = position.center ?? _mapCenter;
                              _mapZoom = position.zoom ?? _mapZoom;
                            });
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'fi.lappeenranta.drunken_flutter',
                            backgroundColor: const Color(0xFF181E24),
                          ),
                          if (canShowRoute)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: [
                                    LatLng(_currentLatitude, _currentLongitude),
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
                  if (widget.trackingEnabled) ...[
                    Text(
                      Strings.routeSummaryTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      canShowRoute
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
                                LatLng(_currentLatitude, _currentLongitude),
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
                            onPressed: canShowRoute ? _clearRoute : null,
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
                  ] else if (widget.ghostModeEnabled) ...[
                    Text(
                      Strings.ghostModeActiveLabel,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      Strings.ghostModeActiveSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: widget.onDisableGhostMode,
                      child: const Text(Strings.disableGhostModeButton),
                    ),
                  ] else ...[
                    Text(
                      Strings.trackingDisabledLabel,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      Strings.trackingDisabledSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: widget.onOpenSettings,
                      child: const Text(Strings.enableTrackingButton),
                    ),
                  ],
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
  const _MapPin({
    required this.label,
    required this.color,
    this.isTracked = false,
  });

  final String label;
  final Color color;
  final bool isTracked;

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
            border: isTracked
                ? Border.all(
                    color: AppColors.primary,
                    width: 3,
                  )
                : null,
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
