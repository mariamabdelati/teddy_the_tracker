import 'package:flutter/material.dart';
import 'package:teddy_the_tracker/constants.dart';

class AnimatedWallet extends StatefulWidget {
  @override
  _AnimatedWalletState createState() => _AnimatedWalletState();
}

class _AnimatedWalletState extends State<AnimatedWallet>
    with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(
      duration: const Duration(milliseconds: 600), vsync: this);
  late Animation<double> scaleAnimation =
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(
      duration: const Duration(milliseconds: 300), vsync: this);
  late Animation<double> checkAnimation =
      CurvedAnimation(parent: checkController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 80;
    double iconSize = 50;

    return Stack(
      children: [
        Center(
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              height: circleSize,
              width: circleSize,
              decoration: BoxDecoration(
                color: mainColorList[2],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: checkAnimation,
          axis: Axis.horizontal,
          axisAlignment: -1,
          child: Center(
            heightFactor: 1.6,
            child: Icon(Icons.account_balance_wallet_rounded,
                color: Colors.white, size: iconSize),
          ),
        ),
      ],
    );
  }
}

void buildWalletDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedWallet(),
                SizedBox(height: 12),
                const Text(
                  'Your Wallet Code',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700),
                  //style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
