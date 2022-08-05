import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AppUpdate extends StatelessWidget {
  final appUpdateData;
  const AppUpdate({Key? key, required this.appUpdateData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: ["App Update".text.xl.make()],
          ),

          FloatingActionButton(onPressed: (){}, child: Text("Button"),)
        ],
      ),
    );
  }
}
