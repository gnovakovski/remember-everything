import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import 'dart:io';
import 'dart:async';

import '../model/note.dart';
import '../model/folder.dart';

class DbProvider {
  Future<Database> init() async {
    Directory directory =
        await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path, "memos.db"); //create path to database

    return await openDatabase(
        //open the database or create a database if there isn't any
        path,
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("""
         CREATE TABLE Note (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        folderId TEXT,
        createDate INTEGER,
        updateDate INTEGER);""");
      await db.execute("""
         CREATE TABLE Folder (
        id TEXT PRIMARY KEY,
        name TEXT,
        createDate INTEGER,
        updateDate INTEGER);""");
    });
  }

  Future<int> addNote(Note note) async{ //returns number of items inserted as an integer

    final db = await init(); //open database

    return db.insert("Note", note.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> addFolder(Folder folder) async{ //returns number of items inserted as an integer

    final db = await init(); //open database

    return db.insert("Folder", folder.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<Note>> fetchNotes() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Note"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        folderId: maps[i] ['folderId'],
        createDate: maps[i] ['createDate'],
        updateDate: maps[i] ['updateDate']
      );
    });
  }

  Future<List<Folder>> fetchFolders() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Folder"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return Folder(
          id: maps[i]['id'],
          name: maps[i]['name'],
          createDate: maps[i] ['createDate'],
          updateDate: maps[i] ['updateDate']
      );
    });
  }


  Future<int> deleteNote(int id) async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        "Note", //table name
        where: "id = ?",
        whereArgs: [id] // use whereArgs to avoid SQL injection
    );

    return result;
  }

  Future<int> deleteFolder(int id) async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        "Folder", //table name
        where: "id = ?",
        whereArgs: [id] // use whereArgs to avoid SQL injection
    );

    return result;
  }

  Future<int> updateNote(int id, Note item) async{ // returns the number of rows updated

    final db = await init();

    int result = await db.update(
        "Note",
        item.toMap(),
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future<int> updateFolder(int id, Folder item) async{ // returns the number of rows updated

    final db = await init();

    int result = await db.update(
        "Folder",
        item.toMap(),
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }
}
