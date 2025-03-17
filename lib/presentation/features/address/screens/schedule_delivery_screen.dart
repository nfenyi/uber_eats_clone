import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../main.dart';
import '../../../core/app_colors.dart';
import 'addresses_screen.dart';

class ScheduleDeliveryScreen extends StatefulWidget {
  const ScheduleDeliveryScreen({super.key});

  @override
  State<ScheduleDeliveryScreen> createState() => _ScheduleDeliveryScreenState();
}

class _ScheduleDeliveryScreenState extends State<ScheduleDeliveryScreen> {
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
                  navigatorKey.currentState!.pop(_selectedDay.copyWith(
                      hour: _selectedTime.hour, minute: _selectedTime.minute));
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
                  child: AppButton2(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
        leading: InkWell(
          onTap: () {
            if (_selectedTime.difference(DateTime.now()) >
                    const Duration(hours: 1) ||
                _selectedDay.isAfter(DateTime.now())) {
              navigatorKey.currentState!.pop(_selectedDay.copyWith(
                  hour: _selectedTime.hour, minute: _selectedTime.minute));
            } else {
              showInfoToast(
                  'The time schedule time selected must be at least an hour ahead of now',
                  context: context);
            }
          },
          child: Ink(
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Schedule delivery',
              weight: FontWeight.w600,
              size: AppSizes.heading6,
            ),
            const Gap(10),
            SizedBox(
              height: 70,
              child: ListView.separated(
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
                    contentPadding: EdgeInsets.zero,
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
      ),
    );
  }
}
