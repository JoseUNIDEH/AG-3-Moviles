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
import 'busqueda.dart';
import 'registro.dart';
import 'sign_in.dart';
import 'main.dart';


class inicio extends StatefulWidget {
  const inicio({Key? key}) : super(key: key);
  @override
  State<inicio> createState() => _inicioState();
}

class _inicioState extends State<inicio> {
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

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: List.generate(books.length, (index) {
          int adjustedIndex = index + 1;
          return Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: dbmanager.getBooksForID(adjustedIndex),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Book>> snapshot) {
                      Book book = snapshot.data!
                          .firstWhere((book) => book.id == adjustedIndex);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(book.name!),
                          Text(book.autor_name!),
                          Text(book.editorial_name!),
                          Text(book.date!),
                          Container(
                              width: 100,
                              height: 100,
                              child: Utility.ImageFromBase64String(
                                  book.book_name!))
                        ],
                      );
                    },
                  ),
                ]),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Libreria"),
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
                  Navigator.pop(context);
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => busqueda()));
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            )
          ],
        ),
      ),
    );
  }
}
