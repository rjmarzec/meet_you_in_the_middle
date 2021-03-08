import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';

class PickColorDialog extends StatefulWidget {
  @override
  PickColorDialogState createState() => new PickColorDialogState();
}

class PickColorDialogState extends State<PickColorDialog> {
  Color pickerColor;
  Color currentColor;

  @override
  Widget build(BuildContext context) {
    pickerColor = Theme.of(context).primaryColor;
    currentColor = Theme.of(context).primaryColor;

    return AlertDialog(
      title: const Text("Pick a color!"),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: currentColor,
          onColorChanged: updateThemeColor,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text("Ok"),
          onPressed: () {
            setState(() => currentColor = pickerColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void updateThemeColor(Color colorChoice) {
    setState(() {
      DynamicColorTheme.of(context).setColor(
        color: colorChoice,
        shouldSave: true, // saves it to shared preferences
      );
    });
  }
}
