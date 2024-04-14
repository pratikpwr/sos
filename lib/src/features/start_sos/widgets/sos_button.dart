import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/features/start_sos/providers/sos_button_provider.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({
    super.key,
    required this.onSend,
  });

  final VoidCallback onSend;

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> with TickerProviderStateMixin {
  final Tween<double> _tween = Tween<double>(begin: 100, end: 32);
  late AnimationController _animationController;
  late Animation<double> _textSizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _textSizeAnimation = _tween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final double innerWidth = 225;
  final double padding = 25;

  @override
  Widget build(BuildContext context) {
    return Consumer<SOSButtonProvider>(
      builder: (context, btnProvider, _) {
        return GestureDetector(
          onTapDown: (_) => btnProvider.startSOS(
            animationController: _animationController,
            onSend: widget.onSend,
          ),
          onTapUp: (_) => btnProvider.stopSOS(_animationController),
          onTapCancel: () => btnProvider.stopSOS(_animationController),
          child: Material(
            shape: const CircleBorder(),
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red[300],
              ),
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(innerWidth + padding + padding),
                onTap: () {},
                child: Container(
                  width: innerWidth + padding + padding,
                  height: innerWidth + padding + padding,
                  padding: EdgeInsets.all(padding),
                  child: Ink(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red[400],
                    ),
                    child: Container(
                      width: innerWidth + padding,
                      height: innerWidth + padding,
                      padding: EdgeInsets.all(padding),
                      child: Ink(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: SizedBox(
                          width: innerWidth,
                          height: innerWidth,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _textSizeAnimation,
                              builder: (context, child) {
                                return Text(
                                  btnProvider.buttonText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: btnProvider.buttonText.length > 1
                                        ? 32
                                        : _textSizeAnimation.value,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
