import 'package:chat/shared/widgets/gradient_app_bar.widget.dart';
import 'package:flutter/material.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBarWidget(
        back: true,
        title: "تراکنش ها",
        colors: [
          Colors.green.shade500,
          Colors.green.shade700,
        ],
      ),
    );
  }
}
