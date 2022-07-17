class Book {
  final int? id;
  String name;
  int indexInPage;
  int pageNo;
  int totalPage;
  String path;

  Book(
      {this.id,
      required this.name,
      required this.indexInPage,
      required this.pageNo,
      required this.totalPage,
      required this.path});

  Map<String, Object?> toJson() => {
        "_id": id,
        "name": name,
        "indexInPage": indexInPage,
        "pageNo": pageNo,
        "totalPage": totalPage,
        "path": path
      };
  Book copy(
          {int? id,
          int? indexInPage,
          String? name,
          int? pageNo,
          int? totalPage,
          String? path}) =>
      Book(
        id: id ?? this.id,
        indexInPage: indexInPage ?? this.indexInPage,
        name: name ?? this.name,
        pageNo: pageNo ?? this.pageNo,
        totalPage: totalPage ?? this.totalPage,
        path: path ?? this.path,
      );

  static Book fromJson(Map<String, Object?> json) => Book(
        id: json["_id"] as int?,
        indexInPage: json["indexInPage"] as int,
        name: json["name"] as String,
        pageNo: json["pageNo"] as int,
        totalPage: json["totalPage"] as int,
        path: json["path"] as String,
      );
}
