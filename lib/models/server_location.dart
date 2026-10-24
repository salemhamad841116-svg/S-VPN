class ServerLocation {
  final String id;
  final String country;
  final String city;
  final String countryCode;
  final String flagEmoji;
  final int pingMs;
  final String ip;

  const ServerLocation({
    required this.id,
    required this.country,
    required this.city,
    required this.countryCode,
    required this.flagEmoji,
    required this.pingMs,
    required this.ip,
  });

  static const List<ServerLocation> defaultServers = [
    ServerLocation(
      id: 'us-east',
      country: 'United States',
      city: 'New York',
      countryCode: 'US',
      flagEmoji: '🇺🇸',
      pingMs: 24,
      ip: '198.51.100.12',
    ),
    ServerLocation(
      id: 'de-central',
      country: 'Germany',
      city: 'Frankfurt',
      countryCode: 'DE',
      flagEmoji: '🇩🇪',
      pingMs: 38,
      ip: '195.201.88.45',
    ),
    ServerLocation(
      id: 'ae-dubai',
      country: 'United Arab Emirates',
      city: 'Dubai',
      countryCode: 'AE',
      flagEmoji: '🇦🇪',
      pingMs: 18,
      ip: '185.193.64.10',
    ),
    ServerLocation(
      id: 'jp-tokyo',
      country: 'Japan',
      city: 'Tokyo',
      countryCode: 'JP',
      flagEmoji: '🇯🇵',
      pingMs: 64,
      ip: '133.242.18.99',
    ),
    ServerLocation(
      id: 'sg-singapore',
      country: 'Singapore',
      city: 'Singapore',
      countryCode: 'SG',
      flagEmoji: '🇸🇬',
      pingMs: 42,
      ip: '139.180.201.14',
    ),
    ServerLocation(
      id: 'uk-london',
      country: 'United Kingdom',
      city: 'London',
      countryCode: 'GB',
      flagEmoji: '🇬🇧',
      pingMs: 31,
      ip: '51.158.112.3',
    ),
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'country': country,
      'city': city,
      'countryCode': countryCode,
      'pingMs': pingMs,
      'ip': ip,
    };
  }
}
