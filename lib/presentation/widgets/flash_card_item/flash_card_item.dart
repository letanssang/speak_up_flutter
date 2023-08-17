import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashCardItem extends StatefulWidget {
  final String name;
  final String description;
  final String tapFrontDescription;
  final String tapBackDescription;
  final String descriptionTranslation;
  final Function()? onPressed;

  const FlashCardItem({
    super.key,
    required this.name,
    required this.description,
    required this.tapFrontDescription,
    required this.tapBackDescription,
    required this.descriptionTranslation,
    this.onPressed,
  });

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
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: ScreenUtil().screenWidth * 0.8,
        width: ScreenUtil().screenWidth * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.tapBackDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                )),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    isTranslated
                        ? widget.descriptionTranslation
                        : widget.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
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
                    onPressed: widget.onPressed,
                    icon: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: ScreenUtil().setWidth(32),
                    )),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        height: ScreenUtil().screenWidth * 0.8,
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
                  widget.name,
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
                onPressed: widget.onPressed,
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
