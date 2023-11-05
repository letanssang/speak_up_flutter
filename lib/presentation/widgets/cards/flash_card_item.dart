import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum FlashCardSize {
  small,
  medium,
  large,
}

class FlashCardItem extends StatefulWidget {
  final String frontText;
  final String backText;
  final String tapFrontDescription;
  final String tapBackDescription;
  final String backTranslation;
  final FlashCardSize flashCardSize;
  final Function()? onPressedFrontCard;
  final Function()? onPressedBackCard;

  const FlashCardItem(
      {super.key,
      required this.frontText,
      required this.backText,
      required this.tapFrontDescription,
      required this.tapBackDescription,
      required this.backTranslation,
      this.flashCardSize = FlashCardSize.medium,
      this.onPressedFrontCard,
      this.onPressedBackCard});

  @override
  State<FlashCardItem> createState() => _FlashCardItemState();
}

class _FlashCardItemState extends State<FlashCardItem> {
  bool isTranslated = false;

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      speed: 300,
      front: buildFrontCard(context),
      back: buildBackCard(context),
    );
  }

  Card buildBackCard(BuildContext context) {
    return Card(
      elevation: 5,
      color: Theme.of(context).primaryColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2A0C4E),
              Color(0xFF3C1D74),
              Color(0xFF50248F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        height: widget.flashCardSize == FlashCardSize.medium
            ? ScreenUtil().screenWidth * 0.8
            : ScreenUtil().screenHeight * 0.5,
        width: ScreenUtil().screenWidth * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.tapBackDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white70,
                )),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    isTranslated ? widget.backTranslation : widget.backText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Flexible(child: Container()),
                IconButton(
                    onPressed: widget.onPressedBackCard,
                    icon: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: ScreenUtil().setWidth(32),
                    )),
                SizedBox(width: ScreenUtil().setWidth(16)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isTranslated = !isTranslated;
                      });
                    },
                    icon: Icon(
                      Icons.translate,
                      color: Colors.white,
                      size: ScreenUtil().setWidth(32),
                    )),
                Flexible(child: Container())
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card buildFrontCard(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2A0C4E),
              Color(0xFF3C1D74),
              Color(0xFF50248F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        height: widget.flashCardSize == FlashCardSize.medium
            ? ScreenUtil().screenWidth * 0.8
            : ScreenUtil().screenHeight * 0.5,
        width: ScreenUtil().screenWidth * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.tapFrontDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white70,
                )),
            Expanded(
              child: Center(
                child: Text(
                  widget.frontText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: widget.onPressedFrontCard,
                icon: Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: ScreenUtil().setWidth(32),
                )),
          ],
        ),
      ),
    );
  }
}
