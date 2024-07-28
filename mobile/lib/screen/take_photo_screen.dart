import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:image/image.dart' as img;
import 'package:mobile/style/color.dart';

class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({super.key});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> with WidgetsBindingObserver {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  File? imageFile;
  ImageProvider? imagePreview;
  Future<void>? _initializeCameraFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraFuture = initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!cameraController!.value.isInitialized ||
        cameraController!.value.isRecordingVideo) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraFuture = initializeCamera();
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);

    await cameraController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    await cameraController?.setFocusMode(FocusMode.auto);

    setState(() {});
  }

  Widget cameraPreviewWidget() {
    if (cameraController != null && cameraController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: cameraController!.value.aspectRatio,
        child: CameraPreview(cameraController!),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  void setImagePreview(XFile xFile) {
    File file = File(xFile.path);
    setState(() {
      imageFile = file;
      imagePreview = FileImage(file);
      print('Preview diupdate dengan file baru: ${file.path}');
    });
  }

  Widget imageTakenWidget() {
    if (imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          key: UniqueKey(),
          image: FileImage(imageFile!),
          width: 200,
          height: 300,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const Text('Tidak ada gambar yang diambil.');
    }
  }


  Future<void> takePicture() async {
    if (!cameraController!.value.isInitialized) {
      print('Kontroler kamera belum diinisialisasi');
      return;
    }

    if (cameraController!.value.isTakingPicture) {
      print('Kamera sedang mengambil gambar');
      return;
    }

    try {
      XFile xFile = await cameraController!.takePicture();
      print('Gambar diambil: ${xFile.path}');
      setImagePreview(xFile);
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catat Kehadiran"),
      ),
        body: FutureBuilder<void>(
          future: _initializeCameraFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (imageFile == null) ...[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width,
                      child: cameraPreviewWidget(),
                    ),
                    Center(
                      child: IconButton(
                        iconSize: 70,
                        icon: const Icon(
                          Icons.circle_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          takePicture();
                        },
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Gilbert Marpaung',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              'Guru Bahasa Indonesia Kelas 10, 11, dan 12',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Container(
                              width: 150,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: imageTakenWidget(),
                            ),
                            const SizedBox(height: 20,),
                            Text(
                              'Jam Masuk',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              '07:58:55',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.cardLoc,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.location_on_outlined, size: 25),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      'Kantor 1 - Jl.Sisingamangaraja Sitoluama, Laguboti, Toba Samosir 22381, Sumatera Utara - Indonesia',
                                      style: TextStyle(fontSize: 11, color: Colors.black),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(color: AppColors.primaryColor)
                                    )
                                )
                            ),
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text('Catat Jam Masuk', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    )
                  ],
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
    );
  }
}
