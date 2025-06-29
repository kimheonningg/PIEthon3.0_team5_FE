import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:piethon_team5_fe/const.dart';
import 'package:piethon_team5_fe/functions/token_manager.dart';
import 'package:piethon_team5_fe/models/patient_image_models.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';

class MainviewImaging extends StatefulWidget {
  const MainviewImaging({super.key, required this.patientMrn});

  final String patientMrn;

  @override
  State<MainviewImaging> createState() => _MainviewImagingState();
}

class _MainviewImagingState extends State<MainviewImaging> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageObject(
                patientMrn: widget.patientMrn,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageObject extends StatefulWidget {
  const ImageObject({super.key, required this.patientMrn});
  final String patientMrn;

  @override
  State<ImageObject> createState() => _ImageObjectState();
}

class _ImageObjectState extends State<ImageObject> {
  late Future<PatientImagingResponse> _patientDataFuture;

  @override
  void initState() {
    super.initState();

    _patientDataFuture = getPatientData(widget.patientMrn);
  }

  /// 이미지 데이터 불러오기
  Future<PatientImagingResponse> getPatientData(String patientMrn) async {
    final url = Uri.parse('$BASE_URL/imaging/patients/$patientMrn');

    try {
      final token = await TokenManager.getAccessToken();
      if (token == null || token.isEmpty) throw Exception('Please Login.');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // 성공적으로 데이터를 받았다면, JSON을 디코딩하고 모델 객체로 변환합
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        return PatientImagingResponse.fromJson(jsonResponse);
      } else {
        // 서버 에러가 발생한 경우
        throw Exception('Failed to load patient data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PatientImagingResponse>(
        future: _patientDataFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 에러가 발생했을 때
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Failed to load image data. Error: ${asyncSnapshot.error}'));
          }
          if (!asyncSnapshot.hasData || !asyncSnapshot.data!.success) {
            return Center(child: Text(asyncSnapshot.data?.message ?? 'No data found.'));
          }
          final patientData = asyncSnapshot.data!;
          return Column(
            children: [
              ...patientData.imagingStudies.map((study) {
                ///
                // 각 Study
                ////
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Modality : ${study.modality} / BodyPart : ${study.bodyPart} / Date : ${study.createdAt.toIso8601String()}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: MainColors.sidebarItemText, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Gaps.v14,
                    ...study.series.map((series) {
                      return SeriesCard(
                        series: series,
                      );
                    })
                  ],
                );
              }),
            ],
          );
        });
  }
}

class SeriesCard extends StatefulWidget {
  const SeriesCard({super.key, required this.series});
  final Series series;

  @override
  State<SeriesCard> createState() => _SeriesCardState();
}

class _SeriesCardState extends State<SeriesCard> {
  final GlobalKey _fixedImageKey = GlobalKey();
  final GlobalKey _transitionImageKey = GlobalKey();

  bool _isLoading = true;
  double _currentSliderValue = 0;
  bool _didPrecache = false;

  late final TransformationController _transitionImageController;
  late final TransformationController _fixedImageController;

  double _transitionImageCurrentScale = 1.2;
  double _fixedImageCurrentScale = 1.2;
  final double _minScale = 0.4;
  final double _maxScale = 4.0;

  late List<String> imageUrls;

