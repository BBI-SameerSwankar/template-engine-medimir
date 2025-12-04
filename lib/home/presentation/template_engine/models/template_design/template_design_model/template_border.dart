import 'device_dimension.dart';

class TemplateBorderConfig {

  final String id;
  final String color;
  final DeviceDimension thickness;

  const TemplateBorderConfig({
    required this.id,
    required this.color,
    required this.thickness,
  });
  
  
  static const String defaultColorHex = '#DDDDDD';
  static const DeviceDimension defaultThickness = DeviceDimension(
    phonePortrait: 1,
    phoneLandscape: 1,
    phoneLandingPortrait: 1,
    phoneLandingLandscape: 1,
    tabPortrait: 1,
    tabLandscape: 1,
    tabLandingPortrait: 1,
    tabLandingLandscape: 1,
  );



  factory TemplateBorderConfig.fromJson(
    String id,
    Map<String, dynamic> json,
  ) {
    final rawColor = json['color'] as String?;
    final color = (rawColor == null || rawColor.isEmpty) ? defaultColorHex : rawColor;

    final thicknessJson = json['thickness'] as Map<String, dynamic>?;
    final thickness = thicknessJson != null
        ? DeviceDimension.fromJson(thicknessJson)
        : defaultThickness;



    return TemplateBorderConfig(
      id: id,
      color: color,
      thickness: thickness,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'thickness': thickness.toJson(),
    };
  }
}
