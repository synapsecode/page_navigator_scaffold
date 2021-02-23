library page_navigator_scaffold;

import 'package:flutter/material.dart';

class PageNavigatorScaffoldHolder extends StatelessWidget {
  ///The PageNavigator
  final PageNavigatorScaffold pageNavgiator;

  ///Index of Page
  final int page;

  ///PageNavigatorScaffoldHolder is a widget that makes it easy to use PageNavigatorScaffold
  ///with the Flutter Routing Navigator. Using this, you can push a MaterialRoute that contains
  ///a specific page and the page will be open once opened!
  const PageNavigatorScaffoldHolder({
    Key key,
    this.pageNavgiator,
    this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    pageNavgiator.initialIndex = page;
    return pageNavgiator;
  }
}

class PageNavigatorScaffold extends StatefulWidget {
  ///[initialIndex] is the page that is displayed first
  int initialIndex;

  ///@required [pages] is the list of all the Widgets for each page
  final List<Widget> pages;

  ///[pageNames] is a List of Strings that contain all the names of the individual pages!
  final List<String> pageNames;

  ///[pageWiseOptionalAppBarActions] is a Map<int, List> where the key is the page index
  ///and the List Contains All the Widgets that should be displayed left of the
  ///AppBarActions. These actions change based on each page
  final Map<int, List> pageWiseOptionalAppBarActions;

  ///@required [pageNavigatorIcons] is the List of IconData's that is used for the Icons of the BottomNavBarItems
  final List<IconData> pageNavigatorIcons;

  ///This determines how inter-page scrolling physics works
  final ScrollPhysics scrollPhysics;

  final Widget drawer;
  final Widget floatingActionButton;

  ///uses the AppBarOptions class which helps customization of the AppBar
  final AppBarOptions appBarOptions;

  ///uses the ScaffoldOptions class which helps customization of the Scaffold
  final ScaffoldOptions scaffoldOptions;

  ///uses the BottonNavBarOptions class which helps customization of the BottomNavBar
  final BottomNavBarOptions bottomNavbarOptions;

  ///The PageNavigatorScaffold is a Widget that makes it extremely simple to make Multi Page
  ///Tabbed Pages. Swiping moves Pages and Cliking on the BottomNavBarItems also changes the pages.
  ///Use this Widget to Simplify your App UI needs!
  PageNavigatorScaffold({
    Key key,
    this.initialIndex = 0,
    @required this.pages,
    this.pageWiseOptionalAppBarActions,
    this.pageNames,
    @required this.pageNavigatorIcons,
    this.appBarOptions,
    this.scrollPhysics,
    this.drawer,
    this.scaffoldOptions,
    this.bottomNavbarOptions,
    this.floatingActionButton,
  })  : assert(pages != null &&
            pages.length != 0 &&
            pages.length == pageNavigatorIcons.length),
        assert(pageNavigatorIcons != null &&
            pages.length != 0 &&
            pages.length == pageNavigatorIcons.length),
        super(key: key);

