// lib/models/template_design/template_image.dart
import 'device_dimension.dart';
import 'template_edge_insets_config.dart';

class TemplateImageConfig {
  final String id;
  final int xPoint;
  final int yPoint;
  final DeviceDimension? width;
  final DeviceDimension? height;
  final TemplateEdgeInsetsConfig? margin;

  TemplateImageConfig({
    required this.id,
    required this.xPoint,
    required this.yPoint,
    required this.width,
    required this.height,
    required this.margin,
  });

  factory TemplateImageConfig.fromJson(Map<String, dynamic> json) {
    DeviceDimension? _maybeDim(String key) {
      final raw = json[key];
      if (raw == null) return null;
      return DeviceDimension.fromJson((raw as Map).cast<String, dynamic>());
    }

    return TemplateImageConfig(
      id: json['id'] as String,
      xPoint: json['xPoint'] as int,
      yPoint: json['yPoint'] as int,
      width: _maybeDim('width'),
      height: _maybeDim('height'),
      margin: json['margin'] != null
          ? TemplateEdgeInsetsConfig.fromJson(
              (json['margin'] as Map).cast<String, dynamic>(),
              isPadding: false, // margin block uses marginLeft/... keys
            )
          : null,
    );
  }
}
