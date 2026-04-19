import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../data/mock_data.dart';
import '../widgets/friend_card.dart';
import '../widgets/profile_sheet.dart';
import '../core/theme/app_colors.dart';
import 'call_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onShowFriendOnMap});

  final ValueChanged<Friend> onShowFriendOnMap;

  void _showFriendProfile(BuildContext context, Friend friend) {
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
              Strings.homeTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              Strings.homeSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showUserProfile(context),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
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
                return FriendCard(
                  friend: friend,
                  onShowMap: () => onShowFriendOnMap(friend),
                  onCall: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CallScreen(friendName: friend.name),
                    ),
                  ),
                  onMessage: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(friendName: friend.name),
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
