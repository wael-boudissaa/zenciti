import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/api_service.dart';
import '../models/categorie.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService apiService;

  CategoryRepositoryImpl(this.apiService);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categories = await apiService.fetchCategories();
    return categories
        .map((category) => CategoryEntity(
              id: category.id,
              name: category.name,
            ))
        .toList();
  }
}
