/// Notification channel for fund subscriptions
enum NotificationChannel {
  email,
  sms;

  String get label => switch (this) {
    NotificationChannel.email => 'Email',
    NotificationChannel.sms => 'SMS',
  };
}
