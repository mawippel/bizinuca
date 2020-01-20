import 'package:bizinuca/components/DefaultButton.dart';
import 'package:bizinuca/models/User.dart';
import 'package:bizinuca/pages/GamePage/CustomWidgets/PrimaryText.dart';
import 'package:bizinuca/services/DialogService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Repositories/UserRepository.dart';
import '../../components/Menu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'CustomWidgets/UsersDropdown.dart';
import 'GameLogic.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<DropdownMenuItem<User>> _usersToDropdown;
  List<User> _usersToPlay;
  bool isGameRunning = false;
  final int playersQuantity = 4;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getUsers();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void getUsers() {
    UserRepository.getUsers().then((users) {
      _usersToPlay = new List<User>();
      setState(() {
        for (var i = 0; i < playersQuantity; i++) {
          _usersToPlay.add(users[i]);
        }
        _usersToDropdown = getDropdownUsers(users);
      });
    });
  }

  List<DropdownMenuItem<User>> getDropdownUsers(List<User> users) {
    return users
        .map((user) =>
            new DropdownMenuItem(value: user, child: Text('${user.name}')))
        .toList();
  }

  void startGame() {
    var userRepeated = getUserRepeated();
    if (userRepeated == null)
      setState(() {
        isGameRunning = true;
      });
    else {
      DialogService.showAlertDialog(
          context, "Não existem dois ${userRepeated.name}!");
    }
  }

  User getUserRepeated() {
    for (var i = 0; i < playersQuantity - 1; i++) {
      var isUserRepeated =
          _usersToPlay.where((x) => x.id == _usersToPlay[i].id).length > 1;
      if (isUserRepeated) return _usersToPlay[i];
    }
    return null;
  }

  void announceVictory(String textDialog) {
    DialogService.showAlertDialog(context, textDialog);
  }

  //TODO : DISPLAY LOADER WHILE UPDATING
  void handleVictory(WinnerSide winnerSide) {
    if (winnerSide == WinnerSide.LeftSide) {
      GameLogic.recalculateUserPoints(_usersToPlay, WinnerSide.LeftSide)
          .then((res) {
        announceVictory(
            "${_usersToPlay[0].name} e ${_usersToPlay[1].name} venceram!");
      });
    } else {
      GameLogic.recalculateUserPoints(_usersToPlay, WinnerSide.LeftSide)
          .then((res) {
        announceVictory(
            "${_usersToPlay[2].name} e ${_usersToPlay[3].name} venceram!");
      });
    }
  }

  void handleDropdown1(User selectedUser) {
    setState(() {
      _usersToPlay[0] = selectedUser;
    });
  }

  void handleDropdown2(User selectedUser) {
    setState(() {
      _usersToPlay[1] = selectedUser;
    });
  }

  void handleDropdown3(User selectedUser) {
    setState(() {
      _usersToPlay[2] = selectedUser;
    });
  }

  void handleDropdown4(User selectedUser) {
    setState(() {
      _usersToPlay[3] = selectedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.green,
        drawer: Menu(),
        body: _usersToPlay == null
            ? SpinKitCircle(
                color: Colors.white,
                size: 50.0,
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF66BB6A),
                      Color(0xFF388E3C),
                      Color(0xFF1B5E20),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Bizinuca Challenge",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: FlatButton(
                        child: Icon(
                          Icons.dehaze,
                          color: Colors.black,
                        ),
                        onPressed: () => _scaffoldKey.currentState.openDrawer(),
                      ),
                      trailing: Image.asset('images/billiards.png'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        isGameRunning
                            ? Column(
                                children: <Widget>[
                                  PrimaryText(
                                      '${_usersToPlay[0].name} e ${_usersToPlay[1].name}'),
                                  DefaultButton(
                                      'Selecionar Vencedor',
                                      () =>
                                          DialogService.showConfirmationDialog(
                                              context, () {
                                            Navigator.of(context).pop();
                                            handleVictory(WinnerSide.LeftSide);
                                          }, "Confirmar Vencedor?"),
                                      Colors.black),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  UsersDropDown(_usersToPlay[0],
                                      _usersToDropdown, handleDropdown1),
                                  UsersDropDown(_usersToPlay[1],
                                      _usersToDropdown, handleDropdown2),
                                ],
                              ),
                        isGameRunning
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Jogo rolando...",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image(
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                      color: Colors.black,
                                      image: AssetImage('images/tacos.png'),
                                    ),
                                  ),
                                  DefaultButton(
                                      "Cancelar",
                                      () => setState(() {
                                            this.isGameRunning = false;
                                          }),
                                      Colors.red)
                                ],
                              )
                            : DefaultButton(
                                'Iniciar Jogo',
                                startGame,
                                Colors.black,
                              ),
                        isGameRunning
                            ? Column(
                                children: <Widget>[
                                  PrimaryText(
                                      '${_usersToPlay[2].name} e ${_usersToPlay[3].name}'),
                                  DefaultButton(
                                    'Selecionar Vencedor',
                                    () => DialogService.showConfirmationDialog(
                                        context, () {
                                      Navigator.of(context).pop();
                                      handleVictory(WinnerSide.RightSide);
                                    }, "Confirmar Vencedor?"),
                                    Colors.black,
                                  ),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  UsersDropDown(_usersToPlay[2],
                                      _usersToDropdown, handleDropdown2),
                                  UsersDropDown(_usersToPlay[3],
                                      _usersToDropdown, handleDropdown3),
                                ],
                              )
                      ],
                    ),
                  ],
                ),
              ));
  }
}
