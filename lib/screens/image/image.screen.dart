import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:glitter/components/drawer.component.dart';
import 'package:glitter/screens/image/components/controls.component.dart';
import 'package:flutter/material.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/screens/image/components/image.component.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:glitter/utils/functions.util.dart';
import 'package:glitter/utils/themes.util.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  Uint8List? _imageData;
  StreamController<Offset?>? _positionStream;
  StreamController<Color?>? _colorStream;
  bool _isPickerEnabled = false;
  bool _isLoading = false;

  @override
  void dispose() {
    clearStreams();
    super.dispose();
  }

  void initStreams() {
    _positionStream = StreamController();
    _colorStream = StreamController();
  }

  void clearStreams() {
    _positionStream?.close();
    _colorStream?.close();

    _positionStream = null;
    _colorStream = null;
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      print('Initializing streams');
      initStreams();

      print('Picking image');
      final ImagePicker _picker = ImagePicker();
      final XFile? _image =
          await _picker.pickImage(source: ImageSource.gallery);

      print('Image selected');
      if (_image != null) {
        setState(() {
          _isLoading = true;
        });

        print('Converting to list');

        final Uint8List _temp = await compute(loadImageData, _image);

        print('Got list');

        setState(() {
          _imageData = _temp;
        });
      } else {
        throw new Exception('Got null');
      }
    } catch (e) {
      print('Failed to pick image from the gallery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image from the gallery'),
        ),
      );
    }
  }

  void togglePicker() {
    setState(() {
      _isPickerEnabled = !_isPickerEnabled;
    });
  }

  void reset() {
    setState(() {
      _imageData = null;
    });

    clearStreams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(context),
      appBar: CustomAppBar(
        context: context,
        titleText: 'Image Palette',
      ),
      body: _imageData == null
          ? Center(
              child: SizedBox.fromSize(
                size: Size.square(100),
                child: MaterialButton(
                  onPressed: () {
                    _pickImage(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: dbService.darkMode
                          ? Themes.darkPrimaryColor
                          : Themes.primaryColor,
                    ),
                  ),
                  child: Icon(
                    Icons.image_rounded,
                    size: 70,
                    color: dbService.darkMode
                        ? Themes.darkPrimaryColor
                        : Themes.primaryColor,
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                ImageViewer(
                  imageData: _imageData as Uint8List,
                  isPickerEnabled: _isPickerEnabled,
                  onLoadComplete: () {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  positionStream: _positionStream as StreamController<Offset?>,
                  colorStream: _colorStream as StreamController<Color?>,
                ),
                // Magnifier(
                //   positionStream: _positionStream as StreamController<Offset?>,
                // ),
                if (_imageData != null)
                  Controls(
                    isPickerEnabled: _isPickerEnabled,
                    imageData: _imageData as Uint8List,
                    onReset: reset,
                    togglePicker: togglePicker,
                    colorStream: _colorStream as StreamController<Color?>,
                  ),
                if (_isLoading)
                  Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    color: Colors.black87.withOpacity(0.7),
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: dbService.darkMode
                                  ? Themes.darkPrimaryColor
                                  : Themes.primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
    );
  }
}
