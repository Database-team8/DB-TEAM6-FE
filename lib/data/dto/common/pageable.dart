import 'package:ajoufinder/data/dto/common/sort.dart';

class Pageable {
  final int offset;
  final Sort sort;
  final int pageNumber;
  final int pageSize;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.offset,
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      offset: json['offset'] as int,
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      paged: json['paged'] as bool,
      unpaged: json['unpaged'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'sort': sort.toJson(),
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'paged': paged,
      'unpaged': unpaged,
    };
  }
}
