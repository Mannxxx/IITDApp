import 'package:IITDAPP/modules/explore/widgets/AboutScreen.dart';
import 'package:flutter/material.dart';



// ignore: must_be_immutable
class ClubListCard extends StatefulWidget {
  ClubListCard({Key key, this.data})
      : super(key: key);
  var data;
  @override
  _ClubListCardState createState() => _ClubListCardState();
}

class _ClubListCardState extends State<ClubListCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: ClipOval(
          child: Image.asset('assets/images/devCLogo.png'),
        ),
        title: Text(widget.data['name'],style: TextStyle(fontSize: 20)),
        subtitle: Text(widget.data['motto'],style: TextStyle(fontSize: 16)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutScreen(name: widget.data['name'],)),
          );
        },
      ),
    );
  }
}


