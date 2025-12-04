import 'dart:convert';

import 'device_dimension.dart';
import 'template_border.dart';
import 'template_image.dart';
import 'template_text.dart';

class TemplateDesignModel {
  final String id;

  final DeviceDimension width;
  final DeviceDimension height;

  final Map<String, TemplateBorderConfig> borders;
  final List<TemplateTextConfig> texts;
  final List<TemplateImageConfig> images;

  TemplateDesignModel({
    required this.id,
    required this.width,
    required this.height,
    required this.borders,
    required this.texts,
    required this.images,
  });

  factory TemplateDesignModel.fromJsonString(String jsonStr) {
    return TemplateDesignModel.fromJson(json.decode(jsonStr));
  }

  factory TemplateDesignModel.fromJson(Map<String, dynamic> json) {
    final bordersJson = (json['borders'] ?? {}) as Map<String, dynamic>;

    final widthJson = json['width'];
    final heightJson = json['height'];

    if (widthJson == null) {
      throw FormatException(
          "TemplateDesignModel: 'width' is required but was null/missing.");
    }
    if (heightJson == null) {
      throw FormatException(
          "TemplateDesignModel: 'height' is required but was null/missing.");
    }

    return TemplateDesignModel(
      id: json['id'] as String,
      width: DeviceDimension.fromJson(widthJson as Map<String, dynamic>),
      height: DeviceDimension.fromJson(heightJson as Map<String, dynamic>),
      borders: bordersJson.map(
        (key, value) => MapEntry(
          key,
          TemplateBorderConfig.fromJson(
            key,
            value as Map<String, dynamic>,
          ),
        ),
      ),
      texts: (json['texts'] as List? ?? [])
          .map((e) => TemplateTextConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List? ?? [])
          .map((e) => TemplateImageConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width.toJson(),
      'height': height.toJson(),
      'borders': borders.map((key, value) => MapEntry(key, value.toJson())),
      'texts': texts.map((e) => e.toJson()).toList(),
      'images': images.map((e) => e.toJson()).toList(),
    };
  }

  String toJsonString() => json.encode(toJson());
}
