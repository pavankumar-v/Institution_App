import 'package:brindavan_student/models/report.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/utils/constants.dart';
import 'package:brindavan_student/view/main/pages/reportHistory.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/user.dart';

class ReportIssue extends StatefulWidget {
  final UserData userData;
  final MyUser user;
  const ReportIssue({Key? key, required this.userData, required this.user})
      : super(key: key);

  @override
  State<ReportIssue> createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<String>? issues = [];
  String? email;
  Report report = Report(
      name: "name",
      uid: "uid",
      title: "title",
      description: "description",
      createdAt: DateTime.now().toIso8601String(),
      attactments: [],
      isStarted: false,
      isResolved: false,
      remarks: "");

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    var enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor));
    var fillColor = Theme.of(context).cardColor;
    report.name = widget.userData.fullName;
    report.uid = widget.user.uid;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: "Report".text.make(),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReportHistory()));
            },
            child: Row(children: ["HISTORY".text.lg.make().px(12)]),
          )
          // IconButton(
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => const ReportHistory()));
          //     },
          //     icon: const Icon(Icons.history))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: DatabaseService().getIssues(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return form(fillColor, enabledBorder, snapshot);
          },
        ),
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).colorScheme.primary,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isLoading = true;
              });
              dynamic result = await DatabaseService().raiseTicket(report);
              setState(() {
                _isLoading = false;
              });
              if (result) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ReportHistory()));
                _formKey.currentState!.reset();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(snackbar(
                    context, "Something went wrong, could not raise issue", 5));
              }
            }
          },
          child: SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : "Report".text.bold.make(),
            ),
          ),
        ),
      ),
    );
  }

  Form form(Color fillColor, OutlineInputBorder enabledBorder, snapshot) {
    issues = [];
    snapshot.data["issues"].forEach((ele) => issues!.add(ele.toString()));
    issues!.add("Others");
    // issues = snapshot.data["issues"];
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField(
            isExpanded: true,
            decoration: textInputDecoration.copyWith(
                fillColor: fillColor,
                enabledBorder: enabledBorder,
                hintText: 'Select Issue'),
            items: issues!.map<DropdownMenuItem<String>>((String? value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
            onChanged: (val) {
              report.title = val as String;
            },
            validator: (value) {
              if (value == null) {
                return 'select issue';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: textInputDecoration.copyWith(
                hintText: 'Link1,Link2,Link3',
                labelText: "Snapshot Links",
                helperText:
                    "Provide snapshot links seperated by comma, upload to google drive or other platform, making it visible to all.",
                enabledBorder: enabledBorder,
                fillColor: fillColor),
            onChanged: (val) {
              setState(() {
                report.attactments = val.trim().split(",");
              });
            },
          ).py12(),
          TextFormField(
            maxLines: 10,
            decoration: textInputDecoration.copyWith(
                hintText: 'Enter Description',
                // labelText: "Description",
                helperText:
                    "Provide appropriate description to understand the issue better.",
                enabledBorder: enabledBorder,
                fillColor: fillColor),
            onChanged: (val) {
              report.description = val;
            },
            validator: (val) {
              if (val!.isEmpty) {
                return 'This field is required';
              } else if (val.length < 20) {
                return 'Please give detailed information of the issue.';
              }
              return null;
            },
          ).py12()
        ],
      ).p(16),
    );
  }
}
