
import 'package:domochat/features/community/domain/entities/community_entity.dart';

class CommunityModel extends CommunityEntity {
  CommunityModel({
    required super.id,
    required super.adressCity,
    required super.adressStreet,
    required super.adressHouse,
    required super.creatorId,
    required super.conversationsId,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
        id: json['id'],
        adressCity: json['addressCity'],
        adressStreet: json['addressStreet'],
        adressHouse: json['addressHouse'],
        creatorId: json['creatorId'],
        conversationsId: (json['conversations'] as List<dynamic>?)
          ?.map((c) => c['id'] as String)
          .toList() ?? [],
    );
  }
}