import 'dart:async';
import 'package:medical_center/features/persons/presentaion/state_management/cubits/get_person_cubit.dart';
import 'package:medical_center/features/persons/presentaion/state_management/states/get_person_state.dart';
import 'package:medical_center/features/persons/presentaion/ui/widgets/person_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonLookupScreen extends StatefulWidget {
  const PersonLookupScreen({super.key});

  @override
  State<PersonLookupScreen> createState() => _PersonLookupScreenState();
}

class _PersonLookupScreenState extends State<PersonLookupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _search() {
    if (_formKey.currentState?.validate() != true) return;
    unawaited(context.read<GetPersonCubit>().findPersonById(int.parse(_idController.text.trim())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البحث عن شخص'), centerTitle: true),
      body: BlocBuilder<GetPersonCubit, GetPersonState>(
        builder: (context, state) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('أدخل معرّف الشخص لإرسال طلب getPersonById.', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  labelText: 'معرّف الشخص',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (value) {
                  final id = int.tryParse(value?.trim() ?? '');
                  if (id == null || id <= 0) {
                    return 'أدخل معرّفاً صحيحاً أكبر من صفر';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _search(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: state.isLoading ? null : _search,
              icon: state.isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(state.isLoading ? 'جارٍ البحث...' : 'ابحث'),
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 20),
              _MessageCard(
                message: state.errorMessage!,
                icon: Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
            ],
            if (state.person case final person?) ...[
              const SizedBox(height: 20),
              PersonCard(person: person),
            ],
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message, required this.icon, required this.color});

  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(message, style: TextStyle(color: color)),
      ),
    );
  }
}
