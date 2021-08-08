import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Function onPressed;
  final IconData icon;
  final Color activeColor;
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.activeColor,
  }) : super(key: key);

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.onPressed();
        setState(() {
          _isActive = !_isActive;
        });
      },
      color: _isActive ? widget.activeColor : Theme.of(context).iconTheme.color,
      icon: Icon(widget.icon),
    );
  }
}
