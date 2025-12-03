import 'package:flutter/material.dart';

class Signuppagescreen extends StatelessWidget {
  const Signuppagescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            
             TextFormField(
                  keyboardType: TextInputType.number,
                  
                  decoration: InputDecoration(
                    labelText: "Enter second no:",
                    hintText: "e.g",
                   border:  OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.purple)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red),
                    )
                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return "Please enter first number.";
                    }
                    return null;
                    },
                ),
          ]
            
        ),
      ),
    );
  }
}