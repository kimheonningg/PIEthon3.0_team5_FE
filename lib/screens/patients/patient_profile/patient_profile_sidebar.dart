// Navigation Sidebar 위젯
import 'package:flutter/material.dart';
import 'package:piethon_team5_fe/provider/mainview_tab_provider.dart';
import 'package:piethon_team5_fe/widgets/gaps.dart';
import 'package:piethon_team5_fe/widgets/maincolors.dart';
import 'package:provider/provider.dart';

class PatientProfileSidebar extends StatefulWidget {
  const PatientProfileSidebar({
    super.key,
  });

  @override
  State<PatientProfileSidebar> createState() => _PatientProfileSidebar();
}

class _PatientProfileSidebar extends State<PatientProfileSidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256, //고정
      color: MainColors.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                InkWell(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Gaps.h4,
                Image.asset(
                  'assets/images/logo.png',
                  scale: 4,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patient History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 18,
                    ),
                    Gaps.h2,
                    Icon(Icons.filter_list, size: 18)
                  ],
                )
              ],
            ),
          ),
          //구분선
          Container(
            height: 1,
            color: const Color(0xFF374151),
          ),
          // Navigation 섹션
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientHistoryItem(title: '2025-06-25'),
                    Gaps.v8,
                    PatientHistoryItem(title: '2025-06-14'),
                  ],
                ),
              ),
            ),
          ),
          //구분선
          const Divider(
            color: MainColors.dividerLine,
            height: 1,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "멋진 로그인 정보",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// 섹션 제목 위젯
class PatientHistoryItem extends StatefulWidget {
  final String title;
  const PatientHistoryItem({super.key, required this.title});

  @override
  State<PatientHistoryItem> createState() => _PatientHistoryItemState();
}

class _PatientHistoryItemState extends State<PatientHistoryItem> {
  bool _isFold = true;

  @override
  Widget build(BuildContext context) {
    final mainviewTabProvider = context.read<MainviewTabProvider>();
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isFold = !_isFold;
            });
          },
          child: Row(
            children: [
              Icon(
                _isFold ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_down,
                color: MainColors.sidebarNameText,
              ),
              Gaps.h4,
              Text(
                widget.title,
                style: const TextStyle(
                  color: MainColors.sidebarNameText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        _isFold
            ? const SizedBox()
            : Column(
                children: [
                  NavItem(
                    icon: Icons.people_outline,
                    title: 'Clinical Notes',
                    onTap: () {
                      mainviewTabProvider.changeTab('Clinical Notes');
                    },
                  ),
                  NavItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Medications',
                    onTap: () {
                      mainviewTabProvider.changeTab('Treatment Plans');
                    },
                  ),
                  NavItem(
                    icon: Icons.bar_chart_outlined,
                    title: 'Chest MRI',
                    onTap: () {
                      mainviewTabProvider.changeTab('Imaging');
                    },
                  ),
                  NavItem(
                    icon: Icons.camera_alt_outlined,
                    title: 'Chest CT',
                    onTap: () {
                      mainviewTabProvider.changeTab('Imaging');
                    },
                  ),
                ],
              ),
      ],
    );
  }
}

// 네비게이션 메뉴 아이템 위젯
class NavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) {
          setState(() {
            _isHovering = hovering;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: MainColors.sidebarItemText,
                size: 16,
              ),
              Gaps.h12,
              Text(
                widget.title,
                style: const TextStyle(
                  color: MainColors.sidebarItemText,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
