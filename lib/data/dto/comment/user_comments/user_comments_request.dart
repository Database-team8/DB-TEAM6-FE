class UserCommentsRequest {
  final int page;
  final int size;

  UserCommentsRequest({this.page = 0, this.size = 10});

  Map<String, dynamic> toQueryParameters() {
    return {'page': page, 'size': size};
  }
}
