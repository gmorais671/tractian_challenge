import 'assets.dart';

class Locations {
  String id;
  String name;
  String? parentId;
  Locations? locationChild;
  List<Assets>? children;
  String iconPath = 'assets/location.png';

  Locations.subLoc(this.id, this.name, this.parentId);

  Locations.loc(this.id, this.name) : parentId = null;

  @override
  String toString() {
    return 'Location{id: $id, name: $name, parentId: $parentId, locationChild: $locationChild, children: $children}';
  }

  factory Locations.fromJson(Map<String, dynamic> json) {
    return json['parentId'] == null
        ? Locations.loc(json['id'], json['name'])
        : Locations.subLoc(json['id'], json['name'], json['parentId']);
  }
}
