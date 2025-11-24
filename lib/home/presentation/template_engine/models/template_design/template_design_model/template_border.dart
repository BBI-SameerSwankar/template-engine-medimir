// lib/home/presentation/template_engine/models/template_design/template_design_model/template_border.dart
import 'device_dimension.dart';

class TemplateBorderConfig {
  final String id;
  final String? color;
  final DeviceDimension thickness;

  TemplateBorderConfig({
    required this.id,
    required this.color,
    required this.thickness,
  });

  factory TemplateBorderConfig.fromJson(String id, Map<String, dynamic> json) {
    // Copy the JSON and remove non-dimension keys (currently only 'color')
    final dimJson = Map<String, dynamic>.from(json);
    dimJson.remove('color');

    return TemplateBorderConfig(
      id: id,
      color: json['color'] as String?,
      thickness: DeviceDimension.fromJson(dimJson),
    );
  }
}
