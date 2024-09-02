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
  List<Assets>? children;

  Assets(this.id, this.name, this.parentId, this.sensorId, this.sensorType,
      this.status, this.gateWay, this.locationId, this.iconPath);

  Assets.assetParAsset(this.id, this.name, this.parentId)
      : iconPath = 'assets/asset.png';

  Assets.assetParLocation(this.id, this.name, this.locationId)
      : iconPath = 'assets/asset.png';

  Assets.componentUnliked(this.id, this.name, this.sensorId, this.sensorType,
      this.status, this.gateWay)
      : iconPath = 'assets/component.png';

  Assets.component(this.id, this.name, this.parentId, this.sensorId,
      this.sensorType, this.status, this.gateWay, this.locationId)
      : iconPath = 'assets/component.png';

  @override
  String toString() {
    return 'Asset{id: $id, name: $name, parentId: $parentId, sensorId: $sensorId, sensorType: $sensorType, status: $status, gateWay: $gateWay, locationId: $locationId, iconPath: $iconPath, children: $children}';
  }

  factory Assets.fromJson(Map<String, dynamic> json) {
    if (json['location'] != null && json['sensorId'] == null) {
      return Assets.assetParLocation(
          json['id'], json['name'], json['locationId']);
    }
    if (json['parentId'] != null && json['sensorId'] == null) {
      return Assets.assetParAsset(json['id'], json['name'], json['parentId']);
    }
    if (json['sensorType'] != null &&
        (json['location'] != null || json['parentId'] != null)) {
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
    if (json['sensorType'] != null &&
        json['location'] == null &&
        json['parentId'] == null) {
      return Assets.componentUnliked(
        json['id'],
        json['name'],
        json['sensorId'],
        json['sensorType'],
        json['status'],
        json['gateWay'],
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
