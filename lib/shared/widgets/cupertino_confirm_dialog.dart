import 'package:flutter/cupertino.dart';

void cupertinoConfirmDialog(
  context, {
  required String title,
  required String description,
  String leftBtnName = '취소',
  String rightBtnName = '삭제',
  VoidCallback? leftBtnAction,
  required VoidCallback rightBtnAction,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              leftBtnAction ?? ();
              Navigator.of(context).pop();
            },
            child: Text(leftBtnName),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              rightBtnAction();
            },
            child: Text(rightBtnName),
          ),
        ],
      );
    },
  );
}
