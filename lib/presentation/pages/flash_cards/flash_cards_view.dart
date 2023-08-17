import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/widgets/flash_card_item/flash_card_item.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

class FlashCardsView extends StatefulWidget {
  const FlashCardsView({super.key});

  @override
  State<FlashCardsView> createState() => _FlashCardsViewState();
}

class _FlashCardsViewState extends State<FlashCardsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppLinearPercentIndicator(
            percent: 0.5,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              FlashCardItem(
                name: 'name',
                description: 'description',
                tapBackDescription: 'tapBackDescription',
                tapFrontDescription: 'tapFrontDescription',
                descriptionTranslation: 'descriptionTranslation',
              ),
              Flexible(child: Container()),
              Row(
                children: [
                  Flexible(child: Container()),
                  Container(
                    width: ScreenUtil().screenWidth * 0.35,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                        child: Text(
                      'Review later',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: ScreenUtil().screenWidth * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    height: 64,
                    child: Center(
                        child: Text(
                      'I got it',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  Flexible(child: Container()),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ));
  }
}
