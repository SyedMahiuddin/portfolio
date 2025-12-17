import 'package:get/get.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/project_model.dart';
import '../../data/models/experience_model.dart';
import '../../data/repositories/portfolio_repository.dart';

class HomeController extends GetxController {
  final PortfolioRepository _repository = PortfolioRepository();

  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxList<ExperienceModel> experiences = <ExperienceModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await Future.wait([
      loadProfile(),
      loadProjects(),
      loadExperiences(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadProfile() async {
    final data = await _repository.getProfile();
    profile.value = data;
  }

  Future<void> loadProjects() async {
    final data = await _repository.getProjects();
    projects.value = data;
  }

  Future<void> loadExperiences() async {
    final data = await _repository.getExperiences();
    experiences.value = data;
  }
}