/// 댓글 조회 요청 DTO (Query Parameter용)
/// boardId는 여기 포함되지 않고, Repository에서 별도 전달
class CommentsRequest {
  final int page;
  final int size;

  CommentsRequest({this.page = 0, this.size = 10});

  Map<String, dynamic> toQueryParameters() {
    return {'page': page, 'size': size};
  }
}
