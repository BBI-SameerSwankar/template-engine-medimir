class TemplateTextDecorationConfig {
  final bool borderRadius;
  final String shape; // "RECTANGLE" / "CIRCULAR" / etc.

  const TemplateTextDecorationConfig({
    required this.borderRadius,
    required this.shape,
  });

  factory TemplateTextDecorationConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TemplateTextDecorationConfig(
        borderRadius: false,
        shape: "RECTANGLE",
      );
    }

    return TemplateTextDecorationConfig(
      borderRadius: json["borderRadius"] as bool? ?? false,
      shape: json["shape"] as String? ?? "RECTANGLE",
    );
  }
}
