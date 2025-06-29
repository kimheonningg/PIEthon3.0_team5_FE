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
  late PhotoViewController _photoViewController;
  bool _isLoading = true;
  bool _didPrecache = false;
  double _currentSliderValue = 0;
  final List<String> _imageUrls = List.generate(99, (index) {
    return 'https://cdn.kiminjae.me/piethon-viewer/test/slice_${index.toString().padLeft(4, '0')}.png';
  });

  @override
  void initState() {
    super.initState();
    _photoViewController = PhotoViewController();
  }

  @override
  void dispose() {
    _photoViewController.dispose();
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
    // 현재 스케일 값에 1.2를 곱하여 확대
    double currentScale = _photoViewController.scale ?? 1.0;
    _photoViewController.scale = currentScale * 1.2;
  }

  void _zoomOut() {
    // 현재 스케일 값에 0.8을 곱하여 축소
    double currentScale = _photoViewController.scale ?? 1.0;
    _photoViewController.scale = currentScale * 0.8;
  }

  void _reset() {
    // 스케일과 위치를 초기 상태로 리셋
    _photoViewController.scale = 0.25;
    _photoViewController.position = Offset.zero;
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
          height: 300,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          //사진 뷰
                          ClipRRect(
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : CachedNetworkImage(
                                    imageUrl: _imageUrls[currentImageIndex],
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.cover,
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
                                    onPressed: _reset,
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
                    Text(
                      '사진 ${currentImageIndex + 1} / 99',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    //슬라이더
                    Slider(
                      // 4. 슬라이더의 현재 값을 상태 변수와 연결
                      value: _currentSliderValue,
                      min: 0,
                      // 5. 최댓값은 (이미지 개수 - 1)
                      max: (_imageUrls.length - 1).toDouble(),
                      // 6. divisions: 슬라이더를 몇 단계로 나눌지 결정 (정수 단위로만 움직이게 함)
                      divisions: _imageUrls.length - 1,
                      // 7. 슬라이더를 드래그할 때 표시될 라벨
                      label: (currentImageIndex + 1).toString(),
                      // 8. 슬라이더 값이 변경될 때마다 호출
                      onChanged: (double value) {
                        // setState를 호출하여 상태를 업데이트하고 화면을 다시 그리도록 함
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Gaps.h16,
              Expanded(
                child: Stack(
                  children: [
                    //사진 뷰
                    ClipRRect(
                      child: PhotoView(
                        imageProvider: const AssetImage('assets/images/sampleMRI.png'),
                        controller: _photoViewController,
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2.0,
                        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
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
                              onPressed: _reset,
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
            ],
          ),
        )
      ],
    );
  }
}
