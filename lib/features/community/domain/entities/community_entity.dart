class CommunityEntity {
  final String id;
  final String adressCity;
  final String adressStreet;
  final String adressHouse;
  final String creatorId;
  final List<String> conversationsId;

  CommunityEntity ({
      required this.id,
      required this.adressCity,
      required this.adressStreet,
      required this.adressHouse,
      required this.creatorId,
      required this.conversationsId,
  });
}