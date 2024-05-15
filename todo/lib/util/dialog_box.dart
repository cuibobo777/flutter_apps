import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Container(
        height: 120,
        child: const Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "输入任务名称"),
            ),
          ],
        ),
      ),
    );
  }
}
