import 'package:brindavan_student/services/database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../models/file.dart';

class AvatarList extends StatefulWidget {
  const AvatarList({Key? key}) : super(key: key);

  @override
  State<AvatarList> createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList> {
  late Future<List<FirebaseFile>> futureFiles;
  String error = '';
  final _enabled = true;
  String path = '';

  @override
  void initState() {
    super.initState();
    futureFiles = DatabaseService.listAll('assets/avatars/students/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        color: Theme.of(context).colorScheme.primary,
        child: ElevatedButton(
          onPressed: path.isEmpty
              ? null
              : () {
                  dynamic result = DatabaseService().updateAvatar(path);
                  if (result != null) {
                    setState(() {
                      error = 'success';
                    });
                  }
                  Navigator.pop(context);
                },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                'Change',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: 'Select Avatar'.text.make(),
        actions: [
          if (path.isNotEmpty)
            CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black12,
                    backgroundImage: CachedNetworkImageProvider(path))
                .p(8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<FirebaseFile>>(
                future: futureFiles,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var avatarList = snapshot.data!;
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.vertical,
                        itemCount: avatarList.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                path = avatarList[index].url;
                              });
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.black12,
                                backgroundImage: CachedNetworkImageProvider(
                                    avatarList[index].url)),
                          ).p12();
                        }).p12();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Text('something went wrong');
                  }
                }),

            // ElevatedButton(
            //     onPressed: _enabled == true
            //         ? () {
            //             dynamic result = DatabaseService().updateAvatar(path);
            //             if (result != null) {
            //               setState(() {
            //                 error = 'success';
            //               });
            //             }
            //             Navigator.pop(context);
            //           }
            //         : null,
            //     child: 'submit'.text.make()),
          ],
        ),
      ),
    );
  }
}
