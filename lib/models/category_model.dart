class ToDoCategoryModel {
  int? id;
  String? title;
  DateTime? created_at;
  DateTime? deleted_at;
  List<Items>? items;

  ToDoCategoryModel({
    this.id,
    this.title,
    this.created_at,
    this.deleted_at,
    this.items,
  });

  ToDoCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    created_at = json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null;
    deleted_at = json["deleted_at"] != null
        ? DateTime.parse(json["deleted_at"])
        : null;
    if (json['items'] != null) {
      items = (json['items'] as List).map((e) => Items.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["title"] = title;
    data["created_at"] = created_at?.toIso8601String();
    data["deleted_at"] = deleted_at?.toIso8601String();
    if (items != null) {
      data['items'] = items!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? title;
  DateTime? created_at;
  DateTime? deleted_at;
  DateTime? started_at;
  DateTime? ended_at;
  bool? isCompleted;

  Items({
    this.id,
    this.title,
    this.created_at,
    this.deleted_at,
    this.started_at,
    this.ended_at,
    this.isCompleted,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    created_at = json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null;
    deleted_at = json["deleted_at"] != null
        ? DateTime.parse(json["deleted_at"])
        : null;
    started_at = json["started_at"] != null
        ? DateTime.parse(json["started_at"])
        : null;
    ended_at = json["ended_at"] != null
        ? DateTime.parse(json["ended_at"])
        : null;
    isCompleted = json["isCompleted"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["title"] = title;
    data["created_at"] = created_at?.toIso8601String();
    data["deleted_at"] = deleted_at?.toIso8601String();
    data["started_at"] = started_at?.toIso8601String();
    data["ended_at"] = ended_at?.toIso8601String();
    data["isCompleted"] = isCompleted;
    return data;
  }
}
