// lib/models/template_design/template_image.dart
import 'device_dimension.dart';
import 'template_edge_insets_config.dart';

class TemplateImageConfig {
  final String id;
  final int xPoint;
  final int yPoint;

  final DeviceDimension width;
  final DeviceDimension height;

  final TemplateEdgeInsetsConfig margin;

  /// NEW: horizontal alignment inside the tile: LEFT / CENTER / RIGHT
  final String? horizontalAlign;

  const TemplateImageConfig({
    required this.id,
    required this.xPoint,
    required this.yPoint,
    required this.width,
    required this.height,
    required this.margin,
    this.horizontalAlign,
  });

  factory TemplateImageConfig.fromJson(Map<String, dynamic> json) {
    const dimFallback = {
      "phonePortrait": 0,
      "phoneLandscape": 0,
    };

    DeviceDimension _dim(String key) {
      final raw = json[key];
      if (raw is! Map) return DeviceDimension.fromJson(dimFallback);

      if (raw.keys.any((k) => k is! String)) {
        return DeviceDimension.fromJson(dimFallback);
      }

      return DeviceDimension.fromJson(raw.cast<String, dynamic>());
    }

    TemplateEdgeInsetsConfig _margin() {
      final raw = json['margin'];

      if (raw is! Map) {
        return TemplateEdgeInsetsConfig.fromJson(null);
      }

      if (raw.keys.any((k) => k is! String)) {
        return TemplateEdgeInsetsConfig.fromJson(null);
      }

      return TemplateEdgeInsetsConfig.fromJson(
        raw.cast<String, dynamic>(),
      );
    }

    return TemplateImageConfig(
      id: json['id'] as String? ?? '',
      xPoint: json['xPoint'] as int? ?? 0,
      yPoint: json['yPoint'] as int? ?? 0,
      width: _dim('width'),
      height: _dim('height'),
      margin: _margin(),
      horizontalAlign: json['horizontalAlign'] as String?, // NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'xPoint': xPoint,
      'yPoint': yPoint,
      'width': width.toJson(),
      'height': height.toJson(),
      'margin': {
        'left': margin.left.toJson(),
        'right': margin.right.toJson(),
        'top': margin.top.toJson(),
        'bottom': margin.bottom.toJson(),
      },
      'horizontalAlign': horizontalAlign,
    };
  }
}
