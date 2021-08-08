import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Function onPressed;
  final IconData icon;
  final String toolTip;
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.toolTip,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      color: _isActive ? Colors.grey : Colors.transparent,
      child: IconButton(
        onPressed: () {
          widget.onPressed();
          setState(() {
            _isActive = !_isActive;
          });
        },
        tooltip: widget.toolTip,
        icon: Icon(widget.icon),
      ),
    );
  }
}
