import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../data/mock_data.dart';
import '../widgets/friend_card.dart';
import '../widgets/profile_sheet.dart';
import '../core/theme/app_colors.dart';
import 'call_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.trackedFriend,
    required this.onShowFriendOnMap,
    required this.onTrackFriend,
    required this.trackingEnabled,
    required this.sessionEndTime,
  });

  final Friend? trackedFriend;
  final ValueChanged<Friend> onShowFriendOnMap;
  final ValueChanged<Friend> onTrackFriend;
  final bool trackingEnabled;
  final DateTime? sessionEndTime;

  void _showFriendProfile(BuildContext context, Friend friend) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileSheet(
        name: friend.name,
        subtitle: '${friend.location} · ${friend.lastSeen}',
        location: friend.location,
        distance: friend.distanceLabel(currentLatitude, currentLongitude),
        status: friend.sharesLocation
            ? 'Sharing location'
            : 'Location hidden',
        friendsSince: friend.friendsSince,
        email: '${friend.name.toLowerCase()}@example.me',
        avatarColor: AppColors.primaryContainer,
        actionLabel: trackedFriend == friend ? 'Untrack friend' : 'Track friend',
        onAction: () {
          Navigator.of(context).pop();
          onTrackFriend(friend);
        },
        onShowOnMap: friend.sharesLocation
            ? () {
                Navigator.of(context).pop();
                onShowFriendOnMap(friend);
              }
            : null,
      ),
    );
  }

  void _showUserProfile(BuildContext context) {
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.friendsTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              Strings.homeSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => _showUserProfile(context),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(0x40),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.onPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.locationTitle,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentLocationName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentLocationSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.friendsTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  Strings.friendsCount(friends.length),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              Strings.friendsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: friends.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final friend = friends[index];
                final distanceLabel = friend.distanceLabel(currentLatitude, currentLongitude);
                return FriendCard(
                  friend: friend,
                  distanceLabel: distanceLabel,
                  onShowMap: () => onShowFriendOnMap(friend),
                  onCall: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CallScreen(
                        friendName: friend.name,
                        trackingEnabled: trackingEnabled,
                        sessionEndTime: sessionEndTime,
                        onShowOnMap: () {
                          onShowFriendOnMap(friend);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ),
                  ),
                  onMessage: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        friendName: friend.name,
                        trackingEnabled: trackingEnabled,
                        sessionEndTime: sessionEndTime,
                        onShowOnMap: () {
                          onShowFriendOnMap(friend);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ),
                  ),
                  onProfile: () => _showFriendProfile(context, friend),
                );
              },
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
