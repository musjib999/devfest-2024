import 'package:flutter/material.dart';

import '../themes/themes.dart';

class Empty extends StatelessWidget {
  final double? size;
  const Empty({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.block,
            size: size ?? screenSize.width * 0.50,
            color: AppColors.ash,
          ),
          const SizedBox(height: 20),
          Text('Empty', style: AppTextStyle.subTitle),
          const SizedBox(height: 10),
          Text(
            'No items, add one please!!!',
            style: AppTextStyle.label,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
