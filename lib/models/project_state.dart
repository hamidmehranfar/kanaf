import '/res/enums/offer_status.dart';

class ProjectState {
  OfferStatus state;
  String display;

  ProjectState({
    required this.state,
    required this.display,
  });

  ProjectState.fromJson(Map<String, dynamic> json)
      : state = convertIndexToOfferStatus(json["value"]),
        display = json["display"];
}
