import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HomePage",
          style: TextStyle(fontSize: 18.sp),
        ),
        toolbarHeight: 56.h,
      ),
      body: Center(
        child: Text(
          "Home Page",
          style: TextStyle(fontSize: 34.sp),
        ),
      ),
    );
  }
}
