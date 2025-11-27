// lib/models/template_design/device_dimension.dart
class DeviceDimension {
  final num phonePortrait;
  final num phoneLandscape;
  final num? phoneLandingPortrait;
  final num? phoneLandingLandscape;
  final num? tabPortrait;
  final num? tabLandscape;
  final num? tabLandingPortrait;
  final num? tabLandingLandscape;

  const DeviceDimension({
    required this.phonePortrait,
    required this.phoneLandscape,
    this.phoneLandingPortrait,
    this.phoneLandingLandscape,
    this.tabPortrait,
    this.tabLandscape,
    this.tabLandingPortrait,
    this.tabLandingLandscape,
  });

  factory DeviceDimension.fromJson(Map<String, dynamic> json) {
    return DeviceDimension(
      phonePortrait: json['phonePortrait'] as num,
      phoneLandscape: json['phoneLandscape'] ?? 0,
      phoneLandingPortrait: json['phoneLandingPortrait'] as num?,
      phoneLandingLandscape: json['phoneLandingLandscape'] as num?,
      tabPortrait: json['tabPortrait'] as num?,
      tabLandscape: json['tabLandscape'] as num?,
      tabLandingPortrait: json['tabLandingPortrait'] as num?,
      tabLandingLandscape: json['tabLandingLandscape'] as num?,
    );
  }

  Map<String, num> toJson() {
    final map = <String, num>{
      'phonePortrait': phonePortrait,
      'phoneLandscape': phoneLandscape ?? 0,
    };

    if (phoneLandingPortrait != null) {
      map['phoneLandingPortrait'] = phoneLandingPortrait as num;
    }
    if (phoneLandingLandscape != null) {
      map['phoneLandingLandscape'] = phoneLandingLandscape as num;
    }
    if (tabPortrait != null) {
      map['tabPortrait'] = tabPortrait as num;
    }
    if (tabLandscape != null) {
      map['tabLandscape'] = tabLandscape as num;
    }
    if (tabLandingPortrait != null) {
      map['tabLandingPortrait'] = tabLandingPortrait as num;
    }
    if (tabLandingLandscape != null) {
      map['tabLandingLandscape'] = tabLandingLandscape as num;
    }

    return map;
  }
}
