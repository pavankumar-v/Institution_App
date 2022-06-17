import 'dart:math';
import 'package:brindavan_student/models/user.dart';
import 'package:brindavan_student/provider/data_provider.dart';
import 'package:brindavan_student/view/main/pages/attendanceView.dart';
import 'package:brindavan_student/view/main/pages/dynamicForms.dart';
import 'package:brindavan_student/view/main/pages/enter_details.dart';
import 'package:brindavan_student/view/main/pages/home.dart';
import 'package:brindavan_student/view/main/pages/notification.dart';
import 'package:brindavan_student/view/main/pages/placementView.dart';
import 'package:brindavan_student/view/main/pages/profile_page.dart';
import 'package:brindavan_student/view/main/pages/select_avatar.dart';
import 'package:brindavan_student/view/main/pages/subject_list.dart';
import 'package:brindavan_student/view/main/pages/theme.dart';
import 'package:brindavan_student/services/auth.dart';
import 'package:brindavan_student/services/database.dart';
import 'package:brindavan_student/utils/loading.dart';
import 'package:brindavan_student/view/main/pages/warningView.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Navigate extends StatefulWidget {
  const Navigate({Key? key}) : super(key: key);

  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate>
    with AutomaticKeepAliveClientMixin<Navigate> {
  @override
  bool get wantKeepAlive => true;

  final AuthService _auth = AuthService();
  final PageStorageBucket _bucket = PageStorageBucket();

  var regex = RegExp(r'[A-Za-z]');

  Stream<UserData>? data;
  MyUser? user;
  String? imgUrl;

  bool loading = false;

  int _currentIndex = 0;
  List<Widget> tabs = [
    const Home(),
    const SubjectList(),
    const NotificationList(),
    const PlacementsView()
  ];

  @override
  void dispose() {
    // dataProvider!.dispose();
    super.dispose();
  }

  Future _initImg() async {
    List<dynamic> result = await DatabaseService().getImg();
    var randomNames = Random().nextInt(result.length);
    setState(() {
      imgUrl = result[randomNames];
    });
  }

  @override
  void initState() {
    _initImg();
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    data = dataProvider.userData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    var buttonStyle = ElevatedButton.styleFrom(
      elevation: 10,
      primary: Theme.of(context).backgroundColor,
      onPrimary: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    super.build(context);

    return loading
        ? const Loading()
        : StreamBuilder<UserData?>(
            stream: data,
            builder: (context, snapshot) {
              UserData? userData = snapshot.data;

              if (snapshot.hasData) {
                // ignore: unnecessary_null_comparison
                if (userData!.fullName.isEmpty) {
                  return EnterDetails(userData: userData);
                } else if (!userData.isActive) {
                  return const UserInactive();
                } else {
                  return Scaffold(
                      extendBody: true,
                      body: IndexedStack(
                        index: _currentIndex,
                        children: tabs,
                      ),
                      bottomNavigationBar: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: BottomNavigationBar(
                          currentIndex: _currentIndex,
                          backgroundColor: Theme.of(context).primaryColor,
                          selectedItemColor: Colors.white,
                          unselectedItemColor: Colors.white.withOpacity(.60),
                          selectedFontSize: 10,
                          selectedLabelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          unselectedFontSize: 10,
                          type: BottomNavigationBarType.fixed,
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home_rounded),
                              label: 'Home',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.article_rounded),
                              label: 'Subjects',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.notifications),
                              label: 'Notification',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.business_outlined,
                              ),
                              label: 'Placements',
                            ),
                          ],
                          onTap: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ).h(80),
                      ).p(17),
                      drawer: SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Drawer(
                            child: Container(
                          color: Theme.of(context).backgroundColor,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.60,
                                child: DrawerHeader(
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              '$imgUrl'),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.6),
                                              BlendMode.darken),
                                        )),
                                    child: UserAccountsDrawerHeader(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent),
                                        color: Colors.transparent,
                                      ),
                                      accountName:
                                          userData.fullName.text.make(),
                                      accountEmail:
                                          '${user!.email}'.text.make(),
                                      currentAccountPicture: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AvatarSelector()));
                                        },
                                        child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                          userData.avatar,
                                        )),
                                      ),
                                    )),
                              ),
                              Container(
                                  color: Theme.of(context).canvasColor,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                            userData: userData,
                                                            imgUrl: imgUrl,
                                                          )));
                                            });
                                          },
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.person_rounded),
                                            title: 'Profile'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ThemeSwitcher()));
                                            });
                                          },
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.palette_rounded),
                                            title: 'Theme'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Attendance(
                                                            userData: userData,
                                                          )));
                                            });
                                          },
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.app_registration_rounded,
                                            ),
                                            title: 'Attendace'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DynamicForms()));
                                            });
                                          },
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.description_rounded,
                                            ),
                                            title: 'Forms'.text.make(),
                                          ),
                                        ).p12(),
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () async {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200),
                                                () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              await _auth.signOut();
                                            });
                                          },
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.logout_rounded),
                                            title: 'Sign Out'.text.make(),
                                          ),
                                        ).p12(),
                                        'Version 1.0.0'
                                            .text
                                            .color(Theme.of(context).hintColor)
                                            .hairLine
                                            .lg
                                            .make()
                                            .p16(),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary:
                                                Theme.of(context).primaryColor,
                                            onPrimary: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: ListTile(
                                            leading: const Icon(Icons
                                                    .settings_accessibility_rounded)
                                                .iconColor(Colors.white),
                                            title: 'About'
                                                .text
                                                .color(Colors.white)
                                                .make(),
                                          ),
                                        ).p12(),
                                      ])).p12()
                            ],
                          ),
                        )),
                      ));
                }
              } else {
                return const Loading();
              }
            });
  }
}