  Future<void> precacheImages() async {
    imageUrls = List.generate(143, (index) {
      return '${widget.series.slicesDir}slice_${index.toString().padLeft(4, '0')}.png';
    });
    // 모든 이미지를 캐시하는 작업이 끝날 때까지 기다림
    await Future.wait(
      imageUrls.map(
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

  @override
  void initState() {
    super.initState();
    _transitionImageController = TransformationController();
    _fixedImageController = TransformationController();
    _currentMatrix = _fixedImageController.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecache) {
      precacheImages();
      _didPrecache = true;
    }
    _sourceRects = widget.series.diseases.map((value) {
      return Rect.fromLTWH(value.boundingBox.x1.toDouble(), value.boundingBox.y1.toDouble(),
          (value.boundingBox.x2 - value.boundingBox.x1).toDouble(), (value.boundingBox.y2 - value.boundingBox.y1).toDouble());
    }).toList();
  }

  @override
  void dispose() {
    _transitionImageController.dispose();
    super.dispose();
  }

  ////////////// 이미지 관련 함수들 /////////////

// zoomIn/zoomOut 로직을 하나로 통합한 헬퍼 함수
  void _zoom({
    required bool isFixedImage,
    required double zoomFactor, // 1.2는 확대, 1/1.2는 축소
  }) {
    // 1. 현재 상태에 맞는 컨트롤러, 키, 스케일 변수를 가져옴
    final TransformationController controller = isFixedImage ? _fixedImageController : _transitionImageController;
    final GlobalKey key = isFixedImage ? _fixedImageKey : _transitionImageKey;
    final double currentScale = isFixedImage ? _fixedImageCurrentScale : _transitionImageCurrentScale;

    final newScale = currentScale * zoomFactor;

    // 2. 최대/최소 배율을 넘지 않도록 제한
    if (newScale > _maxScale || newScale < _minScale) {
      return;
    }

    // 3. GlobalKey를 이용해 InteractiveViewer의 RenderBox 정보를 가져옴
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final viewportCenter = renderBox.size.center(Offset.zero);

    // 4. 현재 변환 행렬의 역행렬을 계산
    final Matrix4 scene = controller.value.clone();
    final Matrix4 inverseScene = Matrix4.inverted(scene);

    // 5. 뷰포트 중심에 해당하는 이미지 내부의 실제 좌표(피봇)를 계산
    final Offset pivot = MatrixUtils.transformPoint(inverseScene, viewportCenter);

    // 6. 피봇을 기준으로 확대/축소하는 변환 행렬 생성
    final Matrix4 scaleMatrix = Matrix4.identity()
      ..translate(pivot.dx, pivot.dy)
      ..scale(zoomFactor)
      ..translate(-pivot.dx, -pivot.dy);

    // 7. 현재 행렬에 새로운 스케일 변환을 곱하여 최종 행렬을 만듦
    final Matrix4 newMatrix = scene * scaleMatrix;

    // 8. 컨트롤러와 상태 업데이트
    controller.value = newMatrix;
    setState(() {
      if (isFixedImage) {
        _fixedImageCurrentScale = newScale;
      } else {
        _transitionImageCurrentScale = newScale;
      }
    });
  }

  // 이제 _zoomIn과 _zoomOut은 간단하게 _zoom 함수를 호출하기만 함
  void _zoomIn(bool isFixedImage) {
    _zoom(isFixedImage: isFixedImage, zoomFactor: 1.2);
  }

  void _zoomOut(bool isFixedImage) {
    _zoom(isFixedImage: isFixedImage, zoomFactor: 1 / 1.2);
  }

  void _resetZoom(bool isFixedImage) {
    if (isFixedImage) {
      _fixedImageController.value = Matrix4.identity();
    } else {
      _transitionImageController.value = Matrix4.identity();
    }

    setState(() {
      if (isFixedImage) {
        _fixedImageCurrentScale = 1.2;
      } else {
        _transitionImageCurrentScale = 1.2;
      }
    });
  }
  ////////////// 이미지 관련 함수들 /////////////

  late List<Rect> _sourceRects;
  Matrix4? _currentMatrix;

  @override
  Widget build(BuildContext context) {
    final int currentImageIndex = _currentSliderValue.toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.series.sequenceType}-weighted',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Gaps.v2,
        Text(
          'acquired : ${widget.series.createdAt.toIso8601String()}',
          style: const TextStyle(color: Colors.white),
        ),
        Row(
          children: [
            // slider가 있는 사진 (transitionImage)
            Expanded(
              child: SizedBox(
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
                                    key: _transitionImageKey,
                                    scaleEnabled: false,
                                    transformationController: _transitionImageController,
                                    minScale: _minScale,
                                    maxScale: _maxScale,
                                    child: Center(
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrls[currentImageIndex],
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                    onPressed: () {
                                      _zoomIn(false);
                                    },
                                    tooltip: 'Zoom In',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.zoom_out_outlined, color: Colors.white),
                                    onPressed: () {
                                      _zoomOut(false);
                                    },
                                    tooltip: 'Zoom Out',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.replay,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      _resetZoom(false);
                                    },
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
                      max: (imageUrls.length - 1).toDouble(),
                      divisions: imageUrls.length - 1,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Gaps.h16,
            // 대표 사진(fixedImage)
            Expanded(
              child: SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    //사진 뷰
                    ClipRRect(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : InteractiveViewer(
                              key: _fixedImageKey,
                              scaleEnabled: false,
                              transformationController: _fixedImageController,
                              minScale: _minScale,
                              maxScale: _maxScale,
                              child: Center(
                                child: Stack(
                                  children: [
                                    Image.network(
                                        '${widget.series.slicesDir}slice_${widget.series.sliceIdx.toString().padLeft(4, '0')}.png'),
                                    // 사각형을 그릴 캔버스
                                    if (_currentMatrix != null)
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: RectanglePainter(
                                            matrix: _currentMatrix!,
                                            rectangles: _sourceRects,
                                          ),
                                        ),
                                      ),
                                  ],
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
                              onPressed: () {
                                _zoomIn(true);
                              },
                              tooltip: 'Zoom In',
                            ),
                            IconButton(
                              icon: const Icon(Icons.zoom_out_outlined, color: Colors.white),
                              onPressed: () {
                                _zoomOut(true);
                              },
                              tooltip: 'Zoom Out',
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.replay,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {
                                _resetZoom(true);
                              },
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
            ),
          ],
        )
      ],
    );
  }
}

// 사각형을 그릴 CustomPainter 클래스 생성
class RectanglePainter extends CustomPainter {
  final Matrix4 matrix; // InteractiveViewer로부터 받은 변환 행렬
  final List<Rect> rectangles; // 원본 이미지 기준의 사각형 좌표 목록
  final Paint painter; // 사각형의 스타일 (색상, 두께 등)

  RectanglePainter({
    required this.matrix,
    required this.rectangles,
  }) : painter = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0; // 사각형 선의 두께

  @override
  void paint(Canvas canvas, Size size) {
    // 변환된 행렬을 적용하기 위해 캔버스를 저장하고 변환을 적용
    canvas.save();
    canvas.transform(matrix.storage);

    // 모든 사각형 좌표를 순회하며 캔버스에 그리기
    for (final rect in rectangles) {
      canvas.drawRect(rect, painter);
    }

    // 캔버스 상태를 복원
    canvas.restore();
  }

  // matrix나 rectangles 목록이 변경되었을 때만 다시 그리도록 설정 (성능 최적화)
  @override
  bool shouldRepaint(covariant RectanglePainter oldDelegate) {
    return oldDelegate.matrix != matrix || oldDelegate.rectangles != rectangles;
  }
}
