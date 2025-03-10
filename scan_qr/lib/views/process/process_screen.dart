import 'package:flutter/material.dart';

class ProcessingScreen extends StatelessWidget {
  const ProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'PROCESSING',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Table header
          Container(
            color: Colors.grey[700],
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: Text('SN', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  VerticalDivider(color: Colors.white, thickness: 1, width: 1),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Supplier',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Time', style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Date', style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Status',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Total', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),

          // Table rows
          Expanded(
            child: Container(
              color: Colors.grey[800],
              child: ListView(
                children: [
                  _buildTableRow(
                    "1",
                    "PRIMO",
                    "17:11:00 PM",
                    "02/28/25",
                    "Success",
                    "50",
                    Colors.grey[600]!,
                  ),
                  _buildTableRow(
                    "1",
                    "PRIMO",
                    "17:11:00 PM",
                    "02/28/25",
                    "Failed",
                    "50",
                    Colors.grey[700]!,
                  ),
                  _buildTableRow(
                    "1",
                    "PRIMO",
                    "17:11:00 PM",
                    "02/28/25",
                    "Pendding",
                    "50",
                    Colors.grey[600]!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(
    String sn,
    String supplier,
    String time,
    String date,
    String status,
    String total,
    Color bgColor,
  ) {
    Color statusColor;
    if (status == "Success") {
      statusColor = Colors.green;
    } else if (status == "Failed") {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Center(
              child: Text(sn, style: const TextStyle(color: Colors.white)),
            ),
          ),
          const VerticalDivider(color: Colors.white, thickness: 1, width: 1),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(supplier, style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: 2,
            child: Text(time, style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: 2,
            child: Text(date, style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: 2,
            child: Text(status, style: TextStyle(color: statusColor)),
          ),
          Expanded(
            flex: 1,
            child: Text(total, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
