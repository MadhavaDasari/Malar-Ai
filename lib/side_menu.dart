import 'package:flutter/material.dart';
import 'package:Malar_Ai/screens/saved_results_list.dart';
import 'screens/instructions.dart';
import 'screens/about.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.purple,
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('assets/ml.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.collections, color: Colors.purple),
            title: Text('Saved Results ',
                style: TextStyle(
                  fontSize: 20,
                )),
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return Saved();
              }));
            },
          ),
          ListTile(
              leading: Icon(Icons.help_outline, color: Colors.purple),
              title: Text('How To Use ?',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return Instructions();
                }));
              }),
          ListTile(
              leading: Icon(Icons.info_outline, color: Colors.purple),
              title: Text('About',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return About();
                }));
              }),
          ListTile(
            leading: Icon(Icons.share, color: Colors.purple),
            title: Text('Share',
                style: TextStyle(
                  fontSize: 20,
                )),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.purple),
            title: Text('Rate us ',
                style: TextStyle(
                  fontSize: 20,
                )),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.purple),
            title: Text('Exit',
                style: TextStyle(
                  fontSize: 20,
                )),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
