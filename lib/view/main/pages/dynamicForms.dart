import 'package:brindavan_student/models/dynamicFormModel.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/view/main/pages/dynamicFormView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class DynamicForms extends StatefulWidget {
  const DynamicForms({Key? key}) : super(key: key);

  @override
  State<DynamicForms> createState() => _DynamicFormsState();
}

class _DynamicFormsState extends State<DynamicForms> {
  List colors = [
    '#367eed',
    '#3DAC71',
    '#D9016D',
    '#4F3DAC',
    '#A53DAC',
    '#0183D9',
    '#36474f',
    '#8800C1',
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: "Forms".text.make()),
      body: StreamBuilder<List<DynamicFormData?>?>(
        stream: dataProvider.forms,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      addAutomaticKeepAlives: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        DynamicFormData? formData = snapshot.data![index];

                        return SizedBox(
                          // color: Theme.of(context).canvasColor,
                          height: MediaQuery.of(context).size.height * 0.11,
                          child: Material(
                            clipBehavior: Clip.antiAlias,
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(11),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Row(),
                                formData!.name.text.xl.make(),
                                // data.id!.text.xl.white.uppercase.make(),
                                const Spacer(),
                                Row(
                                  children: [
                                    formData.isActive
                                        ? 'Active'.text.green500.make()
                                        : 'Closed'.text.red500.make(),
                                    const Spacer(),
                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints.tightFor(
                                              width: 108, height: 30),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: formData.isActive
                                                ? Vx.hexToColor(colors[index])
                                                : Theme.of(context)
                                                    .disabledColor,
                                          ),
                                          onPressed: () {
                                            if (formData.isActive) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DynamicFormPAge(
                                                            formData: formData,
                                                            // subject: data,
                                                            // curColor: colors[index],
                                                          )));
                                            }
                                          },
                                          child: 'Take Survey'
                                              .text
                                              .bold
                                              .sm
                                              .make()),
                                    )
                                  ],
                                )
                              ],
                            ).p(12),
                          ).card.elevation(10).rounded.make(),
                        ).pLTRB(12, 8, 12, 8);
                      })
                ],
              ),
            );
          } else {
            return Center(
              child: 'No Forms'.text.bold.lg.make(),
            );
          }
        },
      ),
    );
  }
}
