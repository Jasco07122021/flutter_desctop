import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_desctop/core/const.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/main/home/home_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      builder: (context, _) => const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Selector<HomeProvider, bool>(
          selector: (_, bloc) => bloc.isLoading,
          builder: (context, state, _) => AnimatedCrossFade(
            firstChild: const Center(child: Text("VPN Hotstop")),
            secondChild: const SizedBox.shrink(),
            duration: const Duration(milliseconds: 500),
            crossFadeState:
                state ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            alignment: Alignment.bottomCenter,
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            Selector<HomeProvider, bool>(
              selector: (_, bloc) => bloc.isConnected,
              builder: (context, state, _) => IconButton(
                onPressed: context.read<HomeProvider>().onPressPower,
                style: ButtonStyle(
                  shape: ButtonState.all(
                    CircleBorder(
                      side: BorderSide(
                        color: state ? Colors.white : Colors.blue,
                        width: 5.0,
                      ),
                    ),
                  ),
                  padding: ButtonState.all(const EdgeInsets.all(40.0)),
                ),
                icon: const Icon(
                  FluentIcons.power_button,
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
            ),
            const Spacer(),
            Selector<HomeProvider, bool>(
              selector: (_, bloc) => bloc.isLoading,
              builder: (context, state, _) => AnimatedCrossFade(
                firstChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("How was your connection?"),
                    const SizedBox(width: 20.0),
                    Selector<HomeProvider, double>(
                      selector: (_, bloc) => bloc.rating,
                      builder: (context, state, _) => RatingBar(
                        rating: state,
                        iconSize: 12,
                        starSpacing: 5,
                        onChanged: (v) =>
                            context.read<HomeProvider>().updateRating(v),
                      ),
                    ),
                  ],
                ),
                secondChild: const SizedBox.shrink(),
                duration: const Duration(milliseconds: 500),
                crossFadeState: state
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: const [
                BottomBoxHomeView(
                  headerText: "Virtual location",
                  text: "United State",
                ),
                SizedBox(width: 5.0),
                BottomBoxHomeView(
                  headerText: "Daily data, MB",
                  text: "500/500",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BottomBoxHomeView extends StatelessWidget {
  final String headerText;
  final String text;

  const BottomBoxHomeView({
    Key? key,
    required this.headerText,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<HomeProvider, bool>(
        selector: (_, bloc) => bloc.isLoading,
        builder: (context, state, _) {
          log(state.toString());
          return AnimatedCrossFade(
            firstChild: Container(
              height: 100.0,
              padding: const EdgeInsets.all(20.0),
              color: navigationViewBackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        headerText,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4), fontSize: 12),
                      ),
                      IconButton(
                        icon: Icon(
                          FluentIcons.info,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      headerText[0] == "V"
                          ? Image.asset(
                              "assets/home/america_flag.png",
                              height: 20,
                              width: 20,
                            )
                          : SizedBox(
                              height: 20,
                              width: 20,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      color: Colors.blue,
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.blue,
                                      ),
                                      showTitle: false,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(width: 10.0),
                      Text(text),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          FluentIcons.chevron_right,
                          size: 10,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
            duration: const Duration(milliseconds: 500),
            crossFadeState:
                state ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          );
        },
      ),
    );
  }
}
