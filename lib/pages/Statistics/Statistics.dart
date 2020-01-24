import 'package:bizinuca/services/authentication_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import 'package:bizinuca/models/StatisticsModel.dart';
import 'package:bizinuca/pages/Statistics/Tabs/OverallStatistics.dart';
import 'package:bizinuca/pages/Statistics/Tabs/PointsPerDayChart.dart';
import 'package:bizinuca/Repositories/StatisticsRepository.dart';
import 'package:bizinuca/components/Menu.dart';
import 'Tabs/Gamehistory.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  StatisticsModel _statistics;
  String _username;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 3);
    getStatistics();
    super.initState();
  }

  getStatistics() async {
    var username = (await AuthenticationService.getUserLogged()).displayName;
    var result = await StatisticsRepository.getStatistics();
    setState(() {
      _username = username;
      _statistics = result;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text("Estatísticas"),
        bottom: new TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            new Tab(
              child: Icon(Icons.event),
            ),
            new Tab(
              child: Icon(Icons.poll),
            ),
            new Tab(
              child: Icon(Icons.library_books),
            )
          ],
        ),
      ),
      body: _statistics == null
          ? SpinKitCircle(
              color: Colors.green,
              size: 50.0,
            )
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                GameHistory(_statistics.userMatches, _username),
                PointsPerDayChart(_statistics.pointsPerDay),
                OverallStatistics(
                    _statistics.mostWinnerPartner,
                    _statistics.totalPlayedMatches,
                    _statistics.totalWonMatches,
                    _statistics.wonMatchesThisMonth),
              ],
            ),
    );
  }
}
