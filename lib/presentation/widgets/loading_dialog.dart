import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  bool isLoading = false;

  @override
  void initState() {
    setState(() => isLoading = true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Dialog(
        backgroundColor: scheme.background.withOpacity(0.5),
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Container(
          height: 125.0,
          padding: const EdgeInsets.all(15.0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProgressIndicator(),
              Text(
                'Loading',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}
