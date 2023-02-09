import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Icon miIcono;
  final FormFieldValidator<String> _validator;
  final TextEditingController;

  CustomTextField(this.hint, this.miIcono, this.TextEditingController, this._validator);
  //({Key? key, required this.hint, required this.miIcono}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextFormField(
        validator: _validator,
        controller: TextEditingController,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontWeight: FontWeight.bold,
          fontSize: 20),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.teal.shade300,
              width: 3,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.teal.shade300,
              width: 3,
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: this.miIcono
          )
        ),
      ),
    );
  }
}


