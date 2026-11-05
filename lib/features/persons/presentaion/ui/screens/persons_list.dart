import 'package:medical_center/core/routing/routes.dart';
import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/presentaion/state_management/cubits/get_person_cubit.dart';
import 'package:medical_center/features/persons/presentaion/state_management/states/get_person_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PersonsListScreen extends StatelessWidget {
  const PersonsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: const Text('الأشخاص'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'البحث عن شخص بالمعرّف',
            onPressed: () => context.push(AppRoutes.personLookup),
            icon: const Icon(Icons.person_search),
          ),
          IconButton(
            tooltip: 'إعادة تحميل',
            onPressed: () => context.read<GetPersonCubit>().loadPersons(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<GetPersonCubit, GetPersonState>(
        builder: (context, state) {
          if (state.isLoading && state.persons.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.persons.isEmpty) {
            return _ErrorView(
              message: state.errorMessage!,
              onRetry: () => context.read<GetPersonCubit>().loadPersons(),
            );
          }

          if (state.persons.isEmpty) {
            return const Center(child: Text('ما في أشخاص نعرضهم'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<GetPersonCubit>().loadPersons(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.persons.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _PersonListTile(person: state.persons[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _PersonListTile extends StatelessWidget {
  const _PersonListTile({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final fullName = '${person.firstName} ${person.middleName} ${person.lastName}';

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(child: Text(person.firstName.isEmpty ? '?' : person.firstName[0])),
        title: Text(fullName, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${person.phoneNumber}\nالرقم الوطني: ${person.nationalID}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
