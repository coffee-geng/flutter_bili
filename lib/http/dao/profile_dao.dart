import 'package:flutter_bili/http/request/profile_request.dart';
import 'package:hi_net/hi_net.dart';
import '../../model/profile_mo.dart';

class ProfileDao {
  //https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    return ProfileMo.fromJson(result['data']);
  }
}
