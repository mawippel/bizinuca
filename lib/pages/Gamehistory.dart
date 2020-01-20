import 'package:bizinuca/models/Game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GameHistory extends StatefulWidget {
  final List<Game> _gameList;

  GameHistory(this._gameList);
  @override
  _GameHistoryState createState() => _GameHistoryState(_gameList);
}

class _GameHistoryState extends State<GameHistory> {
  _GameHistoryState(this._games);
  List<DataRow> _dataRows;
  List<Game> _games;

  @override
  void initState() {
    super.initState();
    getDataRows();
  }

  getDataRows() {
    setState(() {
      _dataRows = _games
          .map((game) => DataRow(cells: [
                DataCell(Text(game.date)),
                DataCell(
                  Text(
                      "${game.players[0]} e ${game.players[1]} x ${game.players[2]} e ${game.players[3]}"),
                ),
                DataCell(
                  Text("${game.winnerPlayers[0]} e ${game.winnerPlayers[1]}"),
                )
              ]))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dataRows == null
          ? SpinKitCircle(
              color: Colors.green,
              size: 50.0,
            )
          : SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text("Data")),
                  DataColumn(
                    label: Text("Jogadores"),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Vencedores"),
                    numeric: false,
                  ),
                ],
                rows: _dataRows,
              ),
            ),
    );
  }
}
