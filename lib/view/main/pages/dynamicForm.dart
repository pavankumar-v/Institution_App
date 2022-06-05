import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/constants.dart';

class DynamicFormPAge extends StatefulWidget {
  const DynamicFormPAge({Key? key}) : super(key: key);

  @override
  State<DynamicFormPAge> createState() => _DynamicFormPAgeState();
}

class _DynamicFormPAgeState extends State<DynamicFormPAge> {
  final _formKey = GlobalKey<FormState>();
  //
  List<Map<String, dynamic>> formData = [
    {"type": "s", "fieldName": "name"},
    {"type": "i", "fieldName": "Marks"},
    {"type": "i", "fieldName": "cgpa"},
  ];
  int _count = 0;
  String? _result;
  List<Map<String, dynamic>>? _values;

  @override
  void initState() {
    super.initState();
    _count = formData.length;
    _values = [];
    _result = "";
  }

  @override
  Widget build(BuildContext context) {
    var enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor));
    var fillColor = Theme.of(context).cardColor;
    return Scaffold(
      appBar: AppBar(
        title: 'Dynamic Form'.text.make(),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  _count = 0;
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: _count,
                      itemBuilder: (context, index) {
                        var fieldName = formData[index]["fieldName"];
                        var type = formData[index]["type"];
                        return _row(
                            index, enabledBorder, fillColor, fieldName, type);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.black.withOpacity(0.05),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              for (var val in _values!) {}
                            }
                          },
                          child: 'LOGIN'.text.sm.bold.white.make().p16().px1())
                      .p16(),
                  // Text(_result!)
                ],
              ),
            ),
          )),
    );
  }

  _row(int key, var enabledBorder, var fillColor, var fieldName, var type) {
    return TextFormField(
      decoration: textInputDecoration.copyWith(
          hintText: 'Enter $fieldName',
          labelText: '$fieldName',
          helperText: '$type',
          // prefixIcon: const Icon(Icons.mail),
          enabledBorder: enabledBorder,
          fillColor: fillColor),
      onChanged: (val) => {_onUpdate(key, val, type)},
      validator: (val) {
        bool stringMatch = RegExp('[a-zA-Z]').hasMatch(val!.trim());
        bool number = RegExp(r'\d').hasMatch(val.trim());
        if (val.isEmpty) {
          return 'This field is required';
        } else if (type == "i") {
          if (!number) {
            return 'Enter only numbers from 0-9';
          }
        } else if (type == "s") {
          if (!stringMatch) {
            return 'Enter only characters from a-b or A-B';
          }
        }

        return null;
      },
    ).py(8);
  }

  _onUpdate(int key, dynamic val, var type) {
    int foundKey = -1;
    for (var map in _values!) {
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _values!.removeWhere((map) {
        return map['id'] == foundKey;
      });
    }

    if (type == "i") {
      int.parse(val);
    }
    Map<String, dynamic> json = {"id": key, "value": val};

    _values!.add(json);

    setState(() {
      _result = _prittyPrint(_values);
    });
  }

  String _prittyPrint(jsonObject) {
    var encoder = const JsonEncoder.withIndent('     ');
    return encoder.convert(jsonObject);
  }
}
