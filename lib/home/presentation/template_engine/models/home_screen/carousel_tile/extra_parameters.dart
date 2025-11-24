class ExtraParameters {
  final int? toolId;
  final int? medicalAreaId;
  final int? newsId;

  const ExtraParameters({
    this.toolId,
    this.medicalAreaId,
    this.newsId,
  });

  factory ExtraParameters.fromJson(Map<String, dynamic> json) {
    return ExtraParameters(
      toolId: json['toolId'] as int?,
      medicalAreaId: json['medicalAreaId'] as int?,
      newsId: json['newId'] as int?,
    );
  }
}