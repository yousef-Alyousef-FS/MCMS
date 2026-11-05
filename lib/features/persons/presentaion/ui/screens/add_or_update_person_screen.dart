import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/domain/enums/gender.dart';
import 'package:medical_center/features/persons/presentaion/state_management/cubits/add_update_cubit.dart';
import 'package:medical_center/features/persons/presentaion/state_management/states/add_update_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddOrUpdatePersonScreen extends StatefulWidget {
  const AddOrUpdatePersonScreen({super.key, this.person});
  final Person? person;
  bool get isEditMode => person != null;

  @override
  State<AddOrUpdatePersonScreen> createState() => _AddOrUpdatePersonScreenState();
}

class _AddOrUpdatePersonScreenState extends State<AddOrUpdatePersonScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nationalIdController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _emergencyContactController;
  late final TextEditingController _addressController;
  late final TextEditingController _jobController;

  DateTime? _selectedDate;
  Gender _selectedGender = Gender.male;

  @override
  void initState() {
    super.initState();

    if (widget.person != null) {
      _nationalIdController = TextEditingController(text: widget.person!.nationalID);
      _firstNameController = TextEditingController(text: widget.person!.firstName);
      _middleNameController = TextEditingController(text: widget.person!.middleName);
      _lastNameController = TextEditingController(text: widget.person!.lastName);
      _phoneNumberController = TextEditingController(text: widget.person!.phoneNumber);
      _birthDateController = TextEditingController(text: widget.person!.dateOfBirth.toIso8601String());
      _emergencyContactController = TextEditingController(text: widget.person!.emergencyContact ?? '',);
      _addressController = TextEditingController(text: widget.person!.address ?? '');
      _jobController = TextEditingController(text: widget.person!.jobTitle ?? '');
    } else {
      _nationalIdController = TextEditingController();
      _firstNameController = TextEditingController();
      _middleNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _phoneNumberController = TextEditingController();
      _birthDateController = TextEditingController();
      _emergencyContactController = TextEditingController();
      _addressController = TextEditingController();
      _jobController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _birthDateController.dispose();

    _emergencyContactController.dispose();
    _addressController.dispose();
    _jobController.dispose();

    super.dispose();
  }

  void _clear() {
    _nationalIdController.clear();
    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
    _phoneNumberController.clear();
    _birthDateController.clear();
    _emergencyContactController.clear();
    _addressController.clear();
    _jobController.clear();
    _selectedDate = null;
  }

  void _resetForm() {
    if (widget.isEditMode) {
      _restoreOriginalValues();
    } else {
      _clear();
    }
  }

  void _restoreOriginalValues() {
    _selectedDate = widget.person!.dateOfBirth;
    _selectedGender = widget.person!.gender;
    _nationalIdController.text = widget.person!.nationalID;
    _firstNameController.text = widget.person!.firstName;
    _middleNameController.text = widget.person!.middleName;
    _lastNameController.text = widget.person!.lastName;
    _phoneNumberController.text = widget.person!.phoneNumber;
    _birthDateController.text = DateFormat('yyyy-MM-dd').format(widget.person!.dateOfBirth);
    _emergencyContactController.text = widget.person!.emergencyContact ?? '';
    _addressController.text = widget.person!.address ?? '';
    _jobController.text = widget.person!.jobTitle ?? '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> submit() async {
    if (_formKey.currentState?.validate() != true) return;
    final dateOfBirth = _selectedDate;
    if (dateOfBirth == null) return;

    await context.read<AddUpdateCubit>().addPerson(
      Person(
        personID: 0,
        nationalID: _nationalIdController.text.trim(),
        firstName: _firstNameController.text.trim(),
        middleName: _middleNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: dateOfBirth,
        gender: _selectedGender,
        phoneNumber: _phoneNumberController.text.trim(),
        emergencyContact: _optionalValue(_emergencyContactController.text),
        address: _optionalValue(_addressController.text),
        jobTitle: _optionalValue(_jobController.text),
      ),
    );
  }

  String? _optionalValue(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _appBarTitle() {
    return widget.isEditMode ? 'Edit Person Info' : 'Add New Person';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle()), centerTitle: true),
      body: BlocConsumer<AddUpdateCubit, AddUpdateState>(
        listener: (context, state) {
          switch (state.status) {
            case AddUpdateStatus.failure:
              final message = state.errorMessage;
              if (message != null) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(message)));
              }
            case AddUpdateStatus.success:
              final person = state.person;
              if (person != null) {
                final message =
                    state.successMessage ?? 'Added successfully with id : ${person.personID}';
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(message)));
              }
            case AddUpdateStatus.initial:
            case AddUpdateStatus.submitting:
              break;
          }
        },
        builder: (context, state) {
          final isSubmitting = state.status == AddUpdateStatus.submitting;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (widget.isEditMode) Text('Person Id : ${widget.person?.personID}'),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nationalIdController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'National ID',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'National ID cannot be empty';
                            }
                            if (!RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value)) {
                              return 'Invalid National ID';
                            }
                            if (value.length < 10) {
                              return "National ID can't be less than 10 numbers";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'First Name',
                          ),
                          keyboardType: TextInputType.name,
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.length < 2) {
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _middleNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Middle Name',
                          ),
                          keyboardType: TextInputType.name,
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.length < 2) {
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Last Name',
                          ),
                          keyboardType: TextInputType.name,
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.length < 2) {
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 15,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone Number cannot be empty';
                            }
                            if (!RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value)) {
                              return 'Invalid Phone Number';
                            }
                            if (value.length < 10) {
                              return "Phone Number can't be less than 10 numbers";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        // Date of Birth Picker Field
                        TextFormField(
                          controller: _birthDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date of Birth',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select date of birth';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Gender Selection (Radio Buttons)
                        const Text(
                          'Gender',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        RadioGroup<Gender>(
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                          child: const Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  value: Gender.male,
                                  title: Text(
                                    'Male',
                                    style: TextStyle(color: Colors.lightBlueAccent),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  value: Gender.female,
                                  title: Text('Femal', style: TextStyle(color: Colors.pinkAccent)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _emergencyContactController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Emergency Phone Number',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 15,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty && value.length < 10) {
                              if (!RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value)) {
                                return 'Invalid Phone Number';
                              }
                              return "Phone Number can't be less than 10 numbers";
                            }
                            return null;
                          },
                        ),

TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Address',
                          ),
                          maxLength: 250,
                          maxLines: 4,
                        ),
                        TextFormField(
                          controller: _jobController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Job',
                            hintText: 'Type your current job',
                          ),
                          maxLength: 50,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isSubmitting ? null : submit,
                                child: isSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Text('Submit'),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isSubmitting
                                    ? null
                                    : () {
                                        context.read<AddUpdateCubit>().resetState();
                                        setState(() {
                                          _formKey.currentState!.reset();
                                          _resetForm();
                                        });
                                      },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                                child: const Icon(Icons.restart_alt),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
