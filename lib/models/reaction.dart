import 'package:kanaf/res/enums/reaction_type.dart';

class Reaction {
  int id;
  ReactionType reaction;

  Reaction(this.id, this.reaction);

  Reaction.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        reaction = convertIndexToReaction(json["reaction"]);
}
