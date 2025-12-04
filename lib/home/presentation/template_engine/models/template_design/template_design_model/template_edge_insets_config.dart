import 'device_dimension.dart';

class TemplateEdgeInsetsConfig {
  final DeviceDimension left;
  final DeviceDimension right;
  final DeviceDimension top;
  final DeviceDimension bottom;

  const TemplateEdgeInsetsConfig({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
  });

  factory TemplateEdgeInsetsConfig.fromJson(Map<String, dynamic>? json) {
    DeviceDimension _dim(String key) {
      const fallback = {"phonePortrait": 0, "phoneLandscape": 0};

      final raw = json?[key];
      if (raw is! Map) return DeviceDimension.fromJson(fallback);

      // accept only String keys
      if (raw.keys.any((k) => k is! String)) {
        return DeviceDimension.fromJson(fallback);
      }

      return DeviceDimension.fromJson(raw.cast<String, dynamic>());
    }

    return TemplateEdgeInsetsConfig(
      left: _dim("left"),
      right: _dim("right"),
      top: _dim("top"),
      bottom: _dim("bottom"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "left": left.toJson(),
      "right": right.toJson(),
      "top": top.toJson(),
      "bottom": bottom.toJson(),
    };
  }
}
