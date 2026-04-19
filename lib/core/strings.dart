class Strings {
  Strings._();

  static const appTitle = 'Drunken Friend Tracker';

  static const loginWelcome = 'Welcome back';
  static const loginSubtitle = 'Sign in to access your friend map.';
  static const emailLabel = 'Email';
  static const emailHint = 'name@example.com';
  static const passwordLabel = 'Password';
  static const passwordHint = '••••••••';
  static const loginButton = 'Sign in';
  static const tryOffline = 'Try without signing in';
  static const loginError = 'Check email and password.';

  static const homeTitle = 'Home';
  static const homeSubtitle = 'Track friends and stay aware of locations.';
  static const locationTitle = 'Your location';
  static const friendsTitle = 'Friends';
  static String friendsCount(int count) => '$count friends';
  static const friendsSubtitle =
      'Here are your friends and their latest locations.';

  static const settingsTitle = 'Settings';
  static const settingsSubtitle = 'Manage account settings and privacy.';
  static const profileName = 'Juho';
  static const profileStatus = 'Sharing location';
  static const profileLocationTitle = 'Lappeenranta';
  static const profileFriendsSince = 'Friends since';
  static const profileEmail = 'juho@example.me';
  static const shareLocationTitle = 'Share location';
  static const shareLocationSubtitle = 'Allow friends to see your location.';
  static const visibleToFriendsTitle = 'Visible to friends';
  static const visibleToFriendsSubtitle = 'Show your profile on friends list.';
  static const generalTitle = 'General';
  static const locationSharing = 'Location sharing';
  static const locationSharingSubtitle =
      'Share your current location with friends.';
  static const notifications = 'Notifications';
  static const notificationsSubtitle = 'Receive alerts about friend activity.';  static const trackingDurationTitle = 'Tracking session';
  static const trackingDurationSubtitle =
      'Choose how long the app may keep the tracking session active.';
  static const trackingDurationControlHint =
      'Drag to adjust how many hours to keep the session running.';
  static const startTrackingButton = 'Start tracking';
  static const stopSharingButton = 'Stop sharing';
  static const trackingActiveLabel = 'Tracking active';
  static const shareLocationActiveSubtitle =
      'Your location is visible to friends while tracking is active.';
  static const shareLocationLockedLabel = 'Location sharing locked';
  static const shareLocationLockedSubtitle =
      'Location sharing is locked until a session is started.';
  static const trackingEndsIn = 'Ends in';
  static const enableTrackingButton = 'Enable tracking';
  static const trackingDisabledLabel = 'Tracking disabled';
  static const trackingDisabledSubtitle = 'Enable tracking in Settings to follow friends.';
  static const dmButton = 'Message';
  static const callButtonLabel = 'Call';  static const logoutButton = 'Sign out';

  static const mapTitle = 'Map';
  static const mapSubtitle = 'Live map of your location and friends.';
  static const routeSummaryTitle = 'Route summary';
  static const routeSummaryEmpty =
      'Select a friend from Home to view a route.';
  static const routeSummaryLoading =
      'Requesting walking route from Valhalla...';
  static const youLabel = 'You';
  static const centerLocation = 'Center location';
  static const clearRoute = 'Clear route';

  static const callTitle = 'Call';
  static const callSubtitle = 'Calling your friend.';
  static const callingLabel = 'Calling';
  static const endCall = 'End call';

  static const chatTitle = 'Messages';
  static const chatSubtitle = 'Send a quick message to your friend.';
  static const messagePlaceholder = 'Write a message...';
  static const sendMessage = 'Send';

  static const callButton = 'Call';
  static const messageButton = 'Message';
  static const mapButton = 'Map';
  static const sharingLocation = 'Sharing location';
  static const hiddenLocation = 'Hidden';
  static const gpsStatusTitle = 'GPS status';
  static const gpsWorking = 'GPS working';
  static const gpsFallback = 'Fallback active';
}
