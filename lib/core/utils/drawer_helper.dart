import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class DrawerActions {
  static Future<void> privacy() async {
    const androidUrl = 'https://unisoftaps.blogspot.com/';
    const iosUrl = 'https://asadarmantech.blogspot.com';

    final url = Platform.isIOS ? iosUrl : androidUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> rateUs() async {
    const androidUrl =
        'https://play.google.com/store/apps/details?id=com.unisoftaps.estoniaweatherforecast';
    const iosUrl =
        'https://apps.apple.com/us/app/Estonia Weather Forecast/6748671693';

    final url = Platform.isIOS ? iosUrl : androidUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> moreApp() async {
    const androidUrl =
        'https://play.google.com/store/apps/developer?id=Unisoft+Apps';
    const iosUrl =
        'https://apps.apple.com/us/developer/muhammad-asad-arman/id1487950157?see-all=i-phonei-pad-apps';

    final url = Platform.isIOS ? iosUrl : androidUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
