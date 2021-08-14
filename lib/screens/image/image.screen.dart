import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:glitter/screens/image/components/controls.component.dart';
import 'package:flutter/material.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/screens/image/components/image.component.dart';
import 'package:glitter/screens/image/components/magnifier.component.dart';
import 'package:glitter/utils/functions.util.dart';
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
      initStreams();

      final ImagePicker _picker = ImagePicker();
      final XFile? _image =
          await _picker.pickImage(source: ImageSource.gallery);

      if (_image != null) {
        setState(() {
          _isLoading = true;
        });

        final Uint8List _temp = await compute(loadImageData, _image);

        setState(() {
          _isLoading = false;
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
      appBar: CustomAppBar(
        context,
        'Image Palette',
      ),
      body: _isLoading == true
          ? Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            )
          : _imageData == null
              ? Center(
                  child: Ink.image(
                    image: AssetImage(
                      'assets/icons/image.png',
                    ),
                    width: 100,
                    height: 100,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        _pickImage(context);
                      },
                    ),
                  ),
                )
              : Stack(
                  children: [
                    ImageViewer(
                      imageData: _imageData as Uint8List,
                      isPickerEnabled: _isPickerEnabled,
                      positionStream:
                          _positionStream as StreamController<Offset?>,
                      colorStream: _colorStream as StreamController<Color?>,
                    ),
                    Magnifier(
                      positionStream:
                          _positionStream as StreamController<Offset?>,
                    ),
                    if (_imageData != null)
                      Controls(
                        imageData: _imageData as Uint8List,
                        onReset: reset,
                        togglePicker: togglePicker,
                        colorStream: _colorStream as StreamController<Color?>,
                      ),
                  ],
                ),
    );
  }
}