  @override
  _PageNavigatorScaffoldState createState() => _PageNavigatorScaffoldState();
}

class _PageNavigatorScaffoldState extends State<PageNavigatorScaffold>
    with SingleTickerProviderStateMixin {
  int currentPage;
  TabController _controller;
  List<Widget> tabPages;
  int ci = 0;

  @override
  void initState() {
    tabPages = [...widget.pages];
    currentPage = widget.initialIndex;
    _controller = TabController(
      initialIndex: widget.initialIndex,
      vsync: this,
      length: tabPages.length,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Adding OptionalActions
    List opActions = (widget.pageWiseOptionalAppBarActions != null)
        ? widget.pageWiseOptionalAppBarActions.containsKey(currentPage)
            ? widget.pageWiseOptionalAppBarActions[currentPage]
            : []
        : [];

    List<Widget> actions = [
      ...(opActions),
      ...(widget.appBarOptions?.actions ?? [])
    ];

    //PageControllerListener
    _controller.addListener(() {
      if (currentPage != _controller.index)
        setState(() => currentPage = _controller.index);
    });

    //Rendering
    return Scaffold(
      key: widget.scaffoldOptions?.scaffoldKey,
      backgroundColor: widget.scaffoldOptions?.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
      drawer: widget.drawer,
      persistentFooterButtons: widget.scaffoldOptions?.persistentFooterButtons,
      appBar: AppBar(
        brightness: widget.appBarOptions?.brightness,
        leading: widget.appBarOptions?.leading,
        elevation: widget.appBarOptions?.elevation,
        shadowColor: widget.appBarOptions?.shadowColor,
        shape: widget.appBarOptions?.shape,
        backgroundColor: widget.appBarOptions?.backgroundColor,
        toolbarHeight: widget.appBarOptions?.appBarHeight,
        centerTitle: widget.appBarOptions?.centeredTitle,
        toolbarOpacity: widget.appBarOptions?.toolbarOpacity ?? 1,
        bottom: widget.appBarOptions?.bottom,
        iconTheme: IconThemeData(color: widget.appBarOptions?.foregroundColor),
        title: Text(
          widget.appBarOptions?.title ??
              (widget.pageNames?.elementAt(currentPage) ?? "AppBar"),
          style: TextStyle(color: widget.appBarOptions?.foregroundColor),
        ),
        actions: actions,
      ),
      body: TabBarView(
        controller: _controller,
        children: tabPages,
        physics: widget.scrollPhysics,
      ),
      bottomSheet: widget.scaffoldOptions?.bottomSheeet,
      bottomNavigationBar: BottomNavigationBar(
        // fixedColor: widget.bottomNavbarOptions?.textColor,
        selectedItemColor: widget.bottomNavbarOptions?.activeColor ??
            widget.bottomNavbarOptions?.textColor ??
            Colors.white,
        iconSize: widget.bottomNavbarOptions?.iconSize ?? 24.0,
        backgroundColor:
            widget.bottomNavbarOptions?.backgroundColor ?? Colors.blue,
        type: widget.bottomNavbarOptions?.bottomNavigationBarType ??
            BottomNavigationBarType.fixed,
        unselectedFontSize: widget.bottomNavbarOptions?.unselectedTextSize ?? 0,
        selectedFontSize: widget.bottomNavbarOptions?.selectedTextSize ?? 0,
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _controller.animateTo(page);
          });
        },
        items: [
          ...widget.pageNavigatorIcons
              .asMap()
              .entries
              .map(
                (entry) => BottomNavigationBarItem(
                  tooltip: widget.pageNames?.elementAt(entry.key) ?? "",
                  icon: Icon(entry.value,
                      color: widget.bottomNavbarOptions?.baseColor),
                  activeIcon: Icon(entry.value,
                      color: widget.bottomNavbarOptions?.activeColor),
                  label: widget.bottomNavbarOptions?.labels
                          ?.elementAt(entry.key) ??
                      widget.pageNames?.elementAt(entry.key) ??
                      "",
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

///This Class Contains all the Optional Arguements that can be provided to the
///AppBar. This is Useful when you want to customize the AppBar Properties.
class AppBarOptions {
  ///[title] Specifies the Common AppBar Title. If this is Provided, the Value of Title wont change on a page-to-page basis
  final String title;
  final Color backgroundColor;

  ///[foregroundColor] is the Color that will be used for the Title Text and the toolbar Icons
  final Color foregroundColor;
  final double toolbarOpacity;
  final Brightness brightness;
  final Widget leading;
  final double elevation;
  final Color shadowColor;
  final ShapeBorder shape;
  final double appBarHeight;

  ///[centeredTitle] is a boolean value that should be set to true if you want the title in the center
  final bool centeredTitle;
  final PreferredSizeWidget bottom;

  ///[actions] are the regular AppBar Actions.
  final List<Widget> actions;

  AppBarOptions({
    this.actions,
    this.title,
    this.bottom,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.toolbarOpacity = 1.0,
    this.brightness,
    this.leading,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.appBarHeight,
    this.centeredTitle,
  });
}

///This Class Contains all the Optional Arguements that can be provided to the BottomNavigationBar
class BottomNavBarOptions {
  ///[lables] this is a list of Strings (optional) that are used as values for the Text below the Icons. If not provided, it defaults to PageNames or Stays Empty
  final List<String> labels;

  ///[baseColor] is the unselected Color for the Icons
  final Color baseColor;

  ///[activeColor] is the selected Color for the Icons
  final Color activeColor;
  final Color backgroundColor;
  final Color textColor;

  ///[selectedTextSize] Set this to more than 0 for the Text to Be Visible. This will be visible when the current tab is selected
  final double selectedTextSize;

  ///[unselectedTextSize] Set this to more than 0 for the Text to be Visible. This will be visible when current tab is unselected
  final double unselectedTextSize;

  ///[iconSize] this sets the IconSize for the BottomNavBarItem
  final double iconSize;
  final BottomNavigationBarType bottomNavigationBarType;

  BottomNavBarOptions({
    this.baseColor,
    this.activeColor,
    this.backgroundColor = Colors.blue,
    this.textColor,
    this.selectedTextSize = 0,
    this.unselectedTextSize = 0,
    this.iconSize = 24,
    this.bottomNavigationBarType = BottomNavigationBarType.fixed,
    this.labels,
  });
}

class ScaffoldOptions {
  final Key scaffoldKey;
  final Color backgroundColor;
  final Widget bottomSheeet;
  final List<Widget> persistentFooterButtons;

  ScaffoldOptions({
    this.scaffoldKey,
    this.backgroundColor,
    this.bottomSheeet,
    this.persistentFooterButtons,
  });
}

/*
USAGE Example
PageNavigatorScaffoldHolder(
  page: 0,
pageNavigator: PageNavigatorScaffold(
    pageNames: ["HomePage", "EcoPage", "Library", "Images", "Audio"],
    bottomNavbarOptions: BottomNavBarOptions(
      pageNavigatorActiveColor: Colors.black,
      pageNavigatorBackgroundColor: Colors.white,
      pageNavigatorBaseColor: Colors.grey,
      selectedTextSize: 10,
      unselectedTextSize: 10,
      labels: ["Home", "Eco", "Library", "Pics", "Music"],
    ),
    scaffoldOptions: ScaffoldOptions(
      scaffoldBackgroundColor: Colors.white,
    ),
    appBarOptions: AppBarOptions(
      elevation: 1,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      toolbarOpacity: 0.8,
      actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {},
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.black,
      child: Icon(Icons.inbox),
    ),
    pageWiseOptionalAppBarActions: {
      0: [
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {},
        ),
      ],
      1: [
        IconButton(
          icon: Icon(Icons.lightbulb),
          onPressed: () {},
        ),
      ],
      4: [
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {},
        ),
      ]
    },
    drawer: Drawer(),
    pages: [
      Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              child: Text("Go To Eco Page"),
              onPressed: () {
                Navigator.pushNamed(context, '/eco');
              },
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(20),
        child: Text("Eco"),
      ),
      Container(
        padding: EdgeInsets.all(20),
        child: Text("Library"),
      ),
      Container(
        padding: EdgeInsets.all(20),
        child: Text("Images"),
      ),
      Container(
        padding: EdgeInsets.all(20),
        child: Text("Audio"),
      ),
    ],
    pageNavigatorIcons: [
      Icons.home,
      Icons.eco,
      Icons.library_add,
      Icons.image,
      Icons.audiotrack
    ],
  )
);
*/
