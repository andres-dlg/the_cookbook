import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_cookbook/localization/app_translations_delegate.dart';
import 'package:the_cookbook/localization/application.dart';
import 'package:the_cookbook/pages/home/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of the application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
    loadCurrentLanguage();
  }

  loadCurrentLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentLanguage = preferences.getString("currentLanguage");
    onLocaleChange(new Locale(currentLanguage));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'The cookbook',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(callback: callback),
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("es", ""),
      ],
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  void callback(Locale locale){
    onLocaleChange(locale);
  }

}
