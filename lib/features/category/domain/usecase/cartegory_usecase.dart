
import '../entities/category_entity.dart';
import '../../data/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepositoryImpl repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() async {
    final categories = await repository.getCategories();
    return categories.map((category) => 
      CategoryEntity(id: category.id, name: category.name)
    ).toList();
  }
}
