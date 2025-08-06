import '/core/common_widgets/common_widgets.dart';
import '/core/theme/theme.dart';
import 'package:flutter/material.dart';
import '/core/constants/constant.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBgColor(context),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: TitleBar(subtitle: 'Terms and Conditions'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: ListView(
            children: [
              Text(
                'Terms and Conditions for Paid Subscription',
                style: titleBoldLargeStyle(context).copyWith(color: kWhite),
              ),
              const SizedBox(height: kElementInnerGap),
              Text(
                'By subscribing to the premium version of this app, you agree to the following terms and conditions:',
                style: bodyMediumStyle(context),
              ),
              const SizedBox(height: kElementGap),

              Text(
                '1. Subscription & Billing',
                style: titleBoldMediumStyle(context),
              ),
              const SizedBox(height: kElementInnerGap),
              Text(
                '- The app offers a paid subscription that unlocks premium features.\n'
                '- Payment will be charged to your account upon confirmation of purchase.\n'
                '- Subscriptions automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.',
                style: bodyMediumStyle(context),
              ),
              const SizedBox(height: kElementGap),

              Text('2. Free Trial', style: titleBoldMediumStyle(context)),
              const SizedBox(height: kElementInnerGap),
              Text(
                '- New users may be eligible for a free trial, which provides access to premium features for a limited time.\n'
                '- To avoid being charged, users must cancel their subscription at least 24 hours before the end of the trial period.\n'
                '- If the subscription is not cancelled within this time, the payment will be processed automatically, and no refund will be issued.',
                style: bodyMediumStyle(context),
              ),
              const SizedBox(height: kElementGap),

              Text(
                '3. Cancellation & Refunds',
                style: titleBoldMediumStyle(context),
              ),
              const SizedBox(height: kElementInnerGap),
              Text(
                '- You can manage or cancel your subscription anytime through your account settings in the app store.\n'
                '- After the subscription is renewed, refunds will not be issued for the unused portion of the subscription period.',
                style: bodyMediumStyle(context),
              ),
              const SizedBox(height: kElementGap),

              Text(
                '4. Changes to Pricing and Terms',
                style: titleBoldMediumStyle(context),
              ),
              const SizedBox(height: kElementInnerGap),
              Text(
                '- We reserve the right to modify subscription pricing or these terms at any time.',
                style: bodyMediumStyle(context),
              ),
              const SizedBox(height: kElementGap),

              Text('5. User Agreement', style: titleBoldMediumStyle(context)),
              const SizedBox(height: kElementInnerGap),
              Text(
                '- By purchasing or continuing a subscription, you agree to these Terms and Conditions and our Privacy Policy.',
                style: bodyMediumStyle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
