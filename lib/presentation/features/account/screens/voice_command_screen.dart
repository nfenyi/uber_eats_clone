import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../core/app_colors.dart';

class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  final List<String> _assistantOptions = ['Alexa'];
  late String _selectedAssistant;

  bool _trackWithAlexa = false;

  @override
  void initState() {
    super.initState();
    _selectedAssistant = "Alexa";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar.medium(
                  pinned: true,
                  title: AppText(
                    text: 'Voice command settings',
                    weight: FontWeight.bold,
                    size: AppSizes.heading6,
                  ),
                )
              ],
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChipsChoice<String>.single(
                wrapped: false,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                value: _selectedAssistant,
                onChanged: (value) {
                  setState(() {
                    _selectedAssistant = value;
                  });
                },
                choiceItems: C2Choice.listFrom<String, String>(
                  source: _assistantOptions,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                choiceStyle: C2ChipStyle.filled(
                  selectedStyle: const C2ChipStyle(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  height: 30,
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.neutral200,
                ),
              ),
              const Gap(10),
              SwitchListTile.adaptive(
                value: _trackWithAlexa,
                onChanged: (value) {
                  setState(() {
                    _trackWithAlexa = value;
                  });
                },
                subtitle: const AppText(
                  text: "Alexa will notify you of your order's status",
                ),
                title: const AppText(
                  text: "Show \"Track with Alexa\" after checkout",
                  size: AppSizes.bodySmall,
                  weight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      text: 'Finish Alexa setup',
                      weight: FontWeight.bold,
                      size: AppSizes.bodySmall,
                    ),
                    const Gap(15),
                    ListTile(
                      leading: Image.asset(
                        AssetNames.voiceCommand1,
                        width: 40,
                      ),
                      title: const AppText(
                        text:
                            "On the order tracking screen, tap \"Track with Alexa\".",
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        AssetNames.voiceCommand2,
                        width: 40,
                      ),
                      title: const AppText(
                        text:
                            "Choose how Alexa notifies you about order updates.",
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        AssetNames.voiceCommand3,
                        width: 40,
                      ),
                      title: const AppText(
                        text:
                            "Get updates on your chosen Alexa device while your food is on the move.",
                      ),
                    ),
                    const Gap(20),
                    const AppText(
                        text:
                            'By clicking "Track with Alexa", order status information will be shared with Amazon.')
                  ],
                ),
              )
            ],
          )),
    );
  }
}
