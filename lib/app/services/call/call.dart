import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Call {
  phone(String num) async {
    final tel = "tel:$num";
    if (await canLaunchUrl(Uri.parse(tel))) {
      await launchUrl(Uri.parse(tel));
    } else {
      throw 'Could not launch $num';
    }
  }

  openWhatsapp(String whatsapp) async {
    var ios = "whatsapp://send?phone=$whatsapp&text=";
    var android = "https://wa.me/$whatsapp?text=";
    if (GetPlatform.isAndroid) {
      // for iOS phone only
      // if (await canLaunch(android)) {
      await launchUrl(Uri.parse(android), mode: LaunchMode.externalApplication);
      //  }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(ios))) {
        await launchUrl(Uri.parse(ios), mode: LaunchMode.externalApplication);
      }
    }
  }
}
