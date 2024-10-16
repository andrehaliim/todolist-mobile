import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showSuccessDialog(BuildContext context, String title, String message) {
  double defaultWidth = MediaQuery.of(context).size.width;
  double defaultHeight = MediaQuery.of(context).size.height;

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Set border radius to 8 for slightly rounded corners
      ),
      title: Column(
        children: [
          Icon(
            CupertinoIcons.checkmark_circle,
            color: Colors.green,
            size: 70,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Container(
        width: defaultWidth,
        height: defaultHeight / 12,
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 4,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: defaultWidth / 2,
            height: defaultHeight / 15,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
                shape: MaterialStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ); // Ensures non-null return value
}

showFailedDialog(BuildContext context, String title, String message) {
  double defaultWidth = MediaQuery.of(context).size.width;
  double defaultHeight = MediaQuery.of(context).size.height;

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Set border radius to 8 for slightly rounded corners
      ),
      title: Column(
        children: [
          Icon(
            CupertinoIcons.clear_circled,
            color: Colors.red,
            size: 70,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Container(
        width: defaultWidth,
        height: defaultHeight / 12,
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 4,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: defaultWidth / 2,
            height: defaultHeight / 15,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
                shape: MaterialStateProperty.resolveWith(
                      (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ); // Ensures non-null return value
}

Future<bool> showConfirmationDialog(BuildContext context, String message) {
  double defaultWidth = MediaQuery.of(context).size.width;
  double defaultHeight = MediaQuery.of(context).size.height;

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Set border radius to 8 for slightly rounded corners
      ),
      title: Column(
        children: [
          Icon(
            CupertinoIcons.question_circle,
            color: Colors.black,
            size: 70,
          ),
          Text(
            'Confirmation',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Container(
        width: defaultWidth,
        height: defaultHeight / 12,
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 4,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: defaultWidth / 3.5,
              height: defaultHeight / 18,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                  shape: MaterialStateProperty.resolveWith(
                        (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: defaultWidth / 3.5,
              height: defaultHeight / 18,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
                  shape: MaterialStateProperty.resolveWith(
                        (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ).then((value) => value ?? false); // Ensures non-null return value
}
