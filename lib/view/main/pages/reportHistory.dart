import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import '../../../models/report.dart';

class ReportHistory extends StatefulWidget {
  const ReportHistory({Key? key}) : super(key: key);

  @override
  State<ReportHistory> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {
  var data;
  @override
  void initState() {
    // This is the type used by the popup menu below.
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    data = dataProvider.tickets;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: "History".text.make(),
        ),
        body: FutureBuilder<List<Report>?>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "❕".text.bold.xl4.make(),
                      "You don't have any issues raised."
                          .text
                          .center
                          .bold
                          .xl4
                          .color(Theme.of(context).hintColor)
                          .make(),
                    ]),
              );
            }

            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    data = DatabaseService().getTickets();
                  });
                },
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var report = snapshot.data![index];
                      return ListTile(
                        title: report.title.text.xl.capitalize.bold.make(),
                        subtitle: "${report.description.substring(0, 19)} ..."
                            .text
                            .make()
                            .pOnly(top: 3),
                        leading: report.isResolved
                            ? Icon(
                                Icons.done_rounded,
                                color: Vx.hexToColor("#004003"),
                              )
                                .p(10)
                                .card
                                .rounded
                                .color(Vx.hexToColor("#AAFF9C"))
                                .make()
                            : report.isStarted
                                ? Icon(
                                    Icons.timer_outlined,
                                    color: Vx.hexToColor("#403600"),
                                  )
                                    .p(10)
                                    .card
                                    .rounded
                                    .color(Vx.hexToColor("#FFF59C"))
                                    .make()
                                : Icon(
                                    Icons.pending_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  )
                                    .p(10)
                                    .card
                                    .rounded
                                    .color(Theme.of(context)
                                        .colorScheme
                                        .background)
                                    .make(),
                      )
                          .card
                          .rounded
                          .make()
                          .pOnly(top: 4, bottom: 4, left: 12, right: 12);
                    }),
              );
            } else {
              return const Text("Something went wrong");
            }
          },
        ));
  }
}
