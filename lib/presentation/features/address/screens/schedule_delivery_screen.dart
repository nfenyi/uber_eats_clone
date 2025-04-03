import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../main.dart';
import '../../../../state/delivery_schedule_provider.dart';
import '../../../core/app_colors.dart';

class ScheduleDeliveryScreen extends ConsumerStatefulWidget {
  final bool isFromGiftScreen;
  const ScheduleDeliveryScreen({super.key, required this.isFromGiftScreen});

  @override
  ConsumerState<ScheduleDeliveryScreen> createState() =>
      _ScheduleDeliveryScreenState();
}

class _ScheduleDeliveryScreenState
    extends ConsumerState<ScheduleDeliveryScreen> {
  late final List<DateTime> _days = [];
  late final List<DateTime> _times = [];

  late DateTime _selectedTime;

  late DateTime _selectedDay;

  @override
  void initState() {
    final dateTimeNow = DateTime.now();
    super.initState();
    for (var i = 0; i < 7; i++) {
      if (i == 0) {
        _days.add(DateTime.now());
      } else {
        _days.add(DateTime.now().add(Duration(days: i)));
      }
    }
    for (var i = 0; i < 30; i++) {
      if (i == 0) {
        _times.add(DateTime(
            dateTimeNow.year, dateTimeNow.month, dateTimeNow.day, 7, 45));
      } else {
        _times.add(_times[i - 1].add(Duration(minutes: 15 * i)));
      }
    }
    _selectedTime = _times.first;
    _selectedDay = _days.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Column(
          children: [
            AppButton(
              text: 'Schedule',
              callback: () {
                if (_selectedTime.difference(DateTime.now()) >
                        const Duration(hours: 1) ||
                    _selectedDay.isAfter(DateTime.now())) {
                  // navigatorKey.currentState!.pop(_selectedDay.copyWith(
                  //     hour: _selectedTime.hour, minute: _selectedTime.minute));
                  // Hive.box(AppBoxes.appState).put(BoxKeys.activatedPromoPath, value)
                  if (widget.isFromGiftScreen) {
                    ref
                            .read(deliveryScheduleProviderForRecipient.notifier)
                            .state =
                        _selectedDay.copyWith(
                            hour: _selectedTime.hour,
                            minute: _selectedTime.minute);
                  } else {
                    ref.read(deliveryScheduleProvider.notifier).state =
                        _selectedDay.copyWith(
                            hour: _selectedTime.hour,
                            minute: _selectedTime.minute);
                  }
                  navigatorKey.currentState!.pop();
                } else {
                  showInfoToast(
                      'The time schedule time selected must be at least an hour ahead of now',
                      context: context);
                }
              },
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    isSecondary: true,
                    text: 'Cancel',
                    callback: () => navigatorKey.currentState!.pop(),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
      appBar: AppBar(
          // leading: InkWell(
          //   onTap: () {
          //     if (_selectedTime.difference(DateTime.now()) >
          //             const Duration(hours: 1) ||
          //         _selectedDay.isAfter(DateTime.now())) {
          //       // navigatorKey.currentState!.pop(_selectedDay.copyWith(
          //       //     hour: _selectedTime.hour, minute: _selectedTime.minute));
          //       ref.read(deliveryScheduleProvider.notifier).state =
          //           _selectedDay.copyWith(
          //               hour: _selectedTime.hour, minute: _selectedTime.minute);
          //       navigatorKey.currentState!.pop();
          //     } else {
          //       showInfoToast(
          //           'The time schedule time selected must be at least an hour ahead of now',
          //           context: context);
          //     }
          //   },
          //   child: Ink(
          //     child: const Icon(Icons.arrow_back),
          //   ),
          // ),
          ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: AppText(
              text: 'Schedule delivery',
              weight: FontWeight.w600,
              size: AppSizes.heading6,
            ),
          ),
          const Gap(10),
          SizedBox(
            height: 75,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  child: Container(
                    width: 110,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: _selectedDay == day ? 2 : 1,
                          color: _selectedDay == day
                              ? Colors.black
                              : AppColors.neutral300,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: index == 0
                                ? 'Today'
                                : index == 1
                                    ? 'Tomorrow'
                                    : AppFunctions.formatDate(day.toString(),
                                        format: 'l')),
                        const Gap(10),
                        AppText(
                            color: AppColors.neutral500,
                            text: AppFunctions.formatDate(day.toString(),
                                format: 'M j'))
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Gap(10),
            ),
          ),
          const Gap(10),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: AppColors.neutral100,
              ),
              itemCount: _times.length,
              itemBuilder: (context, index) {
                final time = _times[index];
                return RadioListTile(
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedTime = value;
                      });
                    }
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: _selectedTime,
                  value: _times[index],
                  title: AppText(
                      size: AppSizes.bodySmall,
                      text:
                          '${AppFunctions.formatDate(time.toString(), format: 'G:i A')} - ${AppFunctions.formatDate(time.add(const Duration(minutes: 30)).toString(), format: 'G:i A')}'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
