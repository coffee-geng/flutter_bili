import 'package:flutter_bili/http/dao/login_dao.dart';

class HiConstant {
  static const authTokenK = 'auth-token';
  static const authTokenV = 'ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa';
  static const courseFlagK = 'course-flag';
  static const courseFlagV = 'fa';

  static const theme = 'hi_theme';

  static headers() {
    ///设置请求头校验，注意留意：Console的log输出：flutter: received:
    Map<String, dynamic> header = {
      HiConstant.authTokenK: HiConstant.authTokenV,
      HiConstant.courseFlagK: HiConstant.courseFlagV
    };
    header[LoginDao.BOARDING_PASS] = LoginDao.getBoardingPass();
    return header;
  }
}
