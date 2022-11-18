import 'package:area/src/screens/generic_action_conf.dart';
import 'package:area/src/screens/sideNavBar.dart';
import 'package:flutter/material.dart';
import '../mixins/send_json.dart';
import '../mixins/user_class.dart';
import 'dart:convert';
import 'package:area/src/screens/sideNavBar.dart';
import '../mixins/validation_mixin.dart';

class Actionscreen extends StatelessWidget
    with NetworkingHelper, ValidationMixin {
  @override
  final action_list;
  Actionscreen({required this.action_list});
  final gradient = const LinearGradient(colors: [Colors.blue, Colors.purple]);

  @override
  static Map<String, dynamic> action = {};
  Widget build(BuildContext context) {
    var _actions = parse_actions(action_list);
    return Scaffold(
      drawer: sideNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return gradient.createShader(Offset.zero & bounds.size);
          },
          child: const Text(
            'AREA-CATT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text('Selectionner une actions',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _actions.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  leading: Image.network(_actions[index][0]['img']),
                  title: Text('${_actions[index][0]['service']}'),
                  children: <Widget>[
                    actionList(_actions[index]),
                  ],
                );
              },
            ),
          )
        ],
      )),
    );
  }

  Widget backbutt(context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      child: const Text('Retour au menu'),
    );
  }

  Widget actionList(list_actions) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list_actions.length,
        itemBuilder: (BuildContext context, int index) {
          heroTag:
          'action$index';
          return ListTile(
            title: Text(list_actions[index]['name']),
            subtitle: Text(list_actions[index]['description'], style: const TextStyle(fontSize: 10.0)),
            key: Key(list_actions[index]['name']),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              getActionsData(list_actions[index]['endpoint']).then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DynamicFormScreen(action: value,context: context)),
                );
              });
            },
          );
        });
  }
}
