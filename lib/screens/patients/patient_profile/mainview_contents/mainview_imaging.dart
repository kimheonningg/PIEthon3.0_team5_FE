import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

class MainviewImaging extends StatefulWidget {
  const MainviewImaging({super.key});

  @override
  State<MainviewImaging> createState() => _MainviewImagingState();
}

class _MainviewImagingState extends State<MainviewImaging> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ImageObject()],
          ),
        ),
      ),
    );
  }
}

class ImageObject extends StatefulWidget {
  const ImageObject({super.key});

  @override
  State<ImageObject> createState() => _ImageObjectState();
}

class _ImageObjectState extends State<ImageObject> {
  bool _isLoading = true;
  bool _didPrecache = false;
  double _currentSliderValue = 0;

  late final TransformationController _transformationController;
  double _currentScale = 0.8;
  final double _minScale = 0.4;
  final double _maxScale = 4.0;

  final List<String> _imageUrls = List.generate(99, (index) {
    return 'https://cdn.kiminjae.me/piethon-viewer/test/slice_${index.toString().padLeft(4, '0')}.png';
  });

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecache) {
      _precacheImages();
      _didPrecache = true;
    }
  }

  Future<void> _precacheImages() async {
    // 모든 이미지를 캐시하는 작업이 끝날 때까지 기다림
    await Future.wait(
      _imageUrls.map(
        (url) => precacheImage(
          CachedNetworkImageProvider(url), // CachedNetworkImage의 Provider 사용
          context,
        ),
      ),
    );

    // 위젯이 아직 화면에 마운트된 상태라면 로딩 상태를 false로 변경
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _zoomIn() {
    // 현재 중앙점을 기준으로 확대
    final center = MediaQuery.of(context).size.center(Offset.zero);
    final newScale = _currentScale * 1.2;
    if (newScale > _maxScale) return;

    final newMatrix = Matrix4.identity()
      ..translate(center.dx, center.dy)
      ..scale(1.2)
      ..translate(-center.dx, -center.dy);

    // 현재 행렬에 새로운 변환을 곱함
    final newControllerValue = _transformationController.value * newMatrix;
    _transformationController.value = newControllerValue;

    setState(() {
      _currentScale = newScale;
    });
  }

  void _zoomOut() {
    final center = MediaQuery.of(context).size.center(Offset.zero);
    final newScale = _currentScale / 1.2;
    if (newScale < _minScale) return;

    final newMatrix = Matrix4.identity()
      ..translate(center.dx, center.dy)
      ..scale(1 / 1.2)
      ..translate(-center.dx, -center.dy);

    final newControllerValue = _transformationController.value * newMatrix;
    _transformationController.value = newControllerValue;

    setState(() {
      _currentScale = newScale;
    });
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    setState(() {
      _currentScale = 0.8;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int currentImageIndex = _currentSliderValue.toInt();
    print(currentImageIndex);
    return Column(
      children: [
        //
        //추후 DropdownButton으로 수정하기!!!!
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 드롭다운 버튼과 이미지 정보
            Expanded(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: MainColors.button2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'T1-weighted',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gaps.h8,
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  Gaps.h8,
                  Flexible(
                    child: Text(
                      'Acquired: June 14, 2025 | Slice: 24/48',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.crop_free_outlined,
                  color: Colors.grey[600],
                  size: 18,
                ),
                Gaps.h8,
                Icon(
                  Icons.more_vert,
                  color: Colors.grey[600],
                  size: 18,
                ),
              ],
            )
          ],
        ),
        Gaps.v12,
        SizedBox(
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    //사진 뷰
                    ClipRRect(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : InteractiveViewer(
                              transformationController: _transformationController,
                              minScale: _minScale,
                              maxScale: _maxScale,
                              // 사용자가 손가락으로 줌을 했을 때 _currentScale 업데이트
                              onInteractionEnd: (details) {
                                setState(() {
                                  // value.getMaxScaleOnAxis()를 통해 현재 배율을 얻음
                                  _currentScale = _transformationController.value.getMaxScaleOnAxis();
                                });
                              },
                              child: Center(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: _imageUrls[currentImageIndex],
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.zoom_in_outlined, color: Colors.white),
                              onPressed: _zoomIn,
                              tooltip: 'Zoom In',
                            ),
                            IconButton(
                              icon: const Icon(Icons.zoom_out_outlined, color: Colors.white),
                              onPressed: _zoomOut,
                              tooltip: 'Zoom Out',
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.replay,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: _resetZoom,
                              tooltip: 'Reset',
                            ),
                            Gaps.h8,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v8,

              //슬라이더
              Slider(
                activeColor: MainColors.selectedTab,
                value: _currentSliderValue,
                min: 0,
                // 최댓값은 (이미지 개수 - 1)
                max: (_imageUrls.length - 1).toDouble(),
                // divisions: 슬라이더를 몇 단계로 나눌지 결정 (정수 단위로만 움직이게 함)
                divisions: _imageUrls.length - 1,
                // 슬라이더 값이 변경될 때마다 호출
                onChanged: (double value) {
                  // setState를 호출하여 상태를 업데이트하고 화면을 다시 그리도록 함
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
