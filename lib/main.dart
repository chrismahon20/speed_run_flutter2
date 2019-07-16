import 'package:flutter/material.dart';
import 'package:speed_run/database_helpers.dart';
import 'package:camera/camera.dart';
DatabaseHelper helper = DatabaseHelper.instance;
List<CameraDescription> cameras;
Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

List<String> _listData = new List<String>();
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeedRun Tracker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(title: 'SpeedRun Tracker'),
    );
  }
}



//---------- Home Page ----------\\

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _newRun() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("SpeedRun Tracker"),
      ),
      drawer: Drawer(

        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Chris Mahon"),
                accountEmail: Text("chriswmahon20@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                      ? Colors.blue
                      : Colors.white,
                  child: Text(
                    "C",
                    style: TextStyle(fontSize:40.0),
                  )
                ),
              ),
              ListTile(
                title: Text("Home"),
                trailing: Icon(Icons.home),
                onTap: (){
                  if(Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MyHomePage()));
                  }
                },
              ),
              ListTile(
                title: Text("Run List"),
                trailing: Icon(Icons.table_chart),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RunList()));
                },
              ),
              ListTile(
                title: Text("Statistics"),
                trailing: Icon(Icons.show_chart)
              ),
              ListTile(
                title: Text("Falls"),
                trailing: Icon(Icons.grain)
              ),
              ListTile(
                  title: Text("Camera"),
                  trailing: Icon(Icons.videocam),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Camera()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to SpeedRun Tracker',
                style: Theme.of(context).textTheme.headline,
            ),
            /*Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),*/
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), */// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


Future<void> getData() async{
  _listData = await readDates();
}

//---------- Run List Page ----------\\


class RunList extends StatefulWidget {
  @override
  State createState() => new RunListState();
}

class RunListState extends State<RunList>{
  @override
  void initState(){
    //getData();
    setState((){
      getData();
    });
  }
  List<ExpansionTile> _listOfExpansions = List<ExpansionTile>.generate(
      _listData.length,
          (i) => ExpansionTile(
        title: Text(_listData[i]),
        children: _listData
            .map((data) => ListTile(
          leading: Icon(Icons.person),
          title: Text(data),
          subtitle: Text("a subtitle here"),
        ))
            .toList(),
      ));

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Run List"),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children:
        _listOfExpansions.map((expansionTile) => expansionTile).toList(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewRun()));
        },
        child: Icon(Icons.add),
      ),
    );

  }

}


class storedRun{
  bool isChecked;
  double time;
  String date;
  String notes;
  storedRun(bool _isChecked, double _time, String _date, String _notes){
    isChecked = _isChecked;
    time = _time;
    date = _date;
    notes = _notes;
  }
}


//---------- New Run Page ----------\\
/*
Gets input from user with time, date, and notes.
Adds to database.
 */


class NewRun extends StatefulWidget {
  @override
  NewRunState createState() {
    return NewRunState();
  }
}
class NewRunState extends State<NewRun>{
  bool isChecked;
  double time;
  String date;
  String notes;

