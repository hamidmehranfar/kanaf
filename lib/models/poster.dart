class Poster{
  String title;
  String address;
  String imageUrl;
  String? price;

  Poster({
    required this.title,
    required this.address,
    required this.imageUrl,
    this.price,
  });
}