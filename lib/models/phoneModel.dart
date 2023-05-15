class Phone {
  final int? id;
  final String producer;
  final String model;
  final String softVersion;
  final String picture;

  const Phone({
    required this.id,
    required this.producer,
    required this.model,
    required this.softVersion,
    required this.picture,
  });

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
    id: json['id'],
    producer: json['producer'],
    model: json['model'],
    softVersion: json['softVersion'],
    picture: json['picture'],
  );

  Map<String, dynamic> toJson() => {
      'id': id,
      'producer': producer,
      'model': model,
      'softVersion': softVersion,
      'picture': picture
  };
}