import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:glitter/screens/image/components/controls.component.dart';
import 'package:flutter/material.dart';
import 'package:glitter/components/appbar.component.dart';
import 'package:glitter/screens/image/components/image.component.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  Uint8List? _imageData;
  bool _isPickerEnabled = false;

  Future<void> _pickImage(BuildContext context) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? _image =
          await _picker.pickImage(source: ImageSource.gallery);

      if (_image != null) {
        final Uint8List _temp = await _image.readAsBytes();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        'Image Palette',
      ),
      body: _imageData == null
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
                    isPickerEnabled: _isPickerEnabled),
                if (_imageData != null)
                  Controls(
                    imageData: _imageData as Uint8List,
                    onReset: () {
                      setState(() {
                        _imageData = null;
                      });
                    },
                    togglePicker: togglePicker,
                  ),
              ],
            ),
    );
  }
}
