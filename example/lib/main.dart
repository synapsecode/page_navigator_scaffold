import 'package:flutter/material.dart';
import 'package:page_navigator_scaffold/page_navigator_scaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PageNavigatorScaffold Example',
      home: ExampleApp(),
    );
  }
}

PageNavigatorScaffold pageNavigatorScaffold(BuildContext context) {
  return PageNavigatorScaffold(
    pageNavigatorIcons: [Icons.home, Icons.work, Icons.people],
    pages: [
      Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("HomePage"),
            ElevatedButton(
                onPressed: () {
                  //Example of DeepNavigation
                  //Ability to Navigate to different pages within the Navigator
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PageNavigatorScaffoldHolder(
                        page: 2,
                        pageNavgiator: pageNavigatorScaffold(context),
                      ),
                    ),
                  );
                },
                child: Text("Go to People"))
          ],
        ),
      ),
      Container(padding: EdgeInsets.all(10), child: Text("WorkPage")),
      Container(padding: EdgeInsets.all(10), child: Text("PeoplePage")),
    ],
    pageNames: ["Home", "Work", "People"],
    bottomNavbarOptions: BottomNavBarOptions(
      backgroundColor: Colors.white60,
      activeColor: Colors.indigo,
      textColor: Colors.black,
      selectedTextSize: 12,
      unselectedTextSize: 10,
    ),
    drawer: Drawer(),
    appBarOptions: AppBarOptions(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      actions: [
        IconButton(icon: Icon(Icons.lightbulb), onPressed: () {}),
      ],
      backgroundColor: Colors.black54,
    ),
    scaffoldOptions: ScaffoldOptions(backgroundColor: Colors.blue[200]),
    pageWiseOptionalAppBarActions: {
      0: [IconButton(icon: Icon(Icons.account_balance), onPressed: () {})],
      1: [IconButton(icon: Icon(Icons.handyman), onPressed: () {})],
    },
  );
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageNavigatorScaffoldHolder(
      page: 0,
      pageNavgiator: pageNavigatorScaffold(context),
    );
  }
}
