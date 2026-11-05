import 'package:medical_center/core/routing/routes.dart';
import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/domain/enums/gender.dart';
import 'package:medical_center/features/persons/presentaion/state_management/cubits/get_person_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({required this.person, super.key});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final fullName =
        '${person.firstName} ${person.middleName} ${person.lastName}';
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(fullName, style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    await context.push(AppRoutes.updatePerson, extra: person);
                    if (context.mounted) {
                      await context
                          .read<GetPersonCubit>()
                          .findPersonById(person.personID); 
                    }
                  },
                  icon: const Icon(Icons.edit_note_rounded),
                ),
              ],
            ),
            const Divider(height: 24),
            _DetailRow(label: 'المعرّف', value: '${person.personID}'),
            _DetailRow(label: 'الرقم الوطني', value: person.nationalID),
            _DetailRow(label: 'رقم الهاتف', value: person.phoneNumber),
            _DetailRow(
              label: 'تاريخ الميلاد',
              value: person.dateOfBirth.toLocal().toString().split(' ').first,
            ),
            _DetailRow(label: 'الجنس', value: person.gender.name),

            if (person.address != null)
              _DetailRow(label: 'العنوان', value: person.address!),
            if (person.jobTitle != null)
              _DetailRow(label: 'المسمى الوظيفي', value: person.jobTitle!),
            if (person.emergencyContact != null)
              _DetailRow(
                label: 'جهة اتصال للطوارئ',
                value: person.emergencyContact!,
              ),
            const SizedBox(height: 8),
            Text(
              'تم العثور على الشخص بنجاح',
              style: TextStyle(color: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
