import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styled_text/styled_text.dart';
import 'package:timelines/timelines.dart';
import 'package:voicepassing/models/result_model.dart';
import 'package:voicepassing/services/classify.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/nav_bar.dart';

class ResultScreenDetail extends StatelessWidget {
  final ResultModel resultInfo;

  const ResultScreenDetail({super.key, required this.resultInfo});
  @override
  Widget build(BuildContext context) => HomePage(resultInfo: resultInfo);
}

class HomePage extends StatelessWidget {
  final ResultModel resultInfo;

  const HomePage({super.key, required this.resultInfo});

  @override
  Widget build(BuildContext context) {
    late List<String> sentences;
    if (resultInfo.type != 0) {
      sentences = List.from(resultInfo.sentences!);
      for (int i = 0; i < resultInfo.sentences!.length; i++) {
        for (String word in resultInfo.words!) {
          sentences[i] = sentences[i].replaceAll(word, '<b>$word</b>');
        }
      }
    } else {
      sentences = ['정상적인 통화입니다'];
    }

    return DraggableHome(
      bottomNavigationBar: const Navbar(selectedIndex: 1),
      stretchMaxHeight: 0.5,
      headerExpandedHeight: 0.22,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios)),
      title: Text("${Classify.getCategory(resultInfo.type as int)['type']}"),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/setting");
            },
            icon: const Icon(Icons.settings)),
      ],
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        // listView(context),
        // const Text('내용'),

        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 30),
                child: FixedTimeline.tileBuilder(
                  theme: TimelineTheme.of(context).copyWith(
                    nodePosition: 0,
                    connectorTheme:
                        TimelineTheme.of(context).connectorTheme.copyWith(
                              thickness: 1.0,
                            ),
                    indicatorTheme:
                        TimelineTheme.of(context).indicatorTheme.copyWith(
                              size: 21.0,
                              position: 0.5,
                            ),
                  ),
                  builder: TimelineTileBuilder.connected(
                      itemExtentBuilder: (context, index) {
                        return resultInfo.sentences![index].length ~/ 20 * 40 +
                            80;
                      },
                      connectionDirection: ConnectionDirection.before,
                      itemCount: resultInfo.sentences!.length,
                      contentsBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StyledText(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                text: sentences[index].toString(),
                                tags: {
                                  'b': StyledTextTag(
                                      style: TextStyle(
                                          color: Classify.getSentenceColor(
                                              resultInfo.scores![index],
                                              resultInfo.type!),
                                          fontWeight: FontWeight.w700))
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      indicatorBuilder: (_, index) => DotIndicator(
                            color: Classify.getSentenceColor(
                                resultInfo.scores![index], resultInfo.type!),
                          ),
                      connectorBuilder: (_, index, ___) {
                        return SolidLineConnector(
                          space: 50,
                          thickness: 4,
                          color: index == resultInfo.sentences!.length ||
                                  index == 0
                              ? ColorStyles.subLightGray
                              : ColorStyles.subLightGray,
                        );
                      }),
                ),
              ),
            ),
          ],
        )
      ],
      fullyStretchable: false,
      // expandedBody: const Text('일해'),
      backgroundColor: Colors.white,
      appBarColor:
          Classify.getColor(resultInfo.score as double, resultInfo.type as int),
    );
  }

  Row headerBottomBarWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.settings,
          color: Classify.getColor(
              resultInfo.score as double, resultInfo.type as int),
        ),
      ],
    );
  }

// 피그마
  Widget headerWidget(BuildContext context) {
    return Container(
      color:
          Classify.getColor(resultInfo.score as double, resultInfo.type as int),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              flex: 5,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Classify.getCategory(resultInfo.type as int)['icon'],
                        color: const Color.fromARGB(125, 255, 255, 255),
                        size: 100,
                      ),
                      // const SizedBox(
                      //   width: 20,
                      // ),

                      Text(
                        DateFormat('yyyy/M/d')
                            .format(DateTime.parse(resultInfo.date.toString())),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color.fromARGB(150, 255, 255, 255)),
                      ),
                    ],
                  ),
                  Text(
                    "${Classify.getCategory(resultInfo.type as int)['type']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: CircleProgressBar(
                        strokeWidth: 8,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        // value/1 표시
                        value: resultInfo.score!,
                        child: Center(
                          child: AnimatedCount(
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 36),
                            fractionDigits: 0,
                            count: resultInfo.score! * 100,
                            unit: '',
                            duration: const Duration(microseconds: 500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listView(BuildContext context) {
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder.fromStyle(
        contentsAlign: ContentsAlign.alternating,
        contentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text('Timeline Event $index'),
        ),
        itemCount: 10,
      ),
    );
  }
}
