import 'package:flutter/material.dart';

class BubbleTextField extends StatelessWidget {
  final hintText;
  final icon;
  final color;
  final obsecureText;
  final controller;
  final void Function(String)? onChanged;
  BubbleTextField({this.color, this.hintText, this.icon, this.obsecureText, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      obscureText: obsecureText,
      autocorrect: false,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(24.0),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            color: color,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              width: 3, color: color),
        ),
      ),
    );
  }
}
