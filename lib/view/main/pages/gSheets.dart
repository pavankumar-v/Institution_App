import 'package:brindavan_student/services/database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Gsheets extends StatefulWidget {
  const Gsheets({Key? key}) : super(key: key);

  @override
  State<Gsheets> createState() => _GsheetsState();
}

class _GsheetsState extends State<Gsheets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: 'Gsheets'.text.make(),
        ),
        body: Container(
          child: SingleChildScrollView(
              child: Form(
                  child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final user = {
                      'id': 1,
                      'name': 'paul',
                      'email': 'paul@gmail.com',
                      'isBegginner': false,
                    };
                    // print(user);

                    DatabaseService().foo();
                  },
                  child: 'submit'.text.make()),
            ],
          ))),
          // child: ElevatedButton(
          //     onPressed: () async {
          //       final user = {
          //         UserFields.id: 1,
          //         UserFields.name: 'paul',
          //         UserFields.email: 'paul@gmail.com',
          //         UserFields.isBeginner: false,
          //       };
          //       await UserSheetsApi.insert([user]);
          //     },
          //     child: 'submit'.text.make()),
        ));
  }
}
