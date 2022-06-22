import 'package:share_plus/share_plus.dart';

import '../../../screens/global/components/waiting.dart';
import '../../models/rc_user.dart';
import '../dynamic_link_services/dynamic_link_services.dart';

class RcShare {
  static share(RcUser rcUser) async {
    Waiting().show();
    String link = await DynamicLinksServices.createDynamicLink(rcUser.tel1);
    await Waiting().hide();
    String text =
        "Bonjour cher ami\n${rcUser.nom} ${rcUser.prenom}\nJe t'invite à rejoindre notre communauté amicale HIRONDELLE.\nVoici le lien 👇\n$link";
    await Share.share(text);
  }
}
