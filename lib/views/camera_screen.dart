import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = 0;

  bool isVideoMode = false;

  // ব্যবহারকারীর বেছে নেওয়া flash: auto / always (On) / off
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;
      await _startCamera(_cameraIndex);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _startCamera(int index) async {
    final CameraController? oldController = _controller;

    final CameraController newController = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: true,
    );

    if (mounted) {
      setState(() => _controller = null);
    }
    await oldController?.dispose();

    try {
      await newController.initialize();
    } catch (e) {
      debugPrint('Camera start error: $e');
      return;
    }

    if (!mounted) {
      await newController.dispose();
      return;
    }

    setState(() {
      _controller = newController;
      _cameraIndex = index;
    });

    // নতুন camera-তে flash আবার apply করো (UI-এর selection বদলাবে না)
    await _applyFlash();
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    if (_controller?.value.isRecordingVideo ?? false) return;
    final int nextIndex = (_cameraIndex + 1) % _cameras.length;
    await _startCamera(nextIndex);
  }

  /// বেছে নেওয়া flash mode camera-তে apply করে।
  /// সফল হলে null, ব্যর্থ হলে error message ফেরত দেয়।
  /// Photo: Auto → auto, On → always, Off → off
  /// Video: On → torch, বাকি সব → off
  Future<String?> _applyFlash() async {
    final CameraController? c = _controller;
    if (c == null || !c.value.isInitialized) return null;

    FlashMode effective = _flashMode;
    if (isVideoMode) {
      effective = _flashMode == FlashMode.always
          ? FlashMode.torch
          : FlashMode.off;
    }

    try {
      await c.setFlashMode(effective);
      debugPrint('Flash applied: $effective');
      return null;
    } catch (e) {
      debugPrint('Flash error ($effective): $e');
      return e.toString();
    }
  }

  IconData _flashIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
      case FlashMode.torch:
        return Icons.flash_on;
      case FlashMode.off:
        return Icons.flash_off;
    }
  }

  Widget _flashTile({
    required BuildContext sheetContext,
    required IconData icon,
    required String label,
    required FlashMode mode,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: _flashMode == mode
          ? const Icon(Icons.check, color: Color(0xFF25D366))
          : null,
      onTap: () => Navigator.pop(sheetContext, mode),
    );
  }

  Future<void> _showFlashOptions() async {
    final FlashMode? selected = await showModalBottomSheet<FlashMode>(
      context: context,
      backgroundColor: const Color(0xFF202020),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _flashTile(
              sheetContext: sheetContext,
              icon: Icons.flash_auto,
              label: 'Flash Auto',
              mode: FlashMode.auto,
            ),
            _flashTile(
              sheetContext: sheetContext,
              icon: Icons.flash_on,
              label: 'Flash On',
              mode: FlashMode.always,
            ),
            _flashTile(
              sheetContext: sheetContext,
              icon: Icons.flash_off,
              label: 'Flash Off',
              mode: FlashMode.off,
            ),
          ],
        ),
      ),
    );

    if (selected == null || !mounted) return;

    // UI সবসময় বদলাবে, কোনো revert নেই
    setState(() => _flashMode = selected);

    final String? error = await _applyFlash();
    if (error != null) {
      _showMessage('Flash apply হয়নি: $error');
    }
  }

  Future<void> _setVideoMode(bool value) async {
    if (_controller?.value.isRecordingVideo ?? false) return;
    setState(() => isVideoMode = value);
    await _applyFlash();
  }

  Future<void> captureMedia() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      if (isVideoMode) {
        if (_controller!.value.isRecordingVideo) {
          final video = await _controller!.stopVideoRecording();
          debugPrint('Video saved: ${video.path}');
        } else {
          await _applyFlash();
          await _controller!.startVideoRecording();
          debugPrint('Video recording started');
        }
      } else {
        await _applyFlash();
        final photo = await _controller!.takePicture();
        debugPrint('Photo saved: ${photo.path}');
      }
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _openGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? media = await showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: const Color(0xFF202020),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.white),
                title: const Text(
                  'Select Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(
                    sheetContext,
                    await picker.pickImage(source: ImageSource.gallery),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library, color: Colors.white),
                title: const Text(
                  'Select Video',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(
                    sheetContext,
                    await picker.pickVideo(source: ImageSource.gallery),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (media == null || !context.mounted) return;

    final bool isVideo =
        media.path.toLowerCase().endsWith('.mp4') ||
            media.path.toLowerCase().endsWith('.mov') ||
            media.path.toLowerCase().endsWith('.mkv') ||
            media.path.toLowerCase().endsWith('.webm');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${isVideo ? 'Video' : 'Photo'} selected: ${media.name}'),
      ),
    );

    debugPrint('Selected media path: ${media.path}');
  }

  Widget _buildPreview() {
    final CameraController? controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white54,
          size: 80,
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: 1 / controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRecording = _controller?.value.isRecordingVideo ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (flash মাঝখানে, close বাঁ দিকে)
            SizedBox(
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: _showFlashOptions,
                    icon: Icon(_flashIcon(), color: Colors.white),
                  ),
                ],
              ),
            ),

            // Camera preview
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF202020),
                child: _buildPreview(),
              ),
            ),

            // Camera controls
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gallery
                  IconButton(
                    onPressed: () => _openGallery(context),
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  // Capture button
                  GestureDetector(
                    onTap: captureMedia,
                    child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isRecording ? 20 : 5),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: isRecording
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            borderRadius: isRecording
                                ? BorderRadius.circular(6)
                                : null,
                            color: isVideoMode ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Switch camera
                  IconButton(
                    onPressed: _switchCamera,
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            // Photo / Video mode
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _setVideoMode(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        'VIDEO',
                        style: TextStyle(
                          color: isVideoMode
                              ? const Color(0xFF25D366)
                              : Colors.white54,
                          fontSize: 14,
                          fontWeight: isVideoMode
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => _setVideoMode(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        'PHOTO',
                        style: TextStyle(
                          color: !isVideoMode
                              ? const Color(0xFF25D366)
                              : Colors.white54,
                          fontSize: 14,
                          fontWeight: !isVideoMode
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}