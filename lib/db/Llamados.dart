import 'dart:convert';

import 'package:finalya/modelo/nota.dart';
import 'package:http/http.dart';

class LLamada {
  static final LLamada instance = LLamada._init();

  LLamada._init();
/*
  Future<Nota> readN(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }
*/
  Future<Nota> readNote(int id) async {
    late final jsona;
    final respuesta = await get(
        Uri.parse("http://analisistask.azurewebsites.net/api/Notes/$id"));
    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      jsona = jsonDecode(body);
      /*
      List<Nota> nota = [];
      int nume = 0;
      // print(json[nume]);
      Iterable<dynamic> json = jsonDecode(body);
      for (var item in json) {
        nota.add(Nota(
            item["id"],
            item["isImportant"],
            item["number"],
            item["title"],
            item["description"],
            DateTime.parse(item["createdTime"])));
        nume = nume++;
      }*/
    } else {
      print("Error con la conexion");
    }
    //  return nota;
    return Nota.fromJson(jsona);
  }

  delete(int noteId) {}
  //Future<List<Note>> readAllNotess() async {
  // final db = await instance.database;

  //const orderBy = '${NoteFields.time} ASC';
  //final result = await db.query(
  // tableNotes,
  // orderBy: orderBy,
  //);

  // return result.map((json) => Note.fromJson(json)).toList();
  // }

  Future<List<Nota>> readAllNotes() async {
    late final jsona;
    final respuesta = await get(
        Uri.parse("http://analisistask.azurewebsites.net/api/Notes/"));
    List<Nota> nota = [];
    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      jsona = jsonDecode(body);

      int nume = 0;
      // print(json[nume]);
      Iterable<dynamic> json = jsonDecode(body);
      for (var item in json) {
        nota.add(Nota(
            item["id"],
            item["isImportant"],
            item["number"],
            item["title"],
            item["description"],
            DateTime.parse(item["createdTime"])));
        nume = nume++;
      }
    } else {
      print("Error con la conexion");
    }
    return nota;
  }
}
