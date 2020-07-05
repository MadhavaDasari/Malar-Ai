import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About..."),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(top: 8, left: 8, right: 8),
            elevation: 40,
            shadowColor: Colors.purple,
            child: ListTile(
              title: Text(
                "About the Model :",
                style: TextStyle(fontSize: 20, color: Colors.purple),
              ),
            ),
          ),
          Card(
            elevation: 5,
            shadowColor: Colors.purple,
            child: ListTile(
                title: Text(
                    "The Model is used to detect probable malaria infection using blood smear slides. Powered by ResNet-50, cell-phone microscope and a staining kit, this setup is capable of performing at  an accuracy of >95%, hence highly useful in remote and inaccessible areas.")),
          ),
          Card(
            margin: EdgeInsets.only(top: 8, left: 8, right: 8),
            elevation: 40,
            shadowColor: Colors.purple,
            child: ListTile(
              title: Text(
                "Our Aim :",
                style: TextStyle(fontSize: 20, color: Colors.purple),
              ),
            ),
          ),
          Card(
            elevation: 5,
            shadowColor: Colors.purple,
            child: ListTile(
              title: Text(
                " We aim to enhance the ease of Malaria testing in areas where the availability of testing equipments is not adequate. This mobile is useful for the health care worker can capture the photo of a blood smear slide of a person, and predict the possibility of Malaria.",
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: 8, left: 8, right: 8),
            elevation: 40,
            shadowColor: Colors.purple,
            child: ListTile(
              title: Text(
                "Contact Us  :",
                style: TextStyle(fontSize: 20, color: Colors.purple),
              ),
            ),
          ),
          Card(
            elevation: 5,
            shadowColor: Colors.purple,
            child: ListTile(
              title: Text(
                "This project is maintained by the students Club of Sustainability & Innovation, Indian Institute of Technology(IIT-BHU), Varanasi. For any queries/potential collaborations/opportunites, mail at csi.iitbhu@gmail.com",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
