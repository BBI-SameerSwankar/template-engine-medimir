import 'extra_parameters.dart';

class TileClickAction {
  final String clickId;
  final ExtraParameters extraParameters;

  TileClickAction({
    required this.clickId,
    required this.extraParameters,
  });

  factory TileClickAction.fromJson(Map<String, dynamic> json) {
    return TileClickAction(
      clickId: json["clickId"] ?? "",
      extraParameters: ExtraParameters.fromJson(json["extraParameters"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "clickId": clickId,
      "extraParameters": extraParameters.toJson(),
    };
  }
}
