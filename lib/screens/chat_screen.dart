import 'package:flutter/material.dart';

import '../core/strings.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../widgets/profile_sheet.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.friendName});

  final String friendName;

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
        status: _friend.sharesLocation
            ? 'Sharing location'
            : 'Location hidden',
        friendsSince: _friend.friendsSince,
        email: '${_friend.name.toLowerCase()}@example.me',
        avatarColor: AppColors.primaryContainer,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${Strings.chatTitle} · ${widget.friendName}'),
        backgroundColor: AppColors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showFriendProfile,
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
                        horizontal: 16,
                        vertical: 14,
                      ),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: message.isMe
                            ? AppColors.primary
                            : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(
                              message.isMe ? 18 : 4),
                          bottomRight: Radius.circular(
                              message.isMe ? 4 : 18),
                        ),
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
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            message.time,
                            style: TextStyle(
                              color: AppColors.textSecondary,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: Strings.messagePlaceholder,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: _sendMessage,
                    child: const Text(Strings.sendMessage),
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