  storedRun run = storedRun(false,0,"", "");

  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context){
    if(isChecked == null){
      isChecked = false;
    }
    //time = run.time;
    if(time == null){
      time = 0;
    }
    /*else {
      run.time = time;
    }*/
    DateTime today = new DateTime.now();
    var timeTxt = new TextEditingController();
    timeTxt.text = time.toString() ?? "";
    if (time == 0){
      timeTxt.text = "";
    }
    var txt = new TextEditingController();
    var txt2 = new TextEditingController();
    txt2.text = notes ?? "";
    //txt.text = DateTime.now().toString();
    String dateText ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    txt.text = date ?? dateText;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Run"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'New Run',
              style: Theme.of(context).textTheme.headline,
            ),
            new Flexible(
              child:TextField(
                controller: timeTxt,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Enter your time',
                    //border: InputBorder.none,
                    hintText: '0.00'
                ),
                onEditingComplete: () {
                  setState(() => run.time = double.parse(timeTxt.text));
                }
              ),
            ),
            new Flexible(
              child:TextField(
                controller: txt,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    labelText: 'Enter the date',
                    //border: InputBorder.none,
                    hintText: dateText,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async{
                        double time2 = time;
                        String notes2 = notes;
                        DateTime dt = await _selectDate(context);
                        String dateText ="${dt.year.toString()}-${dt.month.toString().padLeft(2,'0')}-${dt.day.toString().padLeft(2,'0')}";
                        txt.text = dateText;
                        date = dateText;
                        timeTxt.text = time2.toString();
                        txt2.text = notes2;
                        setState(() => run = storedRun(isChecked, time2, date, notes2));
                      },
                  ),
                ),
              ),
            ),
            new Flexible(
              child:TextField(
                controller: txt2,
                maxLines: 5,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    labelText: 'Notes',
                    //border: InputBorder.none,
                    hintText: '',
                ),
                  onEditingComplete: () {
                    setState(() => run.notes = txt2.text);
                  },
              ),
            ),
            Spacer(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Add Another"),
                new Checkbox(
                    value: isChecked ?? false,
                    onChanged: (val){
                      time = double.parse(timeTxt.text) ?? 0;
                      setState((){
                        if(isChecked == null){
                          isChecked = false;
                        }
                        isChecked = val;
                        timeTxt.text = time.toString();
                        return isChecked = val;
                      });
                    }
                ),
                new RaisedButton(
                    onPressed: () async{
                      Run run = Run();
                      run.time = double.parse(timeTxt.text);
                      run.date = DateTime.parse(txt.text).millisecond;
                      run.notes = txt2.text;
                      int id = await helper.insert(run);
                      print('inserted row: $id');
                      if(!isChecked) {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => RunList()));
                      }
                      else{
                        timeTxt.clear();
                        txt2.clear();
                        //setState(() => time = 0);
                        //setState(() => notes = "");
                      }
                    },
                    child: Text("Submit")
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//---------- Helper Functions ----------\\

_read() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  int rowId = 1;
  Run run = await helper.queryWord(rowId);
  if (run == null) {
    print('read row $rowId: empty');
  } else {
    print('read row $rowId: ${run.time} ${run.date}');
  }
}

Future<List<String>> readDates() async {
  List<Map> dates = await helper.queryDates();
  List<int> dateNums = new List<int>();
  List<String> dateStrs = new List<String>();
  List<DateTime> dateList = new List<DateTime>();
  try {
    for (int i = 0; i < dates.length; i++) {
      dateNums.add(dates[i].values.toList()[0]);
      dateList.add(DateTime.fromMillisecondsSinceEpoch(dateNums[i]));
      DateTime dt = dateList[i];
      dateStrs.add(
          "${dt.year.toString()}-${dt.month.toString().padLeft(2, '0')}-${dt.day
              .toString().padLeft(2, '0')}");
    }
  }
  catch(e){
    //throw(e);
  }
  return dateStrs;
}

_save() async {
  Run run = Run();
  run.time = 10;
  run.date = 15;
  DatabaseHelper helper = DatabaseHelper.instance;
  int id = await helper.insert(run);
  print('inserted row: $id');
}

Future<DateTime> _selectDate(BuildContext context) async {
  final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime(1900),
      lastDate: DateTime.now()
  );
  if(picked != null){
    return picked;
  }
  else{
    return DateTime.now();
  }
}

class Camera extends StatefulWidget {
  @override
  State createState() => new CameraState();
}

class CameraState extends State<Camera>{
  CameraController controller;
  Stopwatch timer;
  double time = 0.00;

  @override
  void initState() {
    super.initState();
    timer = Stopwatch();
    time = 0.00;
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return new Stack(
      alignment: FractionalOffset.center,
      children: <Widget>[
        new Positioned.fill(
          child: new AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: new CameraPreview(controller)),
        ),
        new RaisedButton(
          onPressed: () async{
            timer.start();
            //controller.startVideoRecording();
            time = timer.elapsedMilliseconds/1000;
            while(timer.elapsedMilliseconds/1000 < 3){

            }
            setState(() => time = time);
          },
        ),
        new RichText(
          text: TextSpan(
            text:time.toString(),
          )
        )
      ],
    );

  }

}