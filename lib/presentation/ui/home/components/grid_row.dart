import 'package:flutter/material.dart';

class GridRow extends StatelessWidget {
  const GridRow(
      {Key? key,
      required this.name,
      required this.monthlyOrDaily,
      required this.lastPay,
      required this.goalsString,
      required this.rowIndex})
      : super(key: key);
  final String name;
  final String monthlyOrDaily;
  final String lastPay;
  final String goalsString;
  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    final bgColor = rowIndex % 2 == 0 ? Colors.grey[200] : Colors.white54;
    return Container(
      height: 40,
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 80,
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ),
          Container(
            width: 35,
            alignment: Alignment.center,
            child: Text(
              goalsString,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ),
          // Container(
          //   width: 80,
          //   alignment: Alignment.center,
          //   child: Text(
          //     monthlyOrDaily,
          //     style: Theme.of(context).textTheme.bodyMedium!,
          //   ),
          // ),
          Container(
            width: 90,
            alignment: Alignment.center,
            child: Text(lastPay, style: Theme.of(context).textTheme.bodyMedium!),
          ),
        ],
      ),
    );
  }
}
