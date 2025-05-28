
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/utils/constants.dart';

// Home Page Cubit
abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<String> services;
  HomePageLoaded(this.services);
}

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());

  void loadServices() {
    emit(HomePageLoading());
    
    // Simulate loading services
    Future.delayed(const Duration(seconds: 1), () {
      final services = [
        "Water Delivery",
        "Bottle Refill",
        "Maintenance",
        "Subscription"
      ];
      emit(HomePageLoaded(services));
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomePageCubit>().loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit()..loadServices(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Waari Water",
            style: TextStyle(fontSize: 18.sp),
          ),
          backgroundColor: Constants.primaryColor,
        ),
        body: BlocListener<MqttController, MqttState>(
          listener: (context, state) {
            if (state is MqttError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<HomePageCubit, HomePageState>(
            builder: (context, state) {
              if (state is HomePageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomePageLoaded) {
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to Waari Water",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Our Services",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: state.services.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4,
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Constants.primaryColor.withOpacity(0.1),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.water_drop,
                                      size: 40.sp,
                                      color: Constants.primaryColor,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      state.services[index],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text("No services available"));
            },
          ),
        ),
      ),
    );
  }
}
