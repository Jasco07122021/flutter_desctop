import 'package:flutter/material.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/core/style.dart';
import 'package:flutter_desctop/core/widgets.dart';
import 'package:flutter_desctop/model/network_model/history_question_model.dart';
import 'package:flutter_desctop/view/main/profile/local_widgets/color_box.dart';
import 'package:flutter_desctop/viewModel/main/profile/history_question_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class HistoryQuestionView extends StatelessWidget {
  const HistoryQuestionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryQuestionProvider(),
      builder: (context, _) => const _HistoryQuestionView(),
    );
  }
}

class _HistoryQuestionView extends StatefulWidget {
  const _HistoryQuestionView({Key? key}) : super(key: key);

  @override
  State<_HistoryQuestionView> createState() => _HistoryQuestionViewState();
}

class _HistoryQuestionViewState extends State<_HistoryQuestionView> {
  late ScrollController scrollController;

  @override
  void initState() {
    Logger().i("message");
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels) {
          context.read<HistoryQuestionProvider>().getNewList();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<HistoryQuestionProvider, bool>(
      selector: (_, bloc) => bloc.isLoading,
      builder: (context, state, _) => LoadingView(
        loading: state,
        child: Scaffold(
          body: Column(
            children: [
              const CustomTitleBarBox(),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          Visibility(
                            visible: !context.select(
                                (HistoryQuestionProvider bloc) =>
                                    bloc.isLoading),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Запросы",
                                style: StyleTextCustom.setStyleByEnum(
                                  StyleTextEnum.bodyHeaderText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Consumer<HistoryQuestionProvider>(
                            builder: (context, consumer, _) {
                              final provider =
                                  context.read<HistoryQuestionProvider>();
                              return Column(
                                children: [
                                  for (int i = 0;
                                      i < consumer.historyList.length;
                                      i++)
                                    _box(consumer.historyList[i], provider),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Selector<HistoryQuestionProvider, bool>(
                          selector: (_, bloc) => bloc.paginationLoading,
                          builder: (context, state, _) => Visibility(
                            visible: state,
                            child: const LinearProgressIndicator(
                              color: Colors.yellow,
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: mainColorBackground,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          child: CustomMaterialButton(
                            text: "Вернуться в профиль",
                            onPress: () {
                              Navigator.pop(context, 1);
                            },
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding _box(Datum datum, HistoryQuestionProvider provider) {
    Color border = provider.getBorder(datum);
    Color color = provider.getColor(datum);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomColorBox(
        color: color,
        border: border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerTitle(
              "STATUS",
              datum.state,
            ),
            _headerTitle(
              "CARD",
              datum.card,
            ),
            _headerTitle(
              "COUNT",
              "${datum.count}",
            ),
            _headerTitle(
              "EMAIL",
              datum.email,
            ),
          ],
        ),
      ),
    );
  }

  _headerTitle(String header, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: StyleTextCustom.setStyleByEnum(
              StyleTextEnum.bodyMiddleHeaderText),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: StyleTextCustom.setStyleByEnum(
            StyleTextEnum.bodyMiddleBodyText,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
