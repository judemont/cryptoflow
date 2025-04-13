import 'package:flutter/material.dart';

class CoinInfo extends StatelessWidget {
  final String name;
  final Widget value;
  const CoinInfo({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        value
      ],
    );
  }
}
