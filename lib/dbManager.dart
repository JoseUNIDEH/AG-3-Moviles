import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'book.dart';

class dbManager {
  static Database? _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String BOOK_NAME = 'book_name';
  static const String AUTOR_NAME = 'autor_name';
  static const String EDITORIAL_NAME = 'editorial_name';
  static const String DATE = 'date';
  static const String TABLE = 'BooksTable';
  static const String DB_NAME = 'books.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $BOOK_NAME TEXT, $AUTOR_NAME TEXT, $EDITORIAL_NAME TEXT, $DATE TEXT)");
  }

  //insert
  Future<Book> save(Book book) async {
    var dbClient = await db;
    book.id = await dbClient.insert(TABLE, book.toMap());
    return book;
  }

  //select
  Future<List<Book>> getBooks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE,
        columns: [ID, NAME, BOOK_NAME, AUTOR_NAME, EDITORIAL_NAME, DATE]) ;
    List<Book> books = [];

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        books.add(Book.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return books;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  //select dedicado
  Future<List<Book>> getBooksForID(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE,
        columns: [ID, NAME, BOOK_NAME, AUTOR_NAME, EDITORIAL_NAME, DATE],
        where: '$ID = ?',
        whereArgs: [id]);
    List<Book> books = [];

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        books.add(Book.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return books;
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient!.delete(TABLE, where: '$ID=?', whereArgs: [id]);
  }

  Future<int> update(Book book) async {
    var dbClient = await db;
    return await dbClient!.update(TABLE, book.toMap(),
        where: '$ID=?', whereArgs: [book.id]);
  }

}
