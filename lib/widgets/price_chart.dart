import 'package:cryptoflow/models/coin_price.dart';
import 'package:cryptoflow/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatefulWidget {
  final List<CoinPrice> priceHistory;
  const PriceChart({super.key, required this.priceHistory});

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  String formatTime(DateTime dateTime) {
    DateTime firstTime = widget.priceHistory.first.dateTime!;
    DateTime lastTime = widget.priceHistory.last.dateTime!;

    if (firstTime.year == lastTime.year) {
      if (firstTime.day == lastTime.day) {
        if (firstTime.hour <= lastTime.hour + 4) {
          return "${dateTime.hour}:${dateTime.minute}";
        }
        return "${dateTime.hour}h";
      }

      return "${dateTime.day} ${months[dateTime.month - 1]}";
    }
    return "${months[dateTime.month - 1]} ${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
            right: 18.0,
          ),
          child: LineChart(
            LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                    shadow: Shadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: 10,
                    ),
                    barWidth: 1,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.5),
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.0),
                        ],
                        stops: const [0.5, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    spots: widget.priceHistory.map((e) {
                      return FlSpot(
                        e.dateTime!.millisecondsSinceEpoch.toDouble(),
                        (e.price ??
                                widget
                                    .priceHistory[
                                        widget.priceHistory.indexOf(e) - 1]
                                    .price ??
                                0)
                            .toDouble(),
                      );
                    }).toList(),
                  )
                ],
                lineTouchData: LineTouchData(
                  touchSpotThreshold: 5,
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: Theme.of(context).colorScheme.onSurface,
                          strokeWidth: 1.5,
                          dashArray: [8, 2],
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Theme.of(context).colorScheme.onSurface,
                              strokeWidth: 0,

                              //strokeColor: AppColors.contentColorYellow,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    showOnTopOfTheChartBoxArea: true,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final price = barSpot.y;
                        final date = DateTime.fromMillisecondsSinceEpoch(
                            barSpot.x.toInt());
                        return LineTooltipItem(
                          '',
                          const TextStyle(
                            //    color: AppColors.contentColorBlack,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour}:${date.minute}h",
                              style: TextStyle(
                                //      color: AppColors.contentColorGreen.darken(20),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: '\n${formatPrice(price, '\$')}',
                              style: const TextStyle(
                                //  color: AppColors.contentColorYellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                    getTooltipColor: (LineBarSpot barSpot) =>
                        Theme.of(context).colorScheme.primary.withAlpha(200),
                    //   AppColors.contentColorBlack,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    drawBelowEverything: true,
                    sideTitles: SideTitles(
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            formatPrice(value, '\$'),
                            style: const TextStyle(
                              //  color: AppColors.contentColorGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      reservedSize: 70,
                      showTitles: true,
                      maxIncluded: false,
                      minIncluded: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      maxIncluded: false,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());

                        return SideTitleWidget(
                          meta: meta,
                          child: Transform.rotate(
                            angle: -45 * 3.14 / 180,
                            child: Text(
                              formatTime(date),
                              style: const TextStyle(
                                //  color: AppColors.contentColorGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
          )),
    );
  }
}
