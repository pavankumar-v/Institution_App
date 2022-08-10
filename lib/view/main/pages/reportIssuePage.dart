import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ReportIssue extends StatefulWidget {
  const ReportIssue({Key? key}) : super(key: key);

  @override
  State<ReportIssue> createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Report".text.make(),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.history))
        ],
      ),
    );
  }
}
