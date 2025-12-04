class DeviceDimension {
  final num phonePortrait;
  final num phoneLandscape;
  final num phoneLandingPortrait;
  final num phoneLandingLandscape;
  final num tabPortrait;
  final num tabLandscape;
  final num tabLandingPortrait;
  final num tabLandingLandscape;

  const DeviceDimension({
    required this.phonePortrait,
    required this.phoneLandscape,
    required this.phoneLandingPortrait,
    required this.phoneLandingLandscape,
    required this.tabPortrait,
    required this.tabLandscape,
    required this.tabLandingPortrait,
    required this.tabLandingLandscape,
  });

  factory DeviceDimension.fromJson(Map<String, dynamic> json) {
    
    // phone defaults
    final phonePortrait = json['phonePortrait'] as num;
    final phoneLandscape = (json['phoneLandscape'] as num?) ?? phonePortrait;
    // tab defaults
    final tabPortrait = (json['tabPortrait'] as num?) ?? phonePortrait;
    final tabLandscape = (json['tabLandscape'] as num?) ?? phoneLandscape;

    return DeviceDimension(
      phonePortrait: phonePortrait,
      phoneLandscape: phoneLandscape,

      phoneLandingPortrait:  (json['phoneLandingPortrait'] as num?) ?? phonePortrait,
      phoneLandingLandscape: (json['phoneLandingLandscape'] as num?) ?? phoneLandscape,

      tabPortrait: tabPortrait,
      tabLandscape: tabLandscape,

      tabLandingPortrait:  (json['tabLandingPortrait'] as num?) ?? tabPortrait,
      tabLandingLandscape: (json['tabLandingLandscape'] as num?) ?? tabLandscape,
    );
  }

  Map<String, num> toJson() {
    return {
      'phonePortrait': phonePortrait,
      'phoneLandscape': phoneLandscape,
      'phoneLandingPortrait': phoneLandingPortrait,
      'phoneLandingLandscape': phoneLandingLandscape,
      'tabPortrait': tabPortrait,
      'tabLandscape': tabLandscape,
      'tabLandingPortrait': tabLandingPortrait,
      'tabLandingLandscape': tabLandingLandscape,
    };
  }
}
