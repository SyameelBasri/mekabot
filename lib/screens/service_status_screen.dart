import 'package:flutter/material.dart';
import 'package:chatbot_app/model/Service.dart';


class ServiceStatusScreen extends StatelessWidget {
  const ServiceStatusScreen({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: service.serviceType == "Workshop" ? buildWorkshopPage(service, context) : buildServicePage(service, context)
    );
  }
}

Widget buildWorkshopPage(Service service, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            Text(
              "Workshop has been notified...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Image.asset(
              'assets/workshop.gif', // Replace with the actual image path
              height: 200,
            ),
            SizedBox(height: 8),
            const Text(
              "Bring your car to workshop to solve your issue",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: Colors.lightBlue[50],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Centers children vertically
                        mainAxisAlignment: MainAxisAlignment.center, // Centers children horizontally within the Row
                        children: [
                          SizedBox(
                            width: 80, // Reduced width
                            height: 80, // Reduced height
                            child: Center(
                              child: Image.network(
                                service.iconUrl,
                                width: 80, // Reduced image width
                                height: 80, // Reduced image height
                                fit: BoxFit.contain, // Ensures the image fits within the SizedBox
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: Colors.red);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 20), // Reduced spacing
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
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Divider(color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      child: Text(service.description, maxLines: 4,),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: Colors.lightBlue[50],
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.account_circle, color: Colors.cyan, size: 36,),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Call Workshop",
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
                    icon: Icon(Icons.phone, color: Colors.cyan, size: 28,),
                    onPressed: () {
                      // Add call functionality here
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: Colors.lightBlue[50],
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.location_pin, color: Colors.red, size: 36),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      SizedBox(height: 15),
                    ],
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      // Add edit functionality here
                    },
                    child: Text("GO", style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: Colors.lightBlue[50],
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.car_crash_rounded, color: Colors.cyan, size: 36),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vehicle details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Plate Number: WB 3064 E"),
                      Text("Car Model: Honda City 2019"),
                      SizedBox(height: 16),
                    ],
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      // Add edit functionality here
                    },
                    child: Icon(Icons.edit, color: Colors.cyan, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildServicePage(Service service, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Column(
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
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: Colors.lightBlue[50],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Centers children vertically
                        mainAxisAlignment: MainAxisAlignment.center, // Centers children horizontally within the Row
                        children: [
                          SizedBox(
                            width: 80, // Reduced width
                            height: 80, // Reduced height
                            child: Center(
                              child: Image.network(
                                service.iconUrl,
                                width: 80, // Reduced image width
                                height: 80, // Reduced image height
                                fit: BoxFit.contain, // Ensures the image fits within the SizedBox
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: Colors.red);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 20), // Reduced spacing
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
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Divider(color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      child: Text(service.description, maxLines: 4,),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: Colors.lightBlue[50],
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.account_circle, color: Colors.cyan, size: 36,),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    icon: Icon(Icons.phone, color: Colors.cyan, size: 36,),
                    onPressed: () {
                      // Add call functionality here
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: Colors.lightBlue[50],
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.location_pin, color: Colors.red, size: 36),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      SizedBox(height: 16),

                    ],
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      // Add edit functionality here
                    },
                    child: Icon(Icons.edit, color: Colors.cyan, size: 24),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: Colors.lightBlue[50],
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: Icon(Icons.car_crash_rounded, color: Colors.cyan, size: 36),
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vehicle details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Plate Number: WB 3064 E"),
                      Text("Car Model: Honda City 2019"),
                      SizedBox(height: 16),

                    ],
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      // Add edit functionality here
                    },
                    child: Icon(Icons.edit, color: Colors.cyan, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
