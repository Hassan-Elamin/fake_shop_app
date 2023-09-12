import 'package:flutter/material.dart';

class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 100.0,
            ),
            Text("connection error \n please try to reconnect to the internet",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
          ],
        ),
      ),
    );
  }
}
