import 'package:charts/camera.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<dynamic, String>> _seriesPieData;
  List<Group> list;
  var pieData = [];

  void fetchProducts() async {
    await http
        .get('http://192.168.0.60:8000/api/sugar/getAnalytics')
        .then((http.Response response) {
      final Map<String, dynamic> responsee = json.decode(response.body);
      var rest = responsee['diseases_by_group'] as List;
      list = rest.map<Group>((json) => Group.fromJson(json)).toList();
    });
    _generateData();
  }

  _generateData() {
    var data1 = [
      new Pollution('USA', 1995, 30),
      new Pollution('Asia', 2000, 20),
      new Pollution('Europe', 2005, 70)
    ];
    var data2 = [
      new Pollution('USA', 1995, 62),
      new Pollution('Asia', 2000, 45),
      new Pollution('Europe', 2005, 96)
    ];
    var data3 = [
      new Pollution('USA', 1995, 22),
      new Pollution('Asia', 2000, 60),
      new Pollution('Europe', 2005, 60)
    ];

    list.forEach((Group element) =>
        pieData.add(new Task(element.name, element.count, Color(0xff109618))));
    _seriesPieData.add(charts.Series(
      data: pieData,
      domainFn: (dynamic task, _) => task.task,
      measureFn: (dynamic task, _) => task.taskvalue,
      colorFn: (dynamic task, _) =>
          charts.ColorUtil.fromDartColor(task.colorval),
      id: 'Daily Task',
      labelAccessorFn: (dynamic row, _) => '${row.taskvalue}',
    ));

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quntity,
        id: '1995',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quntity,
        id: '2000',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.forwardHatch,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quntity,
        id: '2005',
        data: data3,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _seriesPieData = List<charts.Series<dynamic, String>>();
    _seriesData = List<charts.Series<Pollution, String>>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.camera),
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.chartPie),
                ),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
              ],
            ),
            title: Text('Chart Demo'),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                      
                        Expanded(child: Camera()),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        new MaterialButton(
                            color: Colors.deepOrangeAccent,
                            onPressed: () async {
                              final List<DateTime> picked =
                                  await DateRagePicker.showDatePicker(
                                      context: context,
                                      initialFirstDate: new DateTime.now(),
                                      initialLastDate: (new DateTime.now())
                                          .add(new Duration(days: 7)),
                                      firstDate: new DateTime(1996),
                                      lastDate: new DateTime(2020));
                              if (picked != null && picked.length == 2) {
                                print(picked);
                              }
                            },
                            child: new Text("From")),
                        new MaterialButton(
                            color: Colors.indigo,
                            onPressed: () async {
                              final List<DateTime> picked2 =
                                  await DateRagePicker.showDatePicker(
                                      context: context,
                                      initialFirstDate: new DateTime.now(),
                                      initialLastDate: (new DateTime.now())
                                          .add(new Duration(days: 7)),
                                      firstDate: new DateTime(2015),
                                      lastDate: new DateTime(2020));
                              if (picked2 != null && picked2.length == 2) {
                                print(picked2);
                              }
                            },
                            child: new Text("To")),
                        Text(
                          'Sleeping',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.BarChart(
                            _seriesData,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            barGroupingType: charts.BarGroupingType.grouped,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Disease Rates',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.PieChart(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            behaviors: [
                              new charts.DatumLegend(
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 3,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts
                                        .MaterialPalette.purple.shadeDefault,
                                    fontFamily: 'Georgia',
                                    fontSize: 11),
                              )
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.inside)
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Time Spent on Daily Tasks',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.PieChart(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            behaviors: [
                              new charts.DatumLegend(
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 2,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts
                                        .MaterialPalette.purple.shadeDefault,
                                    fontFamily: 'Georgia',
                                    fontSize: 11),
                              )
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 100,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition:
                                          charts.ArcLabelPosition.inside)
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  String task;
  int taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Pollution {
  String place;
  int year;
  int quntity;

  Pollution(this.place, this.year, this.quntity);
}

class Group {
  String name;
  int count;

  Group({this.name, this.count});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        name: json["health_condition__condition_name"], count: json["dcount"]);
  }
}
