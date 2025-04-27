enum ReactionType { like, dislike }

ReactionType convertIndexToReaction(String index) {
  if (index == "1") {
    return ReactionType.like;
  } else {
    return ReactionType.dislike;
  }
}

int convertReactionToIndex(ReactionType type) {
  if (type == ReactionType.like) {
    return 1;
  } else {
    return 2;
  }
}
