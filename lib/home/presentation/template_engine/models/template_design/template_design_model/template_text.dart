import 'device_dimension.dart';
import 'template_edge_insets_config.dart';
import 'template_text_decoration.dart';

class TemplateTextConfig {
  final String id;
  final int maxLines;
  final int xPoint;
  final int yPoint;

  final DeviceDimension fontSize;
  final String? fontWeight;

  final DeviceDimension width;
  final DeviceDimension height;

  final TemplateEdgeInsetsConfig padding;
  final TemplateEdgeInsetsConfig margin;

  final TemplateTextDecorationConfig? decoration;

  final String? textAlignRaw;

  const TemplateTextConfig({
    required this.id,
    required this.maxLines,
    required this.xPoint,
    required this.yPoint,
    required this.fontSize,
    required this.fontWeight,
    required this.width,
    required this.height,
    required this.padding,
    required this.margin,
    required this.decoration,
    this.textAlignRaw,
  });

  factory TemplateTextConfig.fromJson(Map<String, dynamic> json) {
    // Generic fallback for dimensions (width/height/etc.)
    const dimFallback = {"phonePortrait": 0, "phoneLandscape": 0};

    // Specific fallback only for fontSize
    const fontSizeFallback = {"phonePortrait": 14, "phoneLandscape": 14};

    // Specific fallback only for insets such as padding/margin
    final insetsFallback = TemplateEdgeInsetsConfig(
      left: DeviceDimension.fromJson(dimFallback),
      right: DeviceDimension.fromJson(dimFallback),
      top: DeviceDimension.fromJson(dimFallback),
      bottom: DeviceDimension.fromJson(dimFallback),
    );

    DeviceDimension _dim(
      String key, {
      Map<String, dynamic> fallback = dimFallback,
    }) {
      final raw = json[key];

      // NOT a map → use fallback
      if (raw is! Map) return DeviceDimension.fromJson(fallback);

      // EMPTY map → use fallback
      if (raw.isEmpty) return DeviceDimension.fromJson(fallback);

      // Invalid keys → use fallback
      if (raw.keys.any((k) => k is! String)) {
        return DeviceDimension.fromJson(fallback);
      }

      return DeviceDimension.fromJson(raw.cast<String, dynamic>());
    }

    TemplateEdgeInsetsConfig _insets(String key) {
      final raw = json[key];
      if (raw is! Map) return insetsFallback;

      if (raw.keys.any((k) => k is! String)) return insetsFallback;

      return TemplateEdgeInsetsConfig.fromJson(raw.cast<String, dynamic>());
    }

    TemplateTextDecorationConfig? _decoration() {
      final raw = json['decoration'];
      if (raw is! Map) return null;
      if (raw.keys.any((k) => k is! String)) return null;

      return TemplateTextDecorationConfig.fromJson(raw.cast<String, dynamic>());
    }

    return TemplateTextConfig(
      id: (json['id'] ?? '') as String,
      maxLines: (json['maxlines'] ?? 1) as int,
      xPoint: (json['xPoint'] ?? 0) as int, 
      yPoint: (json['yPoint'] ?? 0) as int,

      fontSize: _dim('fontsize', fallback: fontSizeFallback),
      fontWeight: json['fontWeight'] as String?,

      width: _dim('width'),
      height: _dim('height'),

      padding: _insets('padding'),
      margin: _insets('margin'),

      decoration: _decoration(),

      textAlignRaw: json['textAlign'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "maxlines": maxLines,
      "xPoint": xPoint,
      "yPoint": yPoint,
      "fontsize": fontSize.toJson(),
      "fontWeight": fontWeight,
      "width": width.toJson(),
      "height": height.toJson(),
      "padding": {
        "left": padding.left.toJson(),
        "right": padding.right.toJson(),
        "top": padding.top.toJson(),
        "bottom": padding.bottom.toJson(),
      },
      "margin": {
        "left": margin.left.toJson(),
        "right": margin.right.toJson(),
        "top": margin.top.toJson(),
        "bottom": margin.bottom.toJson(),
      },
      "decoration": decoration?.toJson(),
      "textAlign": textAlignRaw,
    };
  }
}
