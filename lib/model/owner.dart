class Owner {
  String? name;
  String? face;
  late int fans;

  Owner({this.name, this.face, this.fans = 0});

  Owner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data['name'] = name;
    data['face'] = face;
    data['fans'] = fans;
    return data;
  }
}
