// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Collection {
  /// unique id
  String id;

  /// collection name
  String name;

  /// assest url
  String imgUrl;

  /// Represent similarity between one or more [Product]
  Collection({
    required this.id,
    required this.name,
    required this.imgUrl,
  });

  Collection copyWith({
    String? id,
    String? name,
    String? imgUrl,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'] as String,
      name: map['name'] as String,
      imgUrl: map['imgUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Collection.fromJson(String source) =>
      Collection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Collection(id: $id, name: $name, imgUrl: $imgUrl)';

  @override
  bool operator ==(covariant Collection other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.imgUrl == imgUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imgUrl.hashCode;
}
