import 'dart:convert';

import 'device_dimension.dart';
import 'template_border.dart';
import 'template_image.dart';
import 'template_text.dart';


class TemplateDesignModel {
  final String id;
  final DeviceDimension? width;
  final DeviceDimension? height;
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
    final bordersJson =
        (json['borders'] ?? {}) as Map<String, dynamic>;

    return TemplateDesignModel(
      id: json['id'] as String,
      width: json['width'] != null
          ? DeviceDimension.fromJson(
              json['width'] as Map<String, dynamic>,
            )
          : null,
      height: json['height'] != null
          ? DeviceDimension.fromJson(
              json['height'] as Map<String, dynamic>,
            )
          : null,
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
}
