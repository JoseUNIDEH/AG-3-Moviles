import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'CustomTextField.dart';
import 'Delete.dart';
import 'Update.dart';
import 'convert_utility.dart';
import 'dbManager.dart';
import 'book.dart';
import 'dart:io';
import 'dart:async';
import 'busqueda.dart';
import 'main.dart';
import 'sign_in.dart';
import 'main.dart';

class registro extends StatefulWidget {
  const registro({Key? key}) : super(key: key);

  @override
  State<registro> createState() => _registroState();
}

class _registroState extends State<registro> {
  late List<Book> books;
  late dbManager dbmanager;
  late Future<File> imageFile;
  late Image image;

  TextEditingController _textEditingControllerUno =
      TextEditingController(text: "");
  TextEditingController _textEditingControllerDos =
      TextEditingController(text: "");
  TextEditingController _textEditingControllerTres =
      TextEditingController(text: "");
  TextEditingController _textEditingControllerCuatro =
      TextEditingController(text: "");

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

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((imgFile) async {
      Uint8List? imageBytes = await imgFile?.readAsBytes();
      String imgString = Utility.base64String(imageBytes!);
      Book book = Book(
          null,
          _textEditingControllerUno.text,
          imgString,
          _textEditingControllerDos.text,
          _textEditingControllerTres.text,
          _textEditingControllerCuatro.text);
      dbmanager.save(book);
      refreshImages();
      _textEditingControllerUno.text = "";
      _textEditingControllerDos.text = "";
      _textEditingControllerTres.text = "";
      _textEditingControllerCuatro.text = "";
    });
  }


  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text("Registro"),
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
                    Navigator.pop(context);
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
        body: ListView(
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                        TextField(
                        decoration: InputDecoration(
                        border: InputBorder.none,
                            hintText: 'Ingresa datos del libro'
                        ),
                  ),
                  CustomTextField(
                      "Nombre del Libro", Icon(Icons.book),
                      _textEditingControllerUno,
                      _notempty
                  ),
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  CustomTextField(
                      "Nombre del Autor", Icon(Icons.person),
                      _textEditingControllerDos,
                      _notempty
                  ),
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  CustomTextField(
                      "Nombre de la editorial", Icon(Icons.factory),
                      _textEditingControllerTres,
                      _notempty
                  ),
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  CustomTextField(
                      "Fecha de Publicación", Icon(Icons.date_range),
                      _textEditingControllerCuatro,
                      _notempty
                  ),
                  Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
                  MaterialButton(
                    child: Text("Seleccionar Imagen",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    height: 40,
                    minWidth: 40,
                    color: Colors.amber,
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        pickImageFromGallery();
                      }else{
                        print('Dato1'+_textEditingControllerUno.text);
                        print('Dato2'+_textEditingControllerDos.text);
                        print('Dato3'+_textEditingControllerTres.text);
                        print('Dato4'+_textEditingControllerCuatro.text);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        )

    );

  }
    //Metodos para validar
    String? _notempty(String? value) {
      if (value!.isEmpty == true) {
        return "Data Connot be Empty";
      } else {
        return null;
      }
      //return value! ? "Solo introduir letras" : null;
    }

    _showSnackBar(BuildContext context, String message) {
      final snackBar = SnackBar(content: Text(message));
      //_scaffoldkey.currentState.showSnackBar(snackBar);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

