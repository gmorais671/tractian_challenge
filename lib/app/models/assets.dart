class Assets {
  String id;
  String name;
  String? parentId;
  String? sensorId;
  String? sensorType;
  String? status;
  String? gateWay;
  String? locationId;
  String iconPath;
  List<Assets> children = [];

  Assets(this.id, this.name, this.parentId, this.sensorId, this.sensorType,
      this.status, this.gateWay, this.locationId, this.iconPath);

  Assets.asset(
    this.id,
    this.name,
    this.parentId,
    this.sensorId,
    this.sensorType,
    this.status,
    this.gateWay,
    this.locationId,
  ) : iconPath = 'assets/asset.png';

  Assets.component(
    this.id,
    this.name,
    this.parentId,
    this.sensorId,
    this.sensorType,
    this.status,
    this.gateWay,
    this.locationId,
  ) : iconPath = 'assets/component.png';

  @override
  String toString() {
    return 'Asset{id: $id, name: $name, parentId: $parentId, sensorId: $sensorId, sensorType: $sensorType, status: $status, gateWay: $gateWay, locationId: $locationId, iconPath: $iconPath, children: $children}';
  }

  factory Assets.fromJson(Map<String, dynamic> json) {
    if ((json['location'] != null || json['parentId'] != null) &&
        json['sensorId'] == null) {
      return Assets.asset(
        json['id'],
        json['name'],
        json['parentId'],
        json['sensorId'],
        json['sensorType'],
        json['status'],
        json['gateWay'],
        json['locationId'],
      );
    }
    if (json['sensorType'] != null) {
      return Assets.component(
        json['id'],
        json['name'],
        json['parentId'],
        json['sensorId'],
        json['sensorType'],
        json['status'],
        json['gateWay'],
        json['locationId'],
      );
    }
    return Assets(
        json['id'],
        json['name'],
        json['parentId'],
        json['sensorId'],
        json['sensorType'],
        json['status'],
        json['gateWay'],
        json['locationId'],
        'assets/asset.png');
  }
}
