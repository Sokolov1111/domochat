
import 'package:domochat/features/announcement/domain/entities/announcement_entity.dart';

class AnnouncementModel extends AnnouncementEntity {
  AnnouncementModel({required super.id, required super.title, required super.description, required super.price, required super.imageUrls, required super.author, required super.date});

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
        id: json['id'],
        title: json['title'],
        description: json['desciption'],
        price: json['price'].toString(),
        imageUrls: (json['image_urls'] as List).map((item) => item.toString()).toList(),
        author: json['author_name'],
        date: json['created_at'],
    );
  }
}