
import 'package:domochat/features/resource/domain/entities/resource_entity.dart';

class ResourceModel extends ResourceEntity {
  ResourceModel({required super.id, required super.title, required super.description, required super.contactInfo, required super.category, required super.author, required super.date});

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        contactInfo: json['contact_info'],
        category: json['category'],
        author: json['author_name'] ?? '',
        date: json['created_at']
    );
  }
}