import 'package:IITDAPP/modules/login/user_class.dart';
import 'package:IITDAPP/values/Constants.dart';

import 'package:IITDAPP/ThemeModel.dart';
import 'package:provider/provider.dart';
import 'package:IITDAPP/widgets/error_alert.dart';
import 'package:IITDAPP/widgets/loading.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pedantic/pedantic.dart';

class AdminCard extends StatelessWidget {
  final Admin admin;

  const AdminCard(this.admin, Key key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0x22AAAAAA),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  admin.name,
                  style: TextStyle(
                      fontSize: 20,
                      color: Provider.of<ThemeModel>(context)
                          .theme
                          .PRIMARY_TEXT_COLOR),
                  maxLines: 1,
                ),
                AutoSizeText(
                  admin.email,
                  style: TextStyle(
                      color: Provider.of<ThemeModel>(context)
                          .theme
                          .PRIMARY_TEXT_COLOR),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          ResponseIcons(admin),
        ],
      ),
    );
  }
}

class ResponseIcons extends StatefulWidget {
  final Admin admin;

  const ResponseIcons(this.admin);

  @override
  State<StatefulWidget> createState() {
    return ResponseIconsState();
  }
}

class ResponseIconsState extends State<ResponseIcons> {
  String state;
  Admin admin;

  @override
  void initState() {
    super.initState();
    admin = widget.admin;
    state = 'pending';
  }

  Future<void> deleteAdmin() async {
    final response = await http.post('$uri/api/users/removeAdmin', headers: {
      'authorization': 'Bearer $token'
    }, body: {
      'clubId': currentUser.superAdminOf[0].id,
      'userEmail': admin.email,
    });
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        state = 'deleted';
      });
    } else {
      Navigator.pop(context);
      await showErrorAlert(
          context, 'Failed', 'Some error occcured. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return (state == 'pending')
        ? PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                color: Provider.of<ThemeModel>(context)
                    .theme
                    .PRIMARY_TEXT_COLOR
                    .withOpacity(0.7)),
            onSelected: (a) => _showAlert(context),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '',
                child: Text('Remove admin'),
              )
            ],
          )
        : Center(
            child: Text(
              'removed',
              style: TextStyle(
                color: Provider.of<ThemeModel>(context)
                    .theme
                    .PRIMARY_TEXT_COLOR
                    .withOpacity(0.7),
              ),
            ),
          );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Provider.of<ThemeModel>(context).theme.ALERT_DIALOG,
          title: Text(
            'Remove Admin',
            style: TextStyle(
                color:
                    Provider.of<ThemeModel>(context).theme.ALERT_DIALOG_TEXT),
          ),
          content: Text(
            'Are you sure you want to remove this admin?',
            style: TextStyle(
                color:
                    Provider.of<ThemeModel>(context).theme.ALERT_DIALOG_TEXT),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                    color: Provider.of<ThemeModel>(context)
                        .theme
                        .ALERT_DIALOG_TEXT
                        .withOpacity(0.7)),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                unawaited(showLoading(context));
                await deleteAdmin();
              },
              child: Text(
                'YES',
                style: TextStyle(
                    color: Provider.of<ThemeModel>(context)
                        .theme
                        .ALERT_DIALOG_TEXT
                        .withOpacity(0.7)),
              ),
            )
          ],
        );
      },
    );
  }
}
