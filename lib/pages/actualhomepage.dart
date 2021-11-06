import 'package:flutter/material.dart';

import 'package:picture_uploads/avicenna/avicenna.dart' as avicenna;
import 'package:picture_uploads/pages/secondpage.dart';

class MenuItem {
  MenuItem({
    required this.id,
    required this.name
  });

  final id;
  final name;
}

class ActualHomePage extends StatefulWidget {

  @override
  _ActualHomePageState createState() => _ActualHomePageState();
}

class _ActualHomePageState extends State<ActualHomePage> with WidgetsBindingObserver {

  Future navigateToPage(context, Widget goto) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => (goto)));
  }

  List<MenuItem> items = [
    MenuItem(id: 1, name: 'monde'),
    MenuItem(id: 2, name: 'kadal'),
    MenuItem(id: 3, name: 'kicauan'),
    MenuItem(id: 4, name: 'linsang'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text('Photos', style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black
        )),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: avicenna.Colors.background,//Color(0xFFF7F8FA),
        actions: [
        // IconButton(onPressed: _pickProfile, icon: Icon(Icons.file_download), tooltip: 'Import Profile from file'),
        // IconButton(onPressed: _newProfile, icon: Icon(Icons.add), tooltip: 'Create Profile'),
        ],
      ),
      backgroundColor: avicenna.Colors.background,//Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 48),
              child: ListView(
                padding: EdgeInsets.only(bottom: 20),
                children: [
                  for (var item in items)
                    avicenna.TappableContainer(
                      onTap: () {
                        navigateToPage(context, SecondPage(menu: item));
                      },
                      child: Text(item.name),
                    )
                ]
              )
            ),
            Container(
              color: avicenna.Colors.background,
              padding: EdgeInsets.only(left: 18, top: 0, right: 12, bottom: 18),
              width: MediaQuery.of(context).size.width,
              child: Text('Tap + to add new profile or tap on download icon to import profile. Tap on profile to send and hold to edit'),
            )
          ],
        )
      )
    );
  }
}