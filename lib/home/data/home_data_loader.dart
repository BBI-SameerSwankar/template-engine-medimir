import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../presentation/template_engine/models/home_screen/home_screen_carousel.dart';
import '../presentation/template_engine/models/template_design/template_design_model/template_design_model.dart';

class HomeData {
  final List<HomeScreenModel> carousels;
  final Map<String, TemplateDesignModel> templates;

  const HomeData({
    required this.carousels,
    required this.templates,
  });
}

Future<HomeData> loadHomeData() async {
  // 1) Load home screen carousels
  final homeJsonStr =
      await rootBundle.loadString('assets/home_screen_api_response.json');
  final List<dynamic> homeList = jsonDecode(homeJsonStr) as List<dynamic>;
  final carousels = HomeScreenModelFactory.fromJsonList(homeList);

  // 2) Load templates
  final templates = <String, TemplateDesignModel>{};

  // Top Tools Worldwide template
  final topToolsStr =
      await rootBundle.loadString('assets/topToolsWorldwide.json');
  final topToolsTemplate = TemplateDesignModel.fromJsonString(topToolsStr);
  templates[topToolsTemplate.id] = topToolsTemplate;

  // Last Seen Tools template
  final lastSeenStr =
      await rootBundle.loadString('assets/lastSeenTools.json');
  final lastSeenTemplate = TemplateDesignModel.fromJsonString(lastSeenStr);
  templates[lastSeenTemplate.id] = lastSeenTemplate;

  // Last Seen Patients template
  final lastSeenPatientsStr =
      await rootBundle.loadString('assets/lastSeenPatients.json');
  final lastSeenPatientsTemplate =
      TemplateDesignModel.fromJsonString(lastSeenPatientsStr);
  templates[lastSeenPatientsTemplate.id] = lastSeenPatientsTemplate;

  // Medical Areas template  ✅ new
  final medicalAreasStr =
      await rootBundle.loadString('assets/medicalAreas.json');
  final medicalAreasTemplate =
      TemplateDesignModel.fromJsonString(medicalAreasStr);
  templates[medicalAreasTemplate.id] = medicalAreasTemplate;

  // Scores template  ✅ new
  final scoresStr = await rootBundle.loadString('assets/scores.json');
  final scoresTemplate = TemplateDesignModel.fromJsonString(scoresStr);
  templates[scoresTemplate.id] = scoresTemplate;

  // Ensure deterministic order
  carousels.sort((a, b) => a.position.compareTo(b.position));

  return HomeData(carousels: carousels, templates: templates);
}
