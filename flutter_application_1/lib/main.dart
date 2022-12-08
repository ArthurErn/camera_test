import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera()async{
    cameras = await availableCameras();

    cameraController = CameraController(cameras[0], ResolutionPreset.high);

    await cameraController.initialize().then((value){
      if(!mounted)return;
      setState(() {});
    }).catchError((e){
      print(e);
    });
  }

  Widget button(){
    return Align(alignment: Alignment.bottomLeft, child: 
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 20),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.black26,
                offset: Offset(2,2),
                blurRadius: 10
              )]
            ),
            child: Center(child: Icon(Icons.flip_camera_ios_outlined, color: Colors.black54,)),
          ));
  }

  @override
  Widget build(BuildContext context) {
   if(cameraController.value.isInitialized){
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(cameraController),
          GestureDetector(
            onTap: ()async{
              XFile file = await cameraController.takePicture();
              file.saveTo(file.path);
              print(file.path);
            },
            child: button())
        ],
      ),
    );
  }else{
    return Container();
  }}
}
