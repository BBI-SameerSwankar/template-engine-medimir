import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../presentation/template_engine/models/home_screen/home_screen_carousel.dart';
import '../presentation/template_engine/models/template_design/template_design_model/template_design_model.dart';


/// Data object for the home screen:
/// - [carousels]: sections from the home screen API
/// - [templates]: templateId -> TemplateDesignModel
class HomeData {
  final List<HomeScreenModel> carousels;
  final Map<String, TemplateDesignModel> templates;

  const HomeData({
    required this.carousels,
    required this.templates,
  });
}

/// Loads JSON from assets and converts it into [HomeData].
Future<HomeData> loadHomeData() async {
  // 1) Load home screen carousels
  final homeJsonStr =
      await rootBundle.loadString('assets/home_screen_api_response.json');
  final List<dynamic> homeList = jsonDecode(homeJsonStr) as List<dynamic>;
  final carousels = HomeScreenModelFactory.fromJsonList(homeList);

  // 2) Load templates (for now, only topToolsWorldwide.json)
  final templates = <String, TemplateDesignModel>{};

  final topToolsStr =
      await rootBundle.loadString('assets/topToolsWorldwide.json');
  final topToolsTemplate = TemplateDesignModel.fromJsonString(topToolsStr);
  templates[topToolsTemplate.id] = topToolsTemplate;

  // If you add more template jsons later, load and add them here.

  // Ensure deterministic order
  carousels.sort((a, b) => a.position.compareTo(b.position));

  return HomeData(carousels: carousels, templates: templates);
}
