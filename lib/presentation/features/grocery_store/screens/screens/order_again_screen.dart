import 'package:flutter/material.dart';

import '../../../../../models/store/store_model.dart';

class OrderAgainScreen extends StatefulWidget {
  final Store store;
  const OrderAgainScreen(this.store, {super.key});

  @override
  State<OrderAgainScreen> createState() => _OrderAgainScreenState();
}

class _OrderAgainScreenState extends State<OrderAgainScreen> {
  @override
  Widget build(BuildContext context) {
    //TODO: to implement
    return Scaffold(
        // body: FutureBuilder(
        //   future: _getF,
        //   builder: (context, snapshot) {
        //     return Container();
        //   },
        // ),
        );
  }
}
