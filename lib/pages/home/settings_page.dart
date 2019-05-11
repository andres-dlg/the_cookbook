import 'package:flutter/material.dart';
import 'package:the_cookbook/database/database_helper.dart';
import 'package:the_cookbook/localization/app_translations.dart';
import 'package:the_cookbook/utils/separator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget{

  final Function callback;

  SettingsPage({this.callback});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  List<String> languages;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedLanguage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initMenuItems();
    return Scaffold(
      appBar: _renderAppBar(),
      body: _renderBody(),
    );
  }

  Widget _renderAppBar(){
    final String title = AppTranslations.of(context).text("key_settings");
    final double barHeight = 60.0;
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return PreferredSize(
      child: Container(
        padding: new EdgeInsets.only(top: statusbarHeight),
        height: statusbarHeight + barHeight,
        child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new Text(
                      title,
                      style: new TextStyle(fontSize: 40.0, color: Colors.white, fontFamily: 'Cookie'),
                    ),
                  ),
                ],
              ),
              Material(
                type: MaterialType.transparency,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Center(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.white, onPressed: () {
                        Navigator.pop(context);
                      },
                      ),
                    ),
                  ],
                ),
              )
            ]
        ),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
            gradient: new LinearGradient(
                colors: [Color.fromRGBO(179,229,252, 1), Colors.blueAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.5, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0
              )
            ]
        ),
      ),
      preferredSize: new Size(
          MediaQuery.of(context).size.width,
          150.0
      ),
    );
  }

  Widget _renderBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //_renderDatabaseSection(),
          _renderLanguageSection(),
          _renderAboutSection()
        ],
      ),
    );
  }

  Widget _renderDatabaseSection() {
    return Card(
      elevation: 3.0,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              width: 32,
              height: 32,
              child: Image(
                image: AssetImage("assets/images/database.png"),
              ),
            ),
            title: Text(
              AppTranslations.of(context).text("key_data_title"),
              style: TextStyle(
                fontFamily: 'Muli',
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              AppTranslations.of(context).text("key_data_subtitle"),
              style: TextStyle(
                fontFamily: 'Muli',
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Center(child: GradientSeparator(width: MediaQuery.of(context).size.width-24,heigth: 1.0,startColor: Colors.white,endColor: Colors.blueAccent,)),
          ListTile(
            leading: Container(
              width: 32,
              height: 28,
              child: Image(
                image: AssetImage("assets/images/database_export.png"),
              ),
            ),
            title: Text(
              AppTranslations.of(context).text("key_data_export"),
              style: TextStyle(
                  fontFamily: 'Muli'
              ),
            ),
            onTap: () {
              DatabaseHelper dbHelper = new DatabaseHelper();
              dbHelper.backUpDb();
            },
          ),
          ListTile(
            leading: Container(
              width: 32,
              height: 28,
              child: Image(
                image: AssetImage("assets/images/database_import.png"),
              ),
            ),
            title: Text(
              AppTranslations.of(context).text("key_data_import"),
              style: TextStyle(
                  fontFamily: 'Muli'
              ),
            ),
            onTap: () {}
          ),
        ],
      ),
    );
  }

  Widget _renderLanguageSection() {
    return Card(
      elevation: 3.0,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              width: 32,
              height: 32,
              child: Image(
                image: AssetImage("assets/images/world.png"),
              ),
            ),
            title: Text(
              AppTranslations.of(context).text("key_region"),
              style: TextStyle(
                fontFamily: 'Muli',
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              AppTranslations.of(context).text("key_region_subtitle"),
              style: TextStyle(
                fontFamily: 'Muli',
                fontWeight: FontWeight.bold
              ),
            )
          ),
          Center(child: GradientSeparator(width: MediaQuery.of(context).size.width-24,heigth: 1.0,startColor: Colors.white,endColor: Colors.blueAccent,)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppTranslations.of(context).text("key_region_language"),
                  style: TextStyle(
                    fontFamily:  'Muli',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: DropdownButton(
                  style: TextStyle(
                      fontFamily: 'Muli',
                      color: Colors.black
                  ),
                  items: _dropDownMenuItems,
                  onChanged: (newSelectedLanguage) {
                    setState(() {
                      this._selectedLanguage = newSelectedLanguage;
                      if(newSelectedLanguage == "Español" || newSelectedLanguage == "Spanish"){
                        widget.callback(new Locale("es"));
                        _saveLanguage("es");
                      }else{
                        widget.callback(new Locale("en"));
                        _saveLanguage("en");
                      }
                    });
                  },
                  value: this._selectedLanguage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderAboutSection() {
    return Card(
      elevation: 3.0,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              width: 32,
              height: 32,
              child: Image(
                image: AssetImage("assets/images/info.png"),
              ),
            ),
            title: Text(
              AppTranslations.of(context).text("key_about"),
              style: TextStyle(
                fontFamily: 'Muli',
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              AppTranslations.of(context).text("key_about_subtitle"),
              style: TextStyle(
                  fontFamily: 'Muli',
                  fontWeight: FontWeight.bold
              ),
            ),
            onTap: () {

              _showAboutDialog();

            },
          ),
        ],
      ),
    );
  }

  _saveLanguage(String currentLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentLanguage', currentLanguage);
  }

  void initMenuItems(){
    String curr = AppTranslations.of(context).currentLanguage;
    if(curr.toLowerCase() == "es"){
      _selectedLanguage = AppTranslations.of(context).text("key_spanish");
    }else{
      _selectedLanguage = AppTranslations.of(context).text("key_english");
    }

    languages = <String>[
      AppTranslations.of(context).text("key_english"),
      AppTranslations.of(context).text("key_spanish"),
    ];

    _dropDownMenuItems = languages
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        )
      ).toList();

  }

  void _showAboutDialog() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          content: SingleChildScrollView(
            child: new Container(
              width: MediaQuery.of(context).size.width-24,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "The Cookbook",
                        style: TextStyle(
                          fontFamily: 'Cookie',
                          fontSize: 36
                        ),
                      ),
                    ),
                    Center(child: Separator(heigth: 1.0,width: 64.0,color: Colors.blueAccent,)),
                    Text(
                      AppTranslations.of(context).text("key_about_1"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 16
                      ),
                    ),
                    Text(
                          "- carousel_slider\n"
                          "- image_picker\n"
                          "- image_cropper\n"
                          "- sqflite\n"
                          "- path_provider\n"
                          "- flutter_slidable\n"
                          "- shared_preferences\n"
                          "- url_launcher\n",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 16
                      ),
                    ),
                    Text(
                      AppTranslations.of(context).text("key_about_2"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 16
                      ),
                    ),
                    _renderIconRow("clock", "Smashicons"),
                    _renderIconRow("cookbook", "Freepik"),
                    _renderIconRow("recipes-book", "Freepik"),
                    _renderIconRow("donut", "Freepik"),
                    _renderIconRow("info", "Freepik"),
                    _renderIconRow("world", "Freepik"),
                    _renderIconRow("ingredients", "monkik"),
                    _renderIconRow("summary", "Kiranshastry"),
                    _renderIconRow("turn", "Pixelmeetup"),
                    Text(
                      AppTranslations.of(context).text("key_about_3"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 16
                      ),
                    ),
                    Text(
                      AppTranslations.of(context).text("key_about_4"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 16
                      ),
                    ),
                    Text(
                      AppTranslations.of(context).text("key_about_5"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Cookie',
                          fontSize: 24
                      ),
                    ),
                    Center(child: Separator(heigth: 1.0,width: 64.0,color: Colors.blueAccent,)),
                    Text(
                      AppTranslations.of(context).text("key_about_6"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 16
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          _launchURL();
                        },
                        child: Text(
                          "andresdlg21@gmail.com",
                          style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: 16,
                            color: Colors.blue
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        AppTranslations.of(context).text("key_about_7"),
                        style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 16
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        AppTranslations.of(context).text("key_about_8"),
                        style: TextStyle(
                            fontFamily: 'Muli',
                            fontSize: 16
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Image.asset("assets/images/donut.png"),
                          width: 48,
                          height: 48,
                        ),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        color: Colors.white,
                        child: Text("Close"), onPressed: () {Navigator.pop(context);},
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _renderIconRow(String iconName, String author){
    return Row(
      children: <Widget>[
        Container(
          child: Image.asset("assets/images/$iconName.png"),
          height: 24,
          width: 24,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "-> $author",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Muli',
                fontSize: 16
            ),
          ),
        ),
      ],
    );
  }

  _launchURL() async {
    const url = 'mailto:andresdlg21@gmail.com?subject=Contacting%20from%20The%20Cookbook%20App';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}