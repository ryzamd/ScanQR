import 'package:flutter/material.dart';

InputDecoration buildInputDecoration({
  required BuildContext context,
  required String labelText,
  required Icon prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  );
}

Widget buildPersonalInfoStep({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController phoneController,
  required String? selectedGender,
  required void Function(String?) onGenderChanged,
}) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin cá nhân',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Họ và tên',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Số điện thoại',
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    if (!RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$').hasMatch(value)) {
                      return 'Số điện thoại không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: buildInputDecoration(
                    context: context,
                    labelText: 'Giới tính',
                    prefixIcon: const Icon(Icons.people),
                  ),
                  value: selectedGender,
                  hint: const Text('Chọn giới tính'),
                  items: const [
                    DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                    DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                    DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                  ],
                  onChanged: onGenderChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn giới tính';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildAccountInfoStep({
  required BuildContext context,
  required TextEditingController usernameController,
  required TextEditingController passwordController,
  required TextEditingController confirmPasswordController,
  required bool obscurePassword,
  required bool obscureConfirmPassword,
  required VoidCallback toggleObscurePassword,
  required VoidCallback toggleObscureConfirmPassword,
  required TextEditingController imageController,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin tài khoản',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 8),

              TextFormField(
                controller: usernameController,
                autofocus: false,
                decoration: buildInputDecoration(
                  context: context,
                  labelText: 'Tên đăng nhập',
                  prefixIcon: const Icon(Icons.account_circle),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  if (value.length < 4) {
                    return 'Tên đăng nhập phải có ít nhất 4 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                autofocus: false,
                decoration: buildInputDecoration(
                  context: context,
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: toggleObscurePassword,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: buildInputDecoration(
                  context: context,
                  labelText: 'Nhập lại mật khẩu',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: toggleObscureConfirmPassword,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập lại mật khẩu';
                  }
                  if (value != passwordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Image
              TextFormField(
                controller: imageController,
                decoration: buildInputDecoration(
                  context: context,
                  labelText: 'Đường dẫn ảnh đại diện',
                  prefixIcon: const Icon(Icons.image),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đường dẫn ảnh';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildJobInfoStep({
  required BuildContext context,
  required String? selectedDepartment,
  required List<String> departments,
  required void Function(String?) onDepartmentChanged,
  required String? selectedPosition,
  required List<String> positions,
  required void Function(String?) onPositionChanged,
  required String name,
  required String phoneNumber,
  required String? gender,
  required String username,
  required String image,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Thông tin công việc',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                decoration: buildInputDecoration(
                  context: context,
                  labelText: 'Phòng ban',
                  prefixIcon: const Icon(Icons.business),
                ),
                value: selectedDepartment,
                items: departments
                    .map(
                      (dep) => DropdownMenuItem(value: dep, child: Text(dep)),
                    )
                    .toList(),
                onChanged: onDepartmentChanged,
                hint: const Text('Chọn phòng ban'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn phòng ban';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: buildInputDecoration(
                  context: context,
                  labelText: 'Chức vụ',
                  prefixIcon: const Icon(Icons.work),
                ),
                value: selectedPosition,
                items: positions
                    .map(
                      (pos) => DropdownMenuItem(value: pos, child: Text(pos)),
                    )
                    .toList(),
                onChanged: onPositionChanged,
                hint: const Text('Chọn chức vụ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn chức vụ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              const Text(
                'Xem lại thông tin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoItem('Họ và tên', name),
                    _buildInfoItem('Số điện thoại', phoneNumber),
                    _buildInfoItem('Giới tính', gender ?? ''),
                    _buildInfoItem('Tên đăng nhập', username),
                    _buildInfoItem('Ảnh đại diện', image),
                    _buildInfoItem('Phòng ban', selectedDepartment ?? ''),
                    _buildInfoItem('Chức vụ', selectedPosition ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildInfoItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isEmpty ? 'Chưa cung cấp' : value,
            style: TextStyle(
              fontSize: 14,
              color: value.isEmpty ? Colors.grey : Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}