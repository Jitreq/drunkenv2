import 'dart:math' as math;

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
  final double latitude;
  final double longitude;
  final String friendsSince;
  final List<ChatMessage> chatHistory;

  const Friend({
    required this.name,
    required this.location,
    required this.sharesLocation,
    required this.lastSeen,
    required this.latitude,
    required this.longitude,
    required this.friendsSince,
    required this.chatHistory,
  });

  double distanceTo(double fromLatitude, double fromLongitude) {
    const earthRadiusKm = 6371.0;
    final lat1 = fromLatitude * math.pi / 180;
    final lon1 = fromLongitude * math.pi / 180;
    final lat2 = latitude * math.pi / 180;
    final lon2 = longitude * math.pi / 180;
    final dlat = lat2 - lat1;
    final dlon = lon2 - lon1;
    final a = math.sin(dlat / 2) * math.sin(dlat / 2) +
        math.cos(lat1) * math.cos(lat2) *
        math.sin(dlon / 2) * math.sin(dlon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  String distanceLabel(double fromLatitude, double fromLongitude) {
    final km = distanceTo(fromLatitude, fromLongitude);
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }
}

const currentUser = UserProfile(
  name: 'Juho',
  location: 'Las Palmas',
  status: 'Sharing location',
  friendsSince: 'Friends since 2022',
  email: 'juho@example.me',
);

const currentLocationName = 'Las Palmas';
const currentLocationSubtitle = 'Updated 2 min ago';
const currentLatitude = 61.058079167427785;
const currentLongitude = 28.185507164175075;

const friends = [
  Friend(
    name: 'Taneli',
    location: 'Cluster Ry Kiltahuone',
    sharesLocation: true,
    lastSeen: '1 min ago',
    latitude: 61.063987899910224,
    longitude: 28.095343057853643,
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
    location: 'G Bar',
    sharesLocation: false,
    lastSeen: '12 min ago',
    latitude: 61.06324558392994,
    longitude: 28.096206729146804,
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
    location: '?',
    sharesLocation: true,
    lastSeen: '3 min ago',
    latitude: 61.06315993096796,
    longitude: 28.0982559367974,
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
    location: 'Vierula',
    sharesLocation: true,
    lastSeen: '5 min ago',
    latitude: 61.06471458205442,
    longitude: 28.099358095710734,
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
