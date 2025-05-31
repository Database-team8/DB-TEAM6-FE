class BoardItem {
  final int id;
  final String title;
  final String authorNickname;
  final DateTime createdAt;   
  final String status;       
  final String? imageUrl;    

  BoardItem({
    required this.id,
    required this.title,
    required this.authorNickname,
    required this.createdAt,
    required this.status,
    this.imageUrl,
  });
}
