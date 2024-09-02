class Companies {
  String id;
  String name;

  Companies(this.id, this.name);

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(json['id'], json['name']);
  }
}
