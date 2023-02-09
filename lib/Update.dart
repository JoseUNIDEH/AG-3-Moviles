import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'CustomTextField.dart';
import 'Delete.dart';
import 'convert_utility.dart';
import 'dbManager.dart';
import 'book.dart';
import 'dart:io';
import 'dart:async';
import 'main.dart';
import 'registro.dart';
import 'sign_in.dart';
import 'main.dart';

class update extends StatefulWidget {
  const update({Key? key}) : super(key: key);

  @override
  State<update> createState() => _updateState();
}

class _updateState extends State<update> {

  late Future<List<Book>> Books2;
  late List<Book> books;
  late dbManager dbmanager;
  late Future<File> imageFile;
  late Image image;

  TextEditingController _textEditingControllerUno = TextEditingController(text: "");
  TextEditingController _textEditingControllerDos =   TextEditingController(text: "");
  TextEditingController _textEditingControllerTres =   TextEditingController(text: "");
  TextEditingController _textEditingControllerCuatro =   TextEditingController(text: "");
  int? curUserid = 0;
  String? uno = "";
  String? dos = "";
  String? tres = "";
  String? cuatro = "";

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _autovalidate = false;
  late bool isUpdating=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbmanager = dbManager();
    books = [];
    isUpdating = false;
    refreshImages();
  }

  refreshImages() {
    dbmanager.getBooks().then((images) {
      setState(() {
        Books2 = dbmanager.getBooks();
        books.clear();
        books.addAll(images);
      });
    });
  }

  clearFields() {
    //Limpiar el campo de teto
    _textEditingControllerUno.text = "";
    _textEditingControllerDos.text = "";
    _textEditingControllerTres.text = "";
    _textEditingControllerCuatro.text = "";
  }

  //Vaidar formulario
  validate() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      pickImageFromGallery();
      setState(() {
        isUpdating = false;
      });
      refreshImages();
      clearFields();
    }
  }

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker.pickImage(source: ImageSource.gallery).then((imgFile) async {
      Uint8List? imageBytes = await imgFile?.readAsBytes();
      String imgString = Utility.base64String(imageBytes!);
      Book book = Book(
          curUserid,
          uno,
          imgString,
          dos,
          tres,
          cuatro);
      dbmanager.update(book);
    });
  }

  Widget form(){
    return Form(
      key: formkey,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ingresa datos del libro'
            ),
          ),
          TextFormField(
            controller: _textEditingControllerUno,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Nombre del libro",
            ),
            validator: (val) => val?.length == 0 ? 'Ingrese el nombre del libro' : null,
            onSaved: (val) => uno = val!,
          ),
          Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
          TextFormField(
            controller: _textEditingControllerDos,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Nombre del autor",
            ),
            validator: (val) => val?.length == 0 ? 'Ingrese el nombre del autor' : null,
            onSaved: (val) => dos = val!,
          ),
          Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
          TextFormField(
            controller: _textEditingControllerTres,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Nombre de la editorial",
            ),
            validator: (val) => val?.length == 0 ? 'Ingrese el nombre de la editorial' : null,
            onSaved: (val) => tres = val!,
          ),
          Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
          TextFormField(
            controller: _textEditingControllerCuatro,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Fecha de Publicación",
            ),
            validator: (val) => val?.length == 0 ? 'Ingrese la fecha de Publicación' : null,
            onSaved: (val) => cuatro = val!,
          ),
          Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                onPressed: validate,
                child: Text(isUpdating ? 'Actualizar' : 'Selecciona un registro'),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    isUpdating = false;
                  });
                  clearFields();
                },
                child: Text('Cancelar'),
              )
            ],
          ),
          /*Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
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
          ), */
        ],
      ),
    );
  }

  SingleChildScrollView dataTable(List<Book> books) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Autor Name')),
          DataColumn(label: Text('Editorial Name')),
          DataColumn(label: Text('Date')),
        ],
        rows: books.map((book) {
          return DataRow(
              cells: [
                DataCell(Text(book.id!.toString()), onTap: () {
                  setState(() {
                    isUpdating = true;
                    curUserid = book.id!;
                  });
                  _textEditingControllerUno.text = book.name!;
                  _textEditingControllerDos.text = book.autor_name!;
                  _textEditingControllerTres.text = book.editorial_name!;
                  _textEditingControllerCuatro.text = book.date!;
                }),
                DataCell(Text(book.name!), onTap: () {
                  setState(() {
                    isUpdating = true;
                    curUserid = book.id!;
                  });
                  _textEditingControllerUno.text = book.name!;
                  _textEditingControllerDos.text = book.autor_name!;
                  _textEditingControllerTres.text = book.editorial_name!;
                  _textEditingControllerCuatro.text = book.date!;
                }),
                DataCell(Text(book.autor_name!), onTap: () {
                  setState(() {
                    isUpdating = true;
                    curUserid = book.id!;
                  });
                  _textEditingControllerUno.text = book.name!;
                  _textEditingControllerDos.text = book.autor_name!;
                  _textEditingControllerTres.text = book.editorial_name!;
                  _textEditingControllerCuatro.text = book.date!;
                }),
                DataCell(Text(book.editorial_name!), onTap: () {
                  setState(() {
                    isUpdating = true;
                    curUserid = book.id!;
                  });
                  _textEditingControllerUno.text = book.name!;
                  _textEditingControllerDos.text = book.autor_name!;
                  _textEditingControllerTres.text = book.editorial_name!;
                  _textEditingControllerCuatro.text = book.date!;
                }),
                DataCell(Text(book.date!), onTap: () {
                  setState(() {
                    isUpdating = true;
                    curUserid = book.id!;
                  });
                  _textEditingControllerUno.text = book.name!;
                  _textEditingControllerDos.text = book.autor_name!;
                  _textEditingControllerTres.text = book.editorial_name!;
                  _textEditingControllerCuatro.text = book.date!;
                }),
              ]);
        }).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
          future: Books2,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return dataTable(snapshot.data!);
            }
            if (null == snapshot.hasData || snapshot.data?.length == 0) {
              return Text("Data no found");
            }
            return CircularProgressIndicator();
          }),
    );
  }

  String? _notempty(String? value) {
    if (value!.isEmpty == true) {
      return "Data Connot be Empty";
    } else {
      return null;
    }
    //return value! ? "Solo introduir letras" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    Navigator.pop(context);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [form(), list()],
          ),
        )
    );
  }
}
