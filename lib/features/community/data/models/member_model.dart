
import 'package:domochat/features/community/domain/entities/member_entity.dart';

class MemberModel extends MemberEntity {
  MemberModel({required super.userId, required super.fullName, required super.apartment, required super.residentStatus, required super.role});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
        userId: json['user_id'],
        fullName: json['full_name'],
        apartment: json['apartment'],
        residentStatus: json['resident_status'],
        role: json['role']
    );
  }
}