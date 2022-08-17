import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_desctop/core/const.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Center(child: Text("VPN Hotstop")),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {},
              style: ButtonStyle(
                shape: ButtonState.all(
                  CircleBorder(
                    side: BorderSide(color: Colors.blue, width: 3.0),
                  ),
                ),
                padding: ButtonState.all(const EdgeInsets.all(40.0)),
              ),
              icon: const Icon(
                FluentIcons.power_button,
                color: Colors.white,
                size: 20,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("How was your connection?"),
                const SizedBox(width: 20.0),
                RatingBar(
                  rating: rating,
                  iconSize: 12,
                  starSpacing: 5,
                  onChanged: (v) => setState(() => rating = v),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                _boxBottom(
                  headerText: "Virtual location",
                  text: "United State",
                ),
                const SizedBox(width: 5.0),
                _boxBottom(
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

  Expanded _boxBottom({
    required String headerText,
    required String text,
  }) {
    return Expanded(
      child: Container(
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
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue),
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
    );
  }
}
