class Device {
  final String id;
  final String name;
  final String ipAddress;
  final String macAddress;
  final String status;
  final DateTime lastSeen;
  final String? description;
  final String? templateId;
  final String? productId;

  Device({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.macAddress,
    required this.status,
    required this.lastSeen,
    this.description,
    this.templateId,
    this.productId,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      ipAddress: json['ipAddress'] ?? '',
      macAddress: json['macAddress'] ?? '',
      status: json['status'] ?? 'غير متصل',
      lastSeen: DateTime.parse(json['lastSeen'] ?? DateTime.now().toIso8601String()),
      description: json['description'],
      templateId: json['templateId'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ipAddress': ipAddress,
      'macAddress': macAddress,
      'status': status,
      'lastSeen': lastSeen.toIso8601String(),
      'description': description,
      'templateId': templateId,
      'productId': productId,
    };
  }

  Device copyWith({
    String? id,
    String? name,
    String? ipAddress,
    String? macAddress,
    String? status,
    DateTime? lastSeen,
    String? description,
    String? templateId,
    String? productId,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      description: description ?? this.description,
      templateId: templateId ?? this.templateId,
      productId: productId ?? this.productId,
    );
  }
} 