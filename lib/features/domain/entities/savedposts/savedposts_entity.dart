class SavedpostsEntity {
  String userId;
  String postId;
  DateTime savedAt;

  SavedpostsEntity(
      {required this.userId, required this.postId, required this.savedAt});
}
