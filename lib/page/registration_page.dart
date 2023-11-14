import 'package:flutter/material.dart';
import 'package:hi_base/hi_state.dart';
import 'package:flutter_bili/http/dao/login_dao.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/utils/toast.dart';
import 'package:flutter_bili/widget/login_button.dart';
import 'package:flutter_bili/widget/login_effect.dart';
import 'package:flutter_bili/widget/login_input.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import 'package:hi_base/string_util.dart';
import '../widget/app_bar.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends HiState<RegistrationPage> {
  bool _protect = false;
  bool _loginEnable = false;
  String? userName;
  String? password;
  String? confirmedPassword;
  String? imoocId;
  String? orderId;

  late RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(listener = (current, prev) {
      if (widget == current.widget || current.widget is! RegistrationPage) {
        print(
            '页面${(prev != null) ? "从${prev!.widget.toString()}" : ""} 切换到${current.widget.toString()}');
      } else if (prev != null &&
          (widget == prev.widget || prev.widget is RegistrationPage)) {
        print('页面${prev.widget.toString()} 被压后台');
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', rightTitle: '登录', rightButtonClick: () {
        context.read<ThemeProvider>().setTheme(ThemeMode.light);
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: Container(
        // 自适应键盘弹起，防止遮挡输入框
        child: ListView(
          children: [
            LoginEffect(protect: _protect),
            LoginInput(
                title: '用户名',
                hint: '请输入用户名',
                onTextChanged: (text) {
                  userName = text;
                  checkInput();
                }),
            LoginInput(
                title: '密码',
                hint: '请输入密码',
                obsecureText: true,
                lineStretch: true,
                onTextChanged: (text) {
                  password = text;
                  checkInput();
                },
                onFocusChanged: (focused) {
                  setState(() {
                    _protect = focused;
                  });
                }),
            LoginInput(
                title: '确认密码',
                hint: '请再次输入密码',
                obsecureText: true,
                lineStretch: true,
                onTextChanged: (text) {
                  confirmedPassword = text;
                  checkInput();
                },
                onFocusChanged: (focused) {
                  setState(() {
                    _protect = focused;
                  });
                }),
            LoginInput(
                title: '慕课网ID',
                hint: '请输入你的慕课网用户ID',
                keyboardType: TextInputType.number,
                onTextChanged: (text) {
                  imoocId = text;
                  checkInput();
                }),
            LoginInput(
                title: '课程订单号',
                hint: '请输入课程订单号后四位',
                keyboardType: TextInputType.number,
                onTextChanged: (text) {
                  orderId = text;
                  checkInput();
                }),
            Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: LoginButton('注册',
                    enable: _loginEnable, onPressed: checkParams))
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enabled;
    if (isNotEmptyOrWhitespace(userName) &&
        isNotEmptyOrWhitespace(password) &&
        isNotEmptyOrWhitespace(confirmedPassword) &&
        isNotEmptyOrWhitespace(imoocId) &&
        isNotEmptyOrWhitespace(orderId)) {
      enabled = true;
    } else {
      enabled = false;
    }
    setState(() {
      _loginEnable = enabled;
    });
  }

  void checkParams() {
    String? tips;
    if (password != confirmedPassword) {
      tips = '两次密码不一致';
    } else if (orderId?.length != 4) {
      tips = '请输入订单号的后四位';
    }
    if (tips != null) {
      print(tips);
      showWarningToast(tips);
      return;
    }
    send();
  }

  void send() {
    try {
      var result = LoginDao.registration(
          userName ?? '', password ?? '', imoocId ?? '', orderId ?? '');
      if (result['code'] == 0) {
        print('注册成功');
        showToast('注册成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      } else {
        print(result['msg']);
        showWarningToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarningToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarningToast(e.message);
    }
  }
}
