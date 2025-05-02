enum OfferStatus {
  review,
  accept,
  finish,
  deny,
}

OfferStatus convertIndexToOfferStatus(String index) {
  switch (index) {
    case "0":
      return OfferStatus.review;
    case "1":
      return OfferStatus.accept;
    case "2":
      return OfferStatus.finish;
    case "3":
      return OfferStatus.deny;
    default:
      return OfferStatus.review;
  }
}

String convertOfferStatusToIndex(OfferStatus? status) {
  switch (status) {
    case OfferStatus.review:
      return "0";
    case OfferStatus.accept:
      return "1";
    case OfferStatus.finish:
      return "2";
    case OfferStatus.deny:
      return "3";
    default:
      return "0";
  }
}

String convertOfferStatusToString(OfferStatus status) {
  switch (status) {
    case OfferStatus.review:
      return "بررسی";
    case OfferStatus.accept:
      return "تایید";
    case OfferStatus.deny:
      return "رد";
    case OfferStatus.finish:
      return "خاتمه";
  }
}
