import 'package:flutter/material.dart';
import 'package:voicepassing/style/color_style.dart';

class CallEndedResultWidget extends StatefulWidget {
  const CallEndedResultWidget({Key? key}) : super(key: key);

  @override
  State<CallEndedResultWidget> createState() => _CallEndedResultWidgetState();
}

class _CallEndedResultWidgetState extends State<CallEndedResultWidget> {
  Color color = const Color(0xFFFFFFFF);
  String status = 'default';
  late List<String> dangerousKeywords = [
    '중앙검찰',
    '송금',
    '대포통장',
  ];
  double score = 50;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color:
                score > 80 ? ColorStyles.dangerText : ColorStyles.warningText,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Row(
                      children: [
                        Image(
                          image: AssetImage('images/VoiceLogo.png'),
                          height: 22,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '검사',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          score > 80 ? '위험' : '주의',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        for (var dangerousKeyword in dangerousKeywords)
                          Row(
                            children: [
                              Text(
                                dangerousKeyword,
                                style: TextStyle(
                                  color: score > 80
                                      ? ColorStyles.subLightGray
                                      : ColorStyles.textBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 5,
                          color: Colors.white,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        score.round().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
