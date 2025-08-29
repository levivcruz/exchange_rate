import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../blocs/blocs.dart';
import '../cubits/cubits.dart';
import '../widgets/widgets.dart';
import '../../../../core/core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentExchangeRateCubit>(
          create: (context) => sl<CurrentExchangeRateCubit>(),
        ),
        BlocProvider<CurrencyInputCubit>(
          create: (context) => sl<CurrencyInputCubit>(),
        ),
        BlocProvider<DailyExchangeRateBloc>(
          create: (context) => sl<DailyExchangeRateBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.neutralWhite,
        body: SafeArea(
          child: Column(
            children: [
              const LogoSectionWidget(),

              const HeaderWidget(),

              const Expanded(child: MainContentWidget()),

              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
