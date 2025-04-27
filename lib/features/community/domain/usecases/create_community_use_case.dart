
import 'package:domochat/features/community/domain/entities/community_entity.dart';
import 'package:domochat/features/community/domain/repositories/community_repository.dart';

class CreateCommunityUseCase {
  final CommunityRepository repository;

  CreateCommunityUseCase({required this.repository});

  Future<CommunityEntity> call (
      String adressCity,
      String adressStreet,
      String adressHouse,
      String creatorId,
      String fullName,
      String apartment,
      String residentStatus,
      ) {
    return repository.createCommunity(adressCity, adressStreet, adressHouse, creatorId, fullName, apartment, residentStatus);
  }
  }