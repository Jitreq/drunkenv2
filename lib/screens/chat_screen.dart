import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/app_top_padding.dart';
import '../widgets/profile_sheet.dart';
import '../widgets/xr_app_bar.dart';
import 'call_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
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
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  late final Friend _friend;
  late final List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _friend = friends.firstWhere(
      (friend) => friend.name == widget.friendName,
      orElse: () => friends.first,
    );
    _messages = List<ChatMessage>.from(_friend.chatHistory);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(text: text, isMe: true, time: 'Now'),
      );
      _controller.clear();
    });
  }

  void _showFriendProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileSheet(
        name: _friend.name,
        subtitle: '${_friend.location} · ${_friend.lastSeen}',
        location: _friend.location,
        distance: _friend.distanceLabel(currentLatitude, currentLongitude),
        status: _friend.sharesLocation
            ? 'Sharing location'
            : 'Location hidden',
        friendsSince: _friend.friendsSince,
        email: '${_friend.name.toLowerCase()}@example.me',
        avatarColor: AppColors.primaryContainer,
        onShowOnMap: _friend.sharesLocation
            ? () {
                Navigator.of(context).pop();
                widget.onShowOnMap?.call();
              }
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _trackingRemainingLabel() {
    if (widget.sessionEndTime == null) return '';
    final remaining = widget.sessionEndTime!.difference(DateTime.now());
    if (remaining.isNegative) return '0m';
    if (remaining.inHours >= 1) {
      return '${remaining.inHours}h ${remaining.inMinutes.remainder(60)}m';
    }
    return '${remaining.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return AppTopPadding(
      child: Scaffold(
        appBar: XrAppBar(
        title: '${Strings.chatTitle} · ${widget.friendName}',
        actions: [
          if (widget.trackingEnabled && widget.sessionEndTime != null)
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
                      '${Strings.trackingEndsIn} ${_trackingRemainingLabel()}',
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                Strings.chatSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ChatActionRow(
                onShowOnMap: widget.onShowOnMap,
                onCall: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CallScreen(
                        friendName: widget.friendName,
                        trackingEnabled: widget.trackingEnabled,
                        sessionEndTime: widget.sessionEndTime,
                        onShowOnMap: widget.onShowOnMap,
                      ),
                    ),
                  );
                },
                onProfile: _showFriendProfile,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        color: message.isMe
                            ? AppColors.primaryContainer
                            : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          if (message.isMe)
                            BoxShadow(
                              color: AppColors.primary.withAlpha(0x24),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: message.isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              color: message.isMe
                                  ? AppColors.onPrimary
                                  : AppColors.onSurface,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            message.time,
                            style: TextStyle(
                              color: message.isMe
                                  ? AppColors.onSecondary
                                  : AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: AppColors.onSurface),
                      decoration: InputDecoration(
                        hintText: Strings.messagePlaceholder,
                        hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
                        filled: true,
                        fillColor: AppColors.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _sendMessage,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      minimumSize: const Size(92, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(Strings.sendMessage),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    ); 
  }
}

class _ChatActionRow extends StatelessWidget {
  const _ChatActionRow({
    required this.onShowOnMap,
    required this.onCall,
    required this.onProfile,
  });

  final VoidCallback? onShowOnMap;
  final VoidCallback onCall;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        if (onShowOnMap != null)
          _ChatActionButton(
            icon: Icons.location_on,
            label: Strings.mapButton,
            onPressed: onShowOnMap!,
          ),
        _ChatActionButton(
          icon: Icons.call,
          label: Strings.callButton,
          onPressed: onCall,
        ),
        _ChatActionButton(
          icon: Icons.person,
          label: 'Profile',
          onPressed: onProfile,
        ),
      ],
    );
  }
}

class _ChatActionButton extends StatelessWidget {
  const _ChatActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.surfaceVariant,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }
}
