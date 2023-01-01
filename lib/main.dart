import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Cropping + Rotate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Image Cropping + Rotate'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late File imageFile;
  bool _load = false;

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile?.path);
  }


  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
    );
    // PickedFile? pickedFile = await ImagePicker().getImage(
    //   source: ImageSource.camera,
    //   maxWidth: 1800,
    //   maxHeight: 1800,
    // );
    _cropImage(pickedFile?.path);
  }

  _cropImage(filePath) async {

    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressFormat: ImageCompressFormat.png,

    );

    if (croppedImage  != null) {
      imageFile = File(croppedImage.path);
      setState(() {
        _load = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _load == false
                ? ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset('assets/images/dummy.png'),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.file(imageFile,
                  width: 200, height: 200, fit: BoxFit.fill),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Image.asset('assets/images/gallery.jfif'),
                      iconSize: 50,
                      onPressed: () {
                        _getFromGallery();
                      }),
                  IconButton(
                      icon: Image.asset('assets/images/camera.jfif'),
                      iconSize: 50,
                      onPressed: () {
                        _getFromCamera();
                      }),
                ]),

          ],
        ),
      ),
    );
  }
}
