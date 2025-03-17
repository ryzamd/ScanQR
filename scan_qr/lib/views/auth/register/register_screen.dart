import 'package:flutter/material.dart';
import 'package:scan_qr/templates/general_scaffords/general_scafford_screen.dart';
import 'package:scan_qr/templates/dialogs/custom_dialogs.dart';
import 'package:scan_qr/utilites/contants/style_contants.dart';
import 'register_business.dart';
import 'register_component_widgets.dart' as comp;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  String? _selectedGender;
  String? _selectedDepartment;
  String? _selectedPosition;

  final List<String> _departments = [
    'IT',
    'HR',
    'Finance',
    'Marketing',
    'Operations',
  ];
  final List<String> _positions = [
    'Manager',
    'Team Lead',
    'Senior Staff',
    'Junior Staff',
    'Intern',
  ];

  int _currentStep = 0;
  final List<String> _stepTitles = ['Personal', 'Account', 'Work'];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _validateForm() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
    
    bool isValid = false;
    
    switch (_currentStep) {
      case 0:
        isValid = RegisterBusiness.isStepComplete0(
          name: _nameController.text,
          phoneNumber: _phoneNumberController.text,
          gender: _selectedGender,
        );
        break;
      case 1:
        isValid = RegisterBusiness.isStepComplete1(
          username: _usernameController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          image: _imageController.text,
        );
        break;
      case 2:
        isValid = RegisterBusiness.isStepComplete2(
          department: _selectedDepartment,
          position: _selectedPosition,
        );
        break;
    }
    
    setState(() {
      _isFormValid = isValid;
    });
  }

  void _submitForm() {
    if (!RegisterBusiness.checkFormValid(
      formKey: _formKey,
      department: _selectedDepartment,
      position: _selectedPosition,
      gender: _selectedGender,
    )) {
      CustomDialog.warning(context: context,
      title: 'WARNING',
      message: 'Please fill correct data',
      isHasCancelButton: false,
      );
      return;
    }

    RegisterBusiness.submitForm(
      context: context,
      isFormValid: _isFormValid,
      name: _nameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      image: _imageController.text,
      department: _selectedDepartment,
      position: _selectedPosition,
      phoneNumber: _phoneNumberController.text,
      gender: _selectedGender,
      onSuccess: () {
        CustomDialog.notice(
          context: context,
          title: 'NOTICE',
          message: 'Register Successfully',
          isHasCancelButton: false,
          onConfirm: () => Navigator.pop(context),
        );
      },
    );
  }

  bool _isStepComplete(int step) {
    switch (step) {
      case 0:
        return RegisterBusiness.isStepComplete0(
          name: _nameController.text,
          phoneNumber: _phoneNumberController.text,
          gender: _selectedGender,
        );
      case 1:
        return RegisterBusiness.isStepComplete1(
          username: _usernameController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          image: _imageController.text,
        );
      case 2:
        return RegisterBusiness.isStepComplete2(
          department: _selectedDepartment,
          position: _selectedPosition,
        );
      default:
        return false;
    }
  }

  void _goToNextStep() {
    if (_isStepComplete(_currentStep)) {
      setState(() {
        _currentStep++;
      });

       _formKey.currentState?.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields'),
          backgroundColor: Colors.red,
        ),
      );
       _formKey.currentState?.validate();
    }
  }

  void _goToPreviousStep() {
    setState(() {
      _currentStep--;
    });

    _formKey.currentState?.reset();
  }

  Widget _buildStepIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: List.generate(
          _stepTitles.length,
          (index) => Expanded(
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _currentStep >= index
                        ? ColorsConstants.primaryColor
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _currentStep > index
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: _currentStep >= index
                                  ? Colors.white
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _stepTitles[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: _currentStep >= index
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
                    fontWeight: _currentStep == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 2,
                  margin: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                  ),
                  color: _currentStep > index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: _buildCurrentStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return comp.buildPersonalInfoStep(
          context: context,
          nameController: _nameController,
          phoneController: _phoneNumberController,
          selectedGender: _selectedGender,
          onGenderChanged: (val) {
            setState(() {
              _selectedGender = val;
            });
            _validateForm();
          },
        );
      case 1:
        return comp.buildAccountInfoStep(
          context: context,
          usernameController: _usernameController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          toggleObscurePassword: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          toggleObscureConfirmPassword: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
          imageController: _imageController,
        );
      case 2:
        return comp.buildJobInfoStep(
          context: context,
          selectedDepartment: _selectedDepartment,
          departments: _departments,
          onDepartmentChanged: (val) {
            setState(() => _selectedDepartment = val);
            _validateForm();
          },
          selectedPosition: _selectedPosition,
          positions: _positions,
          onPositionChanged: (val) {
            setState(() => _selectedPosition = val);
            _validateForm();
          },
          name: _nameController.text,
          phoneNumber: _phoneNumberController.text,
          gender: _selectedGender,
          username: _usernameController.text,
          image: _imageController.text,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomButtons() {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            ElevatedButton.icon(
              onPressed: _goToPreviousStep,
              label: const Text(
                'BACK',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          _currentStep < _stepTitles.length - 1
              ? ElevatedButton.icon(
                  onPressed: _isStepComplete(_currentStep)
                      ? _goToNextStep
                      : _validateForm,
                  label: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    backgroundColor: ColorsConstants.primaryColor,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: _isFormValid ? _submitForm : null,
                  label: const Text(
                    'REGISTER',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    backgroundColor: ColorsConstants.primaryColor,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScreenScaffold(
      title: Text("REGISTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      isSubScreen: false,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: _buildFormContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons()
    );
  }
}