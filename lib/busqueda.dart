import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'Delete.dart';
import 'Update.dart';
import 'convert_utility.dart';
import 'dbManager.dart';
import 'book.dart';
import 'dart:io';
import 'dart:async';
import 'main.dart';
import 'registro.dart';
import 'sign_in.dart';
import 'main.dart';

class busqueda extends StatefulWidget {
  const busqueda({Key? key}) : super(key: key);

  @override
  State<busqueda> createState() => _busquedaState();
}

class _busquedaState extends State<busqueda> {
  late List<Book> books;
  late dbManager dbmanager;
  late Future<File> imageFile;
  late Image image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbmanager = dbManager();
    books = [];
    refreshImages();
  }

  refreshImages() {
    dbmanager.getBooks().then((images) {
      setState(() {
        books.clear();
        books.addAll(images);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Busqueda"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text("EQUIPO 1"), accountEmail: Text("")),
              Card(
                child: ListTile(
                  title: Text("Libreria"),
                  trailing: Icon(Icons.home),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Nuevo Registro"),
                  trailing: Icon(Icons.add_box),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => registro()));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Busqueda"),
                  trailing: Icon(Icons.arrow_circle_right),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Delete"),
                  trailing: Icon(Icons.delete),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => delete()));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Update"),
                  trailing: Icon(Icons.update),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => update()));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Cerrar sesion"),
                  trailing: Icon(Icons.close),
                  onTap: () {
                    signOutGoogle().whenComplete((){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return HomePage();
                      }));
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        body: Container(
            child: FutureBuilder(
                future: dbmanager.getBooks(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Autor Name')),
                        DataColumn(label: Text('Editorial Name')),
                        DataColumn(label: Text('Date')),
                      ],
                      rows: snapshot.data!.map((book) {
                        return DataRow(
                          cells: [
                            DataCell(Text(book.name!)),
                            DataCell(Text(book.autor_name!)),
                            DataCell(Text(book.editorial_name!)),
                            DataCell(Text(book.date!)),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                })));
  }
}
