import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:picture_uploads/avicenna/avicenna.dart' as avicenna;
import 'package:hive_flutter/hive_flutter.dart';

class HiveExplorer extends StatefulWidget {

  @override
  _HiveExplorerState createState() => _HiveExplorerState();
}

class _HiveExplorerState extends State<HiveExplorer> with WidgetsBindingObserver {
  late Box box;
  String boxName = '';
  bool boxOpened = false;
  List<SliverList> innerLists = [];
  List<dynamic> listObjects = [];
  bool showField = true;

  Future navigateToPage(context, Widget goto) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => (goto)));
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    bool boxAvailable = await Hive.boxExists(boxName);
    setState(() {
      listObjects = [];
      boxOpened = false;
    });
    if (boxAvailable) {
      box = await Hive.openBox(boxName);
      setState(() {
        listObjects = box.values.toList();
        boxOpened = true;
      });
      box.values.forEach((element) {
        List<Widget> children = [];
        jsonDecode(jsonEncode(element)).forEach((k, v) =>
            children.add(Text("$k : $v")));

        innerLists.add(
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => children[index],
              childCount: children.length,
            ),
          ),
        );
      });
    } else {
      showDialog(context: context, builder: (context) {
        return avicenna.CustomDialog(
          title: "Box didn't exist",
        );
      });
    }
  }

  Widget dataPresenter(Map<String, dynamic> object) {
    String text = '';
    object.forEach((k, v) => text += "\n$k : $v\n" );
    return avicenna.TappableContainer(
      child: Text(text),
      onTap: (){}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          title: Text('Hive Explorer', style: TextStyle(
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
            IconButton(onPressed: () => setState(() => showField = !showField), icon: Icon(showField ? Icons.arrow_upward : Icons.arrow_downward), tooltip: showField ? 'Hide' : 'Show'),
            // IconButton(onPressed: _newProfile, icon: Icon(Icons.add), tooltip: 'Create Profile'),
          ],
        ),
        backgroundColor: avicenna.Colors.background,//Color(0xFFF7F8FA),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: showField ? 120 : 24),
                // child: CustomScrollView(
                //   slivers: innerLists
                child: ListView(
                  padding: EdgeInsets.only(bottom: 20),
                  children: [
                    if (boxOpened) for (var mon in listObjects)
                      dataPresenter(jsonDecode(jsonEncode(mon)))
                  ]
                )
              ),
              if (!showField) Container(
                color: avicenna.Colors.background,
                padding: EdgeInsets.only(left: 18, top: 0, right: 18, bottom: 4),
                width: MediaQuery.of(context).size.width,
                child: Text('${listObjects.length} items')
              ),
              if (showField) Container(
                color: avicenna.Colors.background,
                padding: EdgeInsets.only(left: 18, top: 0, right: 18, bottom: 4),
                width: MediaQuery.of(context).size.width,
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      avicenna.TextField(
                        textFieldStyle: avicenna.TextFieldStyle.border,
                        title: 'Box Name',
                        onChanged: (value) {
                          setState(() => boxName = value);
                        },
                      ),
                      SizedBox(height: 4),
                      avicenna.Button(
                        text: 'Apply',
                        onPressed: () {
                          loadPrefs();
                        },
                      )
                    ]
                  )
                ),
              )
            ],
          )
      )
    );
  }
}