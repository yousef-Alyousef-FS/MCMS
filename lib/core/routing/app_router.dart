import 'dart:async';

import 'package:medical_center/core/di/injection.dart';
import 'package:medical_center/core/routing/routes.dart';
import 'package:medical_center/features/home/presentation/ui/screens/home.dart';
import 'package:medical_center/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:medical_center/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/presentaion/state_management/cubits/add_update_cubit.dart';
import 'package:medical_center/features/persons/presentaion/state_management/cubits/get_person_cubit.dart';
import 'package:medical_center/features/persons/presentaion/ui/screens/add_or_update_person_screen.dart';
import 'package:medical_center/features/persons/presentaion/ui/screens/person_lookup_screen.dart';
import 'package:medical_center/features/persons/presentaion/ui/screens/persons_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: AppRoutes.initial,
    routes: [
      GoRoute(path: AppRoutes.initial, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.home, builder: (context, state) => const HomePage()),
      GoRoute(
        path: AppRoutes.persons,
        builder: (context, state) => BlocProvider(
          create: (_) {
            final cubit = getIt<GetPersonCubit>();
            unawaited(cubit.loadPersons());
            return cubit;
          },
          child: const PersonsListScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.personLookup,
        builder: (context, state) =>
            BlocProvider(create: (_) => getIt<GetPersonCubit>(), child: const PersonLookupScreen()),
      ),
      GoRoute(
        path: AppRoutes.addPerson,
        builder: (context, state) =>
            BlocProvider(create: (_) => getIt<AddUpdateCubit>(), child: const AddOrUpdatePersonScreen()),
      ),
      GoRoute(
        path: AppRoutes.updatePerson,
        builder: (context, state) {

         final person = state.extra as Person?;
         return BlocProvider(create: (_) => getIt<AddUpdateCubit>(), child: AddOrUpdatePersonScreen(person: person));
        },
      ),
    ],
  );
}
