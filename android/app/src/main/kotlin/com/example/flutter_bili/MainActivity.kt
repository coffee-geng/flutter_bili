package com.example.flutter_bili

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
            val window = activity.window
            //设置状态栏为透明色, 修复启动时状态栏会灰色闪一下
            window.statusBarColor = Color.TRANSPARENT
        }
    }
}
