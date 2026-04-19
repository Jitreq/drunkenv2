import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/profile_sheet.dart';

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
    this.onTrackFriend,
    this.trackedFriend,
    this.onGpsStatusChanged,
  });

  final Friend? selectedFriend;
  final Friend? trackedFriend;
  final bool trackingEnabled;
  final bool ghostModeEnabled;
  final VoidCallback onOpenSettings;
  final VoidCallback onDisableGhostMode;
  final VoidCallback onClearRoute;
  final ValueChanged<Friend>? onShowFriendOnMap;
  final ValueChanged<Friend>? onTrackFriend;
  final ValueChanged<bool>? onGpsStatusChanged;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  double _currentLatitude = currentLatitude;
  double _currentLongitude = currentLongitude;
  late LatLng _mapCenter;
  double _mapZoom = 14;

  Friend? get _activeFriend {
    if (widget.trackingEnabled && widget.trackedFriend != null) {
      return widget.trackedFriend;
    }
    return widget.selectedFriend ?? widget.trackedFriend;
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
        widget.onGpsStatusChanged?.call(false);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        widget.onGpsStatusChanged?.call(false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      widget.onGpsStatusChanged?.call(true);
      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _mapCenter = LatLng(position.latitude, position.longitude);
      });
    } catch (_) {
      widget.onGpsStatusChanged?.call(false);
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

  void _clearRoute() {
    widget.onClearRoute();
  }

  void _toggleTracking(Friend friend) {
    widget.onTrackFriend?.call(friend);
  }

  void _showFriendProfile(Friend friend) {
    final tracking = widget.trackedFriend == friend;
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
        (widget.trackingEnabled || widget.trackedFriend != null);

    final markers = [
      Marker(
        width: 92,
        height: 96,
        point: LatLng(_currentLatitude, _currentLongitude),
        builder: (_) => const _MapPin(label: Strings.youLabel, color: AppColors.success),
      ),
      ...friends
          .where((friend) => friend.sharesLocation)
          .map(
            (friend) {
              final isTracked = widget.trackedFriend == friend;
              return Marker(
                width: 92,
                height: 96,
                point: LatLng(friend.latitude, friend.longitude),
                builder: (_) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
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
                      child: Stack(
                        children: [
                          FlutterMap(
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
                                userAgentPackageName:
                                    'fi.lappeenranta.drunken_flutter',
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
                          Positioned(
                            right: 16,
                            top: constraints.maxHeight * 0.18,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _MapControlButton(
                                  icon: Icons.my_location,
                                  label: Strings.centerLocation,
                                  onPressed: () {
                                    _mapController.move(
                                      LatLng(_currentLatitude, _currentLongitude),
                                      14,
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),
                                _MapControlButton(
                                  icon: Icons.zoom_in,
                                  label: '+',
                                  onPressed: () {
                                    setState(() {
                                      _mapZoom = (_mapZoom + 1).clamp(5, 18);
                                      _mapController.move(_mapCenter, _mapZoom);
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                _MapControlButton(
                                  icon: Icons.zoom_out,
                                  label: '-',
                                  onPressed: () {
                                    setState(() {
                                      _mapZoom = (_mapZoom - 1).clamp(5, 18);
                                      _mapController.move(_mapCenter, _mapZoom);
                                    });
                                  },
                                ),
                                if (canShowRoute) ...[
                                  const SizedBox(height: 12),
                                  _MapControlButton(
                                    icon: Icons.clear,
                                    label: Strings.clearRoute,
                                    onPressed: _clearRoute,
                                  ),
                                ],
                              ],
                            ),
                          ),
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

class _MapPin extends StatefulWidget {
  const _MapPin({
    required this.label,
    required this.color,
    this.isTracked = false,
  });

  final String label;
  final Color color;
  final bool isTracked;

  @override
  State<_MapPin> createState() => _MapPinState();
}

class _MapPinState extends State<_MapPin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
    if (widget.isTracked) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _MapPin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTracked && !oldWidget.isTracked) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isTracked && oldWidget.isTracked) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isTracked)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  final scale = 1.0 + _pulseAnimation.value * 0.18;
                  final alpha = (0.4 - _pulseAnimation.value * 0.2).clamp(0.0, 1.0);
                  return Container(
                    width: 44 * scale,
                    height: 44 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withAlpha((alpha * 255).round()),
                    ),
                  );
                },
              ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                border: widget.isTracked
                    ? Border.all(
                        color: AppColors.secondary,
                        width: 3,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withAlpha(90),
                    blurRadius: widget.isTracked ? 18 : 12,
                    spreadRadius: widget.isTracked ? 2 : 0,
                  ),
                ],
              ),
              child: const Icon(Icons.place, color: Colors.white, size: 24),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            widget.label,
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

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.surfaceContainer,
          foregroundColor: AppColors.textPrimary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: icon == Icons.my_location
            ? const Icon(Icons.my_location)
            : Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
