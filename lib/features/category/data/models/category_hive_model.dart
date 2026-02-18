import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:bazar/core/constants/hive_table_constant.dart';
//dart run build_runner build -d 
part 'category_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.categoryTypeId)

class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  final String? categoryId;

  @HiveField(1)
  final String categoryName;

  CategoryHiveModel({
    String? categoryId,
    required this.categoryName,String? status
  }) : categoryId = categoryId ?? Uuid().v4();
  

  
  // TOENtity
  CategoryEntity toEntity() {
    return CategoryEntity(categoryId: categoryId, categoryName: categoryName);
  }

  // From Entity -> conversion
  factory CategoryHiveModel.fromEntity(CategoryEntity entity) {
    return CategoryHiveModel(categoryName: entity.categoryName);
  }

  // EntityList
  static List<CategoryEntity> toEntityList(List<CategoryHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

}