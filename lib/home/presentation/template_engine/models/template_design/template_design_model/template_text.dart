import 'device_dimension.dart';
import 'template_edge_insets_config.dart';
import 'template_text_decoration.dart';

class TemplateTextConfig {
  final String id;
  final int maxLines;
  final int xPoint;
  final int yPoint;

  final DeviceDimension? fontSize;
  final String? fontWeight; // "NORMAL" / "BOLD" / etc.

  final DeviceDimension? width;
  final DeviceDimension? height;

  final TemplateEdgeInsetsConfig? padding;
  final TemplateEdgeInsetsConfig? margin;

  final TemplateTextDecorationConfig decoration;

  TemplateTextConfig({
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
  });

  factory TemplateTextConfig.fromJson(Map<String, dynamic> json) {
    DeviceDimension? _maybeDim(String key) {
      final raw = json[key];
      if (raw == null) return null;
      return DeviceDimension.fromJson((raw as Map).cast<String, dynamic>());
    }

    return TemplateTextConfig(
      id: json['id'] as String,
      maxLines: (json['maxlines'] ?? 1) as int,
      xPoint: json['xPoint'] as int,
      yPoint: json['yPoint'] as int,
      fontSize: _maybeDim('fontsize'),
      fontWeight: json['fontWeight'] as String?,
      width: _maybeDim('width'),
      height: _maybeDim('height'),
      padding: json['padding'] != null
          ? TemplateEdgeInsetsConfig.fromJson(
              (json['padding'] as Map).cast<String, dynamic>(),
              isPadding: true,
            )
          : null,
      margin: json['margin'] != null
          ? TemplateEdgeInsetsConfig.fromJson(
              (json['margin'] as Map).cast<String, dynamic>(),
              isPadding: false,
            )
          : null,
      decoration: TemplateTextDecorationConfig.fromJson(
        (json['decoration'] as Map?)?.cast<String, dynamic>(),
      ),
    );
  }
}
