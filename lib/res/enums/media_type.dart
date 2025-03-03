enum MediaType {
  image,
  video,
}

MediaType convertToMediaType(String itemType) {
  switch (itemType) {
    case "0":
      return MediaType.image;
    case "1":
      return MediaType.video;
    default:
      return MediaType.image;
  }
}
