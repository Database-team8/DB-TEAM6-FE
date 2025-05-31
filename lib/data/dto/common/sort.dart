class Sort {
  final bool empty;
  final bool sorted;
  final bool unsorted;

  Sort({
    required this.empty,
    required this.sorted,
    required this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'] as bool,
      sorted: json['sorted'] as bool,
      unsorted: json['unsorted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empty': empty,
      'sorted': sorted,
      'unsorted': unsorted,
    };
  }
}
