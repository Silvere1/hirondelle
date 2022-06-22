import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/utils/constants/rc_assets_files.dart';

Center buildListEmpty() =>
    Center(child: SvgPicture.asset(RcAssets.icListIsEmpty));
