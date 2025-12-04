class TemplateTextDecorationConfig {

  final int borderRadius;

  /// "RECTANGLE" / "CIRCULAR" / etc.
  final String shape;

  const TemplateTextDecorationConfig({
    required this.borderRadius,
    required this.shape,
  });

  factory TemplateTextDecorationConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TemplateTextDecorationConfig(
        borderRadius: 0,
        shape: "RECTANGLE",
      );
    }

    final rawRadius = json["borderRadius"];

    int parsedRadius;
    if (rawRadius is int) {
      parsedRadius = rawRadius;
    } else if (rawRadius is double) {
      parsedRadius = rawRadius.round();
    } else if (rawRadius is String) {
      parsedRadius = int.tryParse(rawRadius) ?? 0;
    } else {
      parsedRadius = 0;
    }

    return TemplateTextDecorationConfig(
      borderRadius: parsedRadius,
      shape: json["shape"] as String? ?? "RECTANGLE",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "borderRadius": borderRadius,
      "shape": shape,
    };
  }
}
