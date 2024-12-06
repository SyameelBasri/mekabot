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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
          Container(
            width: 400, // Reduced width for the container
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Centers children vertically
                    mainAxisAlignment: MainAxisAlignment.center, // Centers children horizontally within the Row
                    children: [
                      SizedBox(
                        width: 40, // Reduced width
                        height: 40, // Reduced height
                        child: Center(
                          child: Image.network(
                            service.iconUrl,
                            width: 30, // Reduced image width
                            height: 30, // Reduced image height
                            fit: BoxFit.contain, // Ensures the image fits within the SizedBox
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), // Reduced spacing
                      // Removed Expanded to allow content to take minimal space
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Centers texts horizontally
                        mainAxisAlignment: MainAxisAlignment.center, // Centers texts vertically within the Row
                        children: [
                          const Text(
                            "Ordered service",
                            textAlign: TextAlign.center, // Centers text within its container
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF393939),
                            ),
                          ),
                          const SizedBox(height: 4), // Spacing between title and subtitle
                          Text(
                            service.serviceType,
                            textAlign: TextAlign.center, // Centers text within its container
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF393939),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(service.description),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          Container(
            width: 400,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.account_circle, color: Colors.teal[300], size: 40,),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Contact your technician",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: Abu Aiman Bin Ahmad Ali",
                    ),
                    SizedBox(height: 15),
                  ],
                ),
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
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.location_pin, color: Colors.red),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Location details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Persiaran Bangsar 10, Taman Desa,"),
                    Text("50672 Kuala Lumpur, W.P Kuala Lumpur"),
                    SizedBox(height: 4),
                    Text("Plate Number: WB 3064 E"),
                    Text("Car Model: Honda City 2019"),
                    SizedBox(height: 15),

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
