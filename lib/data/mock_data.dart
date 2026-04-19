class Friend {
  final String name;
  final String location;
  final bool sharesLocation;
  final String lastSeen;
  final String distance;

  const Friend({
    required this.name,
    required this.location,
    required this.sharesLocation,
    required this.lastSeen,
    required this.distance,
  });
}

const currentLocationName = 'Central Station';
const currentLocationSubtitle = 'Updated 2 min ago';

const friends = [
  Friend(
    name: 'Emilia',
    location: 'Downtown',
    sharesLocation: true,
    lastSeen: '1 min ago',
    distance: '450 m',
  ),
  Friend(
    name: 'Mikko',
    location: 'Night Bar',
    sharesLocation: false,
    lastSeen: '12 min ago',
    distance: '1.2 km',
  ),
  Friend(
    name: 'Sara',
    location: 'Beach',
    sharesLocation: true,
    lastSeen: '3 min ago',
    distance: '820 m',
  ),
];
