
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/utils/constants.dart';

// Home Page State
class HomePageState {
  final bool isLoading;
  final List<String> services;
  final String? error;

  const HomePageState({
    this.isLoading = false,
    this.services = const [],
    this.error,
  });

  HomePageState copyWith({
    bool? isLoading,
    List<String>? services,
    String? error,
  }) {
    return HomePageState(
      isLoading: isLoading ?? this.isLoading,
      services: services ?? this.services,
      error: error,
    );
  }
}

// Home Page Controller using Riverpod
class HomePageController extends StateNotifier<HomePageState> {
  HomePageController() : super(const HomePageState());

  void loadServices() {
    state = state.copyWith(isLoading: true, error: null);
    
    // Simulate loading services
    Future.delayed(const Duration(seconds: 1), () {
      final services = [
        "Water Delivery",
        "Bottle Refill",
        "Maintenance",
        "Subscription"
      ];
      state = state.copyWith(isLoading: false, services: services);
    });
  }
}

// Provider for Home Page Controller
final homePageControllerProvider = StateNotifierProvider<HomePageController, HomePageState>((ref) {
  return HomePageController();
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load services when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homePageControllerProvider.notifier).loadServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homePageControllerProvider);
    final mqttState = ref.watch(mqttControllerProvider);
    
    // Listen to MQTT state changes
    ref.listen<MqttState>(mqttControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Waari Water",
          style: TextStyle(fontSize: 18.sp),
        ),
        backgroundColor: Constants.primaryColor,
      ),
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : homeState.services.isNotEmpty
              ? Padding(
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
                          itemCount: homeState.services.length,
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
                                      homeState.services[index],
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
                )
              : const Center(child: Text("No services available")),
    );
  }
}
