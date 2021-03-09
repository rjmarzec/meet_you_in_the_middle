import 'package:flutter/material.dart';
import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
      content: BlockPicker(
        availableColors: [
          Colors.pink,
          Colors.pinkAccent,
          Colors.redAccent,
          Colors.red[700],
          Colors.deepOrange,
          Colors.orange[800],
          Colors.lime[800],
          Colors.green,
          Colors.lightGreen[800],
          Colors.teal,
          Colors.cyan[600],
          Colors.blue,
          Colors.indigo,
          Colors.purpleAccent[700],
          Colors.purple,
          Colors.deepPurple,
          Colors.brown[400],
          Colors.brown[600],
          Colors.grey[600],
          Colors.blueGrey[600],
        ],
        onColorChanged: updateThemeColor,
        pickerColor: Theme.of(context).primaryColor,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Done"),
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
