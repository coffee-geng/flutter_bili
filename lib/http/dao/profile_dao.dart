import 'package:flutter_bili/http/request/profile_request.dart';

import '../../model/profile_mo.dart';
import '../core/hi_net.dart';

class ProfileDao {
  //https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    return ProfileMo.fromJson(result['data']);
  }
}
