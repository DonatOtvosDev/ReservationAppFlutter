class Service {
  final int id;
  final String name;
  final String type;
  final String description;
  final String? comment;
  final int price;
  final int duration;

  Service(
      {required this.id,
      required this.name,
      required this.type,
      required this.description,
      required this.comment,
      required this.price,
      required this.duration});
}
