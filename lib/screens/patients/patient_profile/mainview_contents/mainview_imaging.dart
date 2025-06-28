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
  late double _initialScale;

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
              Gaps.h16,
              const Expanded(child: Placeholder())
            ],
          ),
        )
      ],
    );
  }
}
