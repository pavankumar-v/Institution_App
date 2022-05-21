import 'package:brindavan_student/models/notificationdata.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:date_format/date_format.dart';

class NotificationWidget extends StatefulWidget {
  final NotificationData? notification;
  const NotificationWidget({Key? key, required this.notification})
      : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.notification;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: Colors.grey.shade700,
          )),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(data!.avatar),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  data.fullName.text.bold.make(),
                  Row(
                    children: [
                      data.position.text.uppercase.lineHeight(1.5).sm.make(),
                      (formatDate(DateTime.parse(data.createdAt),
                              [MM, ' ', d, ', ', yyyy]))
                          .text
                          .lineHeight(1.5)
                          .sm
                          .italic
                          .color(Theme.of(context).hintColor)
                          .make()
                          .pLTRB(6, 0, 0, 0)
                    ],
                  )
                ]).pOnly(left: 12),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            data.title.text.lg.bold.make(),
            const SizedBox(
              height: 10,
            ),
            data.description.text.lineHeight(1.5).sm.make(),
          ],
        ).p(23),
      ]),
    ).py12();
  }
}
