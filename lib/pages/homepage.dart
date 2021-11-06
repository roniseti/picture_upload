import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// import 'package:picture_uploads/avicenna/avicenna.dart' as avicenna;
import 'package:picture_uploads/src/models/photo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

import 'package:avicenna/avicenna.dart' as avicenna;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late SharedPreferences prefs;
  List<Photo> temp = [];

  Future navigateToPage(context, Widget goto) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => (goto)));
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('album');
    List<Photo> album = [];
    if (data != null) {
      var photos = jsonDecode(data);
      photos.forEach((photo) {
        album.add(Photo.fromJson(jsonDecode(jsonEncode(photo))));
      });
      setState(() {
        momon = album;
      });
    }
  }

  List<Photo> momon = [];

  Widget monde(Photo photo, int index) {
    return avicenna.TappableContainer(
      onLongPress: (){},
      boxShadow: avicenna.Props.boxShadowSoft,
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return avicenna.DoubleDialog(
              title: 'View Image',
              info: (File(photo.imageLocal!).lengthSync() / 1000).toString() + ' KB\n' + (File(photo.thumbLocal!).lengthSync() / 1000).toString() + ' KB',
              // info: photo.isUploaded ? photo.imageUrl : photo.imageLocal,
              actions: [
                avicenna.ModalActionItem(text: '',child: avicenna.TextField(
                  textFieldStyle: avicenna.TextFieldStyle.border,
                  initialValue: photo.title,
                  onChanged: (val) => setState(() => photo.title = val),
                ), onPressed: null, withTopBorder: false),
                if (!photo.isUploaded) avicenna.ModalActionItem(
                    text: 'Upload Photo',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_sharp),
                        SizedBox(width: 12),
                        Text('Upload Photo',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                        ),
                      ],
                    ),
                    onPressed: (){Navigator.pop(context);}
                  ),
                avicenna.ModalActionItem(
                  text: 'Hapus',
                  onPressed: () async {
                    await File(photo.imageLocal!).delete();
                    await File(photo.thumbLocal!).delete();
                    setState(() => momon.removeAt(index));
                    prefs.setString('album', jsonEncode(momon));
                    Navigator.pop(context);
                  },
                  isDestructive: true
                ),
                avicenna.ModalActionItem(text: 'Kembali', onPressed: (){Navigator.pop(context);}),
              ],
              insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              content: IntrinsicHeight(
                child: SingleChildScrollView(
                  child:
                  // Column(
                  //   children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: photo.isUploaded ? Image.network(photo.imageUrl!) : Image.file(File(photo.imageLocal!), fit: BoxFit.cover)
                        ),
                        width: MediaQuery.of(context).size.width /3,
                        // height: MediaQuery.of(context).size.width - 260,
                      ),
                      // SizedBox(height: 12),
                      // avicenna.TextField(
                      //   textFieldStyle: avicenna.TextFieldStyle.border,
                      //   initialValue: photo.title,
                      //   onChanged: (val) => setState(() => photo.title = val),
                      // )
                    // ],
                  // ),
                ),
              ),
            );
          },
        );
      },
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.zero,
      color: Colors.white70,
      child: Stack(
        children: [
          Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: photo.isUploaded ? Image.network(photo.thumbUrl!) : Image.file(File(photo.thumbLocal!), fit: BoxFit.cover)
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  photo.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                )
              )
            ],
          ),
          Positioned(
            right: 0,
            child: !photo.isUploaded ? avicenna.IconButton(
              color: Color(0xAAFFFFFF),
              onTap: () async {
                print(photo.imageLocal);
                await Share.shareFiles([photo.imageLocal!, photo.thumbLocal!], text: photo.title);
                // setState(() => photo.isUploaded = !photo.isUploaded );
              },
              icon: photo.isUploaded ? Icon(Icons.check) : Icon(Icons.upload_sharp),
            ) : IconButton(
              color: Color(0xAAFFFFFF),
              onPressed: (){
                setState(() => photo.isUploaded = !photo.isUploaded );
              },
              icon: photo.isUploaded ? Icon(Icons.check) : Icon(Icons.upload_sharp),
            )
          )
        ],
      )
    );
  }

  late File _image;
  List<int> imageBytes = [];
  final picker = ImagePicker();

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
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          itemCount: momon.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: MediaQuery.of(context).orientation == Orientation.landscape ? ((MediaQuery.of(context).size.width - 144) / MediaQuery.of(context).size.width) : ((MediaQuery.of(context).size.width - 78) / MediaQuery.of(context).size.width)
          ),
          itemBuilder: (context, index) {
            return momon.length != index
              ? monde(momon[index], index)
              : avicenna.TappableContainer(
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: Colors.blueAccent),
                    SizedBox(height: 12),
                    Text('Add new photo', style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500
                    ),)
                  ],
                ),
                onTap: () async {
                  var source;
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return avicenna.CustomDialog(
                        title: 'Ambil Gambar',
                        info: 'Ambil gambar dari kamera atau galeri',
                        content: Container(
                            // decoration: BoxDecoration(
                            //     color: avicenna.Colors.white,
                            //     borderRadius: BorderRadius.all(
                            //         Radius.circular(12)),
                            //     boxShadow: avicenna.Props.boxShadowInverted
                            // ),
                            padding: EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                avicenna.IconButton(
                                  tooltip: 'Camera',
                                  icon: Icon(Icons.camera_alt),
                                  onTap: () {
                                    setState(() {
                                      source = ImageSource.camera;
                                      Navigator.pop(context);
                                    });
                                  }
                                ),
                                avicenna.IconButton(
                                    tooltip: 'Gallery',
                                    icon: Icon(Icons.image),
                                    onTap: () {
                                      setState(() {
                                        source = ImageSource.gallery;
                                        Navigator.pop(context);
                                      });
                                    }
                                )
                              ],
                            )
                        ),
                      );
                    }
                  );

                  if (source != null) {
                    final pickedFile = await picker.pickImage(
                      source: source,
                      imageQuality: 25,
                      maxHeight: 2000,
                      maxWidth: 2000
                    );

                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                      imageBytes = _image.readAsBytesSync();
                      // var base64Image = base64Encode(imageBytes);

                      File? croppedFile = await ImageCropper.cropImage(
                        compressQuality: 50,
                        maxHeight: 2000,
                        maxWidth: 2000,
                        sourcePath: pickedFile.path,
                        aspectRatioPresets: Platform.isAndroid
                          ? [
                          // CropAspectRatioPreset.original,
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                          ]
                          : [
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio5x3,
                          CropAspectRatioPreset.ratio5x4,
                          CropAspectRatioPreset.ratio7x5,
                          CropAspectRatioPreset.ratio16x9
                          ],
                        androidUiSettings: AndroidUiSettings(
                          toolbarTitle: 'Edit Gambar',
                          statusBarColor: avicenna.Colors.secondBlack,
                          toolbarColor: Colors.white,
                          backgroundColor: Colors.white,
                          toolbarWidgetColor: Colors.black,
                          activeControlsWidgetColor: Colors.blue,
                          initAspectRatio: CropAspectRatioPreset.ratio4x3,
                          dimmedLayerColor: Color(0x44000000),
                          lockAspectRatio: false),
                        iosUiSettings: IOSUiSettings(
                          title: 'Edit Gambar',
                        ));
                      if (croppedFile != null) {
                        _image = croppedFile;
                        var title = '';

                        ImageProperties properties = await FlutterNativeImage.getImageProperties(_image.path);
                        File _thumbImage = await FlutterNativeImage.compressImage(_image.path, quality: 70,
                            targetWidth: 300,
                            targetHeight: (properties.height! * 300 / properties.width!).round());

                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: avicenna.CustomDialog(
                                insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                                title: 'Judul Gambar',
                                // info: 'Ambil gambar dari kamera atau galeri',
                                content: IntrinsicHeight(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: Image.file(_image, fit: BoxFit.cover)
                                          ),
                                          width: MediaQuery.of(context).size.width,
                                          // height: MediaQuery.of(context).size.width - 260,
                                        ),
                                        // SizedBox(height: 12),
                                        // avicenna.TextField(
                                        //   textFieldStyle: avicenna.TextFieldStyle.border,
                                        //   helperText: 'Judul',
                                        //   initialValue: '',
                                        //   onChanged: (val) => setState(() => title = val),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  avicenna.ModalActionItem(text: '', child: avicenna.TextField(
                                    textFieldStyle: avicenna.TextFieldStyle.border,
                                    hintText: 'Judul',
                                    initialValue: '',
                                    onChanged: (val) => setState(() => title = val),
                                  ), onPressed: null, withTopBorder: false),
                                  if (title.isNotEmpty) avicenna.ModalActionItem(
                                    text: 'Simpan',
                                    onPressed: () async {
                                      var guid = Uuid().v1();
                                      final String path = (await getApplicationDocumentsDirectory()).path;
                                      await _image.copy('$path/$guid.png');
                                      await _thumbImage.copy('$path/$guid-thumb.png');

                                      setState(() {
                                        momon.add(Photo(
                                          title: title,
                                          isUploaded: false,
                                          imageLocal: '$path/$guid.png',
                                          thumbLocal: '$path/$guid-thumb.png'
                                        ));
                                      });
                                      Navigator.pop(context);
                                    }
                                  ),
                                ]
                              )
                            );
                          }
                        );
                      }

                      prefs.setString('album', jsonEncode(momon));
                    } else {
                      print('No image selected.');
                    }
                  }
                },
              );
          },
        )
      )
    );
  }

}
