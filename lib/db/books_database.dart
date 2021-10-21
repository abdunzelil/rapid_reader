import 'package:rapid_reader_app/model/book.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BooksDatabase {
  static final BooksDatabase instance = BooksDatabase._init();
  static Database? _database;
  BooksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE tableBooks(_id INTEGER PRIMARY KEY, name TEXT,indexInPage INTEGER,pageNo INTEGER,totalPage INTEGER, path TEXT )");
  }

  Future<Book> create(Book book) async {
    final db = await instance.database;
    final id = await db.insert("tableBooks", book.toJson());
    return book.copy(id: id);
  }

  Future<Book> getBook(int id) async {
    final db = await instance.database;
    final maps = await db.query("tableBooks",
        columns: ["_id", "name", "indexInPage", "pageNo", "totalPage", "path"],
        where: "_id = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Book.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Book>> getAllBooks() async {
    final db = await instance.database;
    final result = await db.query("tableBooks");
    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete("tableBooks", where: "_id = ?", whereArgs: [id]);
  }

  Future<int> update(Book book) async {
    final db = await instance.database;
    return db.update("tableBooks", book.toJson(),
        where: "_id = ?", whereArgs: [book.id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
