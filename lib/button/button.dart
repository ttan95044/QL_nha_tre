import 'package:flutter/material.dart';

class Button extends StatelessWidget{
  const Button ({super.key, this.title, this.colour, this.onPressed});
  final Color? colour;
  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed!,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}