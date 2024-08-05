import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/model/User.dart';
import 'package:mobile/style/color.dart';
import 'package:mobile/service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile/provider/attendance_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakePhotoScreen extends StatefulWidget {
  final String type;

  const TakePhotoScreen({super.key, required this.type});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> with WidgetsBindingObserver {
  User? user;
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  File? imageFile;
  ImageProvider? imagePreview;
  Future<void>? _initializeCameraFuture;
  String currentTime = '';
  final ApiService apiService = ApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraFuture = initializeCamera();
    _loadUserData();
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
    if (!cameraController!.value.isInitialized || cameraController!.value.isRecordingVideo) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraFuture = initializeCamera();
    }
  }

  Future<void> _loadUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? userJson = sp.getString('userData');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        user = User.fromJson(userMap);
      });
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    cameraController = CameraController(frontCamera, ResolutionPreset.medium);

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
      currentTime = _formatCurrentTime();
      print('Preview diupdate dengan file baru: ${file.path}');
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
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

  Future<void> _attend(String type) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();

      if (imageFile != null) {
        var response = await apiService.attendance(latitude, longitude, type, imageFile!.path);

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${type == 'in' ? 'Check-in' : 'Check-out'} berhasil')),
          );

          context.read<AttendanceProvider>().loadAttendance();

          Navigator.of(context).pop(true);

        } else {
          _showErrorDialog(response.data.type);
        }
      } else {
        _showErrorDialog('Gambar belum diambil');
      }
    } catch (e) {
      _showErrorDialog('Error during $type attendance: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red.shade100,
                child: const Icon(Icons.error, size: 40, color: Colors.red),
              ),
              const SizedBox(height: 16),
              const Text(
                'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Batal', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Catat Kehadiran ${widget.type == 'in' ? 'Masuk' : 'Keluar'}"),
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
                              user?.name ?? "Guest",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              user?.rank ?? "None",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Container(
                              width: 150,
                              height: 250,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: imageTakenWidget(),
                            ),
                            const SizedBox(height: 20,),
                            Text(
                              'Jam ${widget.type == 'in' ? 'Masuk' : 'Keluar'}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              currentTime,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 25),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      user?.office.address ?? "none",
                                      style: const TextStyle(fontSize: 11, color: Colors.black),
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
                            onPressed: isLoading ? null : () {
                              if (imageFile != null) {
                                _attend(widget.type);
                              } else {
                                _showErrorDialog('Gambar belum diambil');
                              }
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: AppColors.primaryColor),
                                ),
                              ),
                            ),
                            icon: isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Icon(Icons.logout, color: Colors.white),
                            label: Text('Catat Jam ${widget.type == 'in' ? 'Masuk' : 'Keluar'}', style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
