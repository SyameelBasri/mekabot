import 'package:flutter/material.dart';
import 'package:chatbot_app/model/Service.dart';


class ServiceStatusScreen extends StatelessWidget {
  const ServiceStatusScreen({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        title: const Text(
          'MekaBot',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Text(
            "${service.serviceType} is on the way..",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Image.asset(
            'assets/technician.gif', // Replace with the actual image path
            height: 200,
          ),
          SizedBox(height: 8),
          const Text(
            "Estimated time arrival",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 4),
          const Text(
            "15-20 minutes",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: Image.network(service.iconUrl),
                    title: Text("Ordered service"),
                    subtitle: Text(service.serviceType),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                        color: Colors.grey
                    ),
                  ),
                  Text(service.description)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.account_circle, color: Colors.teal[300], size: 40,),
                title: Text("Contact your technician"),
                subtitle: Text("Name: Abu Aiman Bin Ahmad Ali"),
                trailing: IconButton(
                  icon: Icon(Icons.phone, color: Colors.teal[300], size: 30,),
                  onPressed: () {
                    // Add call functionality here
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.location_pin, color: Colors.red),
                title: Text("Location details"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Persiaran Bangsar 10, Taman Desa,"),
                    Text("50672 Kuala Lumpur, W.P Kuala Lumpur"),
                    SizedBox(height: 4),
                    Text("Plate Number: WB 3064 E"),
                    Text("Car Model: Honda City 2019"),
                  ],
                ),
                trailing: TextButton(
                  onPressed: () {
                    // Add edit functionality here
                  },
                  child: Text("Edit", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
