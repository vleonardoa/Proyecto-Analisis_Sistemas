import 'dart:convert';

import 'package:finalya/modelo/nota.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:finalya/db/Llamados.dart';
import 'package:intl/intl.dart';

import 'edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Nota note;
  bool isLoading = false;

  late Future<List<Nota>> _listadoNota;
  Future<List<Nota>> _getNota() async {
    final respuesta =
        await get(Uri.parse("http://analisistask.azurewebsites.net/api/Notes"));
    List<Nota> nota = [];
    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      final jsona = jsonDecode(body);
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

/*  Future<dynamic> _getListado() async {
    final respuesta =
        await get(Uri.parse("http://analisistask.azurewebsites.net/api/Notes"));
    List<Nota> nota = [];
    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      final json = jsonDecode(body);
      print(json);
      print(json["number"][0]);
      return jsonDecode(respuesta.body);
    } else {
      print("Error con la respusta");
    }
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listadoNota = _getNota();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await LLamada.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          //title: Text("Block de Notas")
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (DateFormat.yMMMd()
                          .format(DateTime.parse(note.createdTime.toString()))
                          .toString()),
                      style: const TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.description.toString(),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  List<Widget> listado(List<dynamic> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      lista.add(Text("Id: " + elemento["id"].toString()));
      lista.add(Text("Título: " + elemento["title"].toString()));
      lista.add(Text("Descripción: " + elemento["description"].toString()));
      lista.add(Text(""));
    });
    return lista;
  }

  List<Widget> _listNotas(List<Nota> data) {
    List<Widget> notas = [];
    for (var nota in data) {
      notas.add(Text(nota.id.toString()));
    }
    return notas;
  }

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await LLamada.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}
