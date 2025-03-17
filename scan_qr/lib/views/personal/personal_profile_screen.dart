import 'package:flutter/material.dart';
import 'package:scan_qr/utilites/contants/style_contants.dart';

class PersonalProfileScreen extends StatelessWidget {
  const PersonalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = {
      'id': 'UWH09999999',
      'fullName': 'USER TEST',
      'dateOfBirth': '01/01/0001',
      'age': '25',
      'department': 'Engineering',
      'position': 'Senior Developer',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            color: ColorsConstants.primaryColor,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'PROFILE',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          Transform(
            transform: Matrix4.translationValues(0, -20, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['fullName']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData['id']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.home_repair_service,
                                size: 18,
                                color: Colors.pink[300],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Department: ${userData['department']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.pink[300],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.workspace_premium,
                                size: 18,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Position: ${userData['position']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('User Information'),
                  _buildInfoCard([
                    _buildInfoField('Full Name', userData['fullName']!),
                    _buildInfoField('DOB', userData['dateOfBirth']!),
                  ]),

                  const SizedBox(height: 10),

                  _buildSectionTitle('Thông tin giấy tờ'),
                  _buildInfoCard([
                    _buildInfoField(
                      'Số CMND/CCCD/Hộ chiếu',
                      userData['fullName']!,
                    ),
                    _buildInfoField('Ngày cấp', userData['fullName']!),
                    _buildInfoField('Nơi cấp', userData['fullName']!),
                  ]),

                  const SizedBox(height: 10),

                  _buildSectionTitle('Thông tin giấy tờ'),
                  _buildInfoCard([
                    _buildInfoField(
                      'Số CMND/CCCD/Hộ chiếu',
                      userData['fullName']!,
                    ),
                    _buildInfoField('Ngày cấp', userData['fullName']!),
                    _buildInfoField('Nơi cấp', userData['fullName']!),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          if (index < children.length - 1) {
            return Column(
              children: [
                children[index],
                const SizedBox(height: 12),
              ],
            );
          }
          return children[index];
        }),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: 4,
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
