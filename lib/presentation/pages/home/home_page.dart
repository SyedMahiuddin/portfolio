import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_web/presentation/pages/home/widgets/technical_skils_selection.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/portfolio_navbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/bento_grid.dart';
import 'widgets/projects_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/contact_section.dart';

class HomePage extends GetView<HomeController> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  void _scrollToSection(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Container(
                    key: _sectionKeys[0],
                    child: HeroSection(),
                  ),
                  BentoGrid(),
                  Container(
                    key: _sectionKeys[1],
                    child: TechnicalSkillsSection(),
                  ),
                  Container(
                    key: _sectionKeys[2],
                    child: ProjectsSection(),
                  ),
                  Container(
                    key: _sectionKeys[3],
                    child: ExperienceSection(),
                  ),
                  Container(
                    key: _sectionKeys[4],
                    child: ContactSection(),
                  ),
                  _buildFooter(),
                ],
              ),
            );
          }),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PortfolioNavbar(
              onNavigate: _scrollToSection,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Center(
        child: Text(
          '© 2024 Syed Mahiuddin. All rights reserved',
          style: TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ),
    );
  }
}