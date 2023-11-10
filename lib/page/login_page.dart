import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_state.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/widget/app_bar.dart';
import 'package:flutter_bili/widget/login_button.dart';
import 'package:flutter_bili/widget/login_effect.dart';
import 'package:flutter_bili/widget/login_input.dart';
import 'package:provider/provider.dart';

import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../utils/string_util.dart';
import '../utils/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends HiState<LoginPage> {
  bool _protect = false;
  bool _loginEnable = false;
  String? userName;
  String? password;

  late RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(listener = (current, prev) {
      if (widget == current.widget || current.widget is! LoginPage) {
        print(
            '页面${(prev != null) ? "从${prev!.widget.toString()}" : ""} 切换到${current.widget.toString()}');
      } else if (prev != null &&
          (widget == prev.widget || prev.widget is LoginPage)) {
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
      appBar: appBar('密码登录', rightTitle: '注册', key: Key('registration'),
          rightButtonClick: () {
        context.read<ThemeProvider>().setTheme(ThemeMode.dark);
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
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
                onTextChanged: (text) {
                  password = text;
                  checkInput();
                },
                onFocusChanged: (focused) {
                  setState(() {
                    _protect = focused;
                  });
                }),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                '登录',
                enable: _loginEnable,
                onPressed: send,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enabled;
    if (isNotEmptyOrWhitespace(userName) && isNotEmptyOrWhitespace(password)) {
      enabled = true;
    } else {
      enabled = false;
    }
    setState(() {
      _loginEnable = enabled;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName ?? '', password ?? '');
      if (result['code'] == 0) {
        print('登录成功');
        showToast('登录成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
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
