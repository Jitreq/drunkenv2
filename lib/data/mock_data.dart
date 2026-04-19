class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class UserProfile {
  final String name;
  final String location;
  final String status;
  final String friendsSince;
  final String email;

  const UserProfile({
    required this.name,
    required this.location,
    required this.status,
    required this.friendsSince,
    required this.email,
  });
}

class Friend {
  final String name;
  final String location;
  final bool sharesLocation;
  final String lastSeen;
  final String distance;
  final double latitude;
  final double longitude;
  final String friendsSince;
  final List<ChatMessage> chatHistory;

  const Friend({
    required this.name,
    required this.location,
    required this.sharesLocation,
    required this.lastSeen,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.friendsSince,
    required this.chatHistory,
  });
}

const currentUser = UserProfile(
  name: 'Juho',
  location: 'Lappeenranta',
  status: 'Sharing location',
  friendsSince: 'Friends since 2022',
  email: 'juho@example.me',
);

const currentLocationName = 'Lappeenranta';
const currentLocationSubtitle = 'Updated 2 min ago';
const currentLatitude = 61.0550;
const currentLongitude = 28.1446;

const friends = [
  Friend(
    name: 'Taneli',
    location: 'Downtown',
    sharesLocation: true,
    lastSeen: '1 min ago',
    distance: '450 m',
    latitude: 61.0570,
    longitude: 28.1490,
    friendsSince: 'Friends since 2023',
    chatHistory: [
      ChatMessage(
        text: 'Hey, are you still in town?',
        isMe: false,
        time: '8:42 PM',
      ),
      ChatMessage(
        text: 'Yes, I am near the downtown square.',
        isMe: true,
        time: '8:44 PM',
      ),
      ChatMessage(
        text: 'Perfect — want to meet by the river?',
        isMe: false,
        time: '8:45 PM',
      ),
    ],
  ),
  Friend(
    name: 'Eeri',
    location: 'Night Bar',
    sharesLocation: false,
    lastSeen: '12 min ago',
    distance: '1.2 km',
    latitude: 61.0520,
    longitude: 28.1420,
    friendsSince: 'Friends since 2021',
    chatHistory: [
      ChatMessage(
        text: 'I just got to the bar, it is packed.',
        isMe: false,
        time: '9:05 PM',
      ),
      ChatMessage(
        text: 'Nice, I am on my way.',
        isMe: true,
        time: '9:06 PM',
      ),
      ChatMessage(
        text: 'Bring some snacks if you can.',
        isMe: false,
        time: '9:08 PM',
      ),
    ],
  ),
  Friend(
    name: 'Allu',
    location: 'Beach',
    sharesLocation: true,
    lastSeen: '3 min ago',
    distance: '820 m',
    latitude: 61.0580,
    longitude: 28.1360,
    friendsSince: 'Friends since 2022',
    chatHistory: [
      ChatMessage(
        text: 'The sunset here is amazing.',
        isMe: false,
        time: '7:54 PM',
      ),
      ChatMessage(
        text: 'I wish I could see it too.',
        isMe: true,
        time: '7:55 PM',
      ),
      ChatMessage(
        text: 'Come over and I will save you a spot.',
        isMe: false,
        time: '7:56 PM',
      ),
    ],
  ),
  Friend(
    name: 'Aleksi',
    location: 'City Park',
    sharesLocation: true,
    lastSeen: '5 min ago',
    distance: '1.0 km',
    latitude: 61.0600,
    longitude: 28.1505,
    friendsSince: 'Friends since 2024',
    chatHistory: [
      ChatMessage(
        text: 'I can meet in 10 minutes.',
        isMe: false,
        time: '9:30 PM',
      ),
      ChatMessage(
        text: 'Sounds good, see you soon.',
        isMe: true,
        time: '9:31 PM',
      ),
      ChatMessage(
        text: 'Bring your jacket, it is chilly.',
        isMe: false,
        time: '9:32 PM',
      ),
    ],
  ),
];
