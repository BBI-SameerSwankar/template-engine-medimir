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

  factory TemplateEdgeInsetsConfig.fromJson(Map<String, dynamic>? json,
      {required bool isPadding}) {
    // padding uses nested keys: paddingLeft, paddingRight, ...
    // margin uses nested keys: marginLeft, marginRight, ...
    final prefix = isPadding ? "padding" : "margin";

    DeviceDimension _dim(String key) {
      final map = (json?[key] as Map?)?.cast<String, dynamic>() ?? {
        "phonePortrait": 0,
        "phoneLandscape": 0,
      };
      return DeviceDimension.fromJson(map);
    }

    return TemplateEdgeInsetsConfig(
      left: _dim("${prefix}Left"),
      right: _dim("${prefix}Right"),
      top: _dim("${prefix}Top"),
      bottom: _dim("${prefix}Bottom"),
    );
  }
}
