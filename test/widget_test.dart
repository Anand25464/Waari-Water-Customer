import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError || snapshot.data == null) {
                // Show a blank container if there is an error or the image is not loaded
                return Container();
              }
              // Apply color filter to the loaded image
              return InkWell(onTap:(){print("------------------");},child: snapshot.data);
            } else {
              // Show a loading indicator while the image is being loaded
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
  Future<Image?> loadImage() async {
    try {
      // Replace 'assets/your_image.png' with the actual path to your PNG image
      final ByteData data = await rootBundle.load('assets/images/Wallet.2.png');
      final List<int> bytes = data.buffer.asUint8List();
      final Uint8List uint8List = Uint8List.fromList(bytes);
      final image = Image.memory(uint8List,color: Colors.pink,);
      return image;
    } catch (e) {
      // Handle the error if image loading fails
      print('Error loading image: $e');
      return null;
    }
  }
}
