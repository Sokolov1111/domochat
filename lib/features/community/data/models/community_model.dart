
import 'package:domochat/features/community/domain/entities/community_entity.dart';

class CommunityModel extends CommunityEntity {
  CommunityModel({
    required super.id,
    required super.adressCity,
    required super.adressStreet,
    required super.adressHouse,
    required super.creatorId,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
        id: json['id'],
        adressCity: json['adress_city'],
        adressStreet: json['adress_street'],
        adressHouse: json['adress_house'],
        creatorId: json['creator_id'],
    );
  }
}