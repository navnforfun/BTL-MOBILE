import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart'; // Import for VLC player
import 'package:mobile_sercutity/api/getChartAPI.dart' as api;

class CameraScreen extends StatefulWidget {
  final String cameraIp; // Add camera IP as a parameter
  CameraScreen({super.key, required this.cameraIp});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  VlcPlayerController? _videoPlayerController; // Create a VlcPlayerController
  late List<String> logCamera;

  @override
  void initState() {
    super.initState();
    getLogCamera();
    _videoPlayerController = VlcPlayerController.network(
      widget.cameraIp, // Use the provided camera IP
      autoInitialize: true,
      hwAcc:
          HwAcc.full, // Hardware acceleration for better performance (optional)
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  void getLogCamera() async {
    var listLog = await api.getLogCamera(5);
    setState(() {
      logCamera = listLog;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.pause(); // Pause before disposing
    _videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Camera Screen"),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[300]!,
                Colors.blue[700]!,
              ],
            ),
          ),
          child: Column(
            children: [
              Center(
                child: _videoPlayerController != null
                    ? VlcPlayer(
                        controller: _videoPlayerController!,
                        aspectRatio: 3 / 2, // Set a common aspect ratio
                        placeholder: const Center(
                          child:
                              CircularProgressIndicator(), // Placeholder while loading
                        ),
                      )
                    : const Text('Loading Camera Feed...'),
                // Feedback while initializing
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25,10,25,10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                ),
                child: Column(
                  children: logCamera.map((e) {
                  return   RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '* Phát hiện đám cháy vào lúc ',
                          style: const TextStyle(fontSize: 16, height: 2, color: Colors.black),
                        ),
                        TextSpan(
                          text: e.toString(),
                          style: const TextStyle(fontSize: 16, height: 2, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                   }).toList(),

                ),
              )
            ],
          ),
        ));
  }
}
