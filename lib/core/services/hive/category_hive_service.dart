import 'package:bazar/core/constants/hive_table_constant.dart';
import 'package:bazar/features/auth/data/models/auth_hive_model.dart';
import 'package:bazar/features/category/data/models/category_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


final categoryHiveServiceProvider = Provider<CategoryHiveService>((ref){
  return CategoryHiveService();
});


class CategoryHiveService {

  //initialization 
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();        
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
     _registerAdapters();
    await _openBoxes();
    await insertDummyCategories();
  }

  Future<void> insertDummyCategories() async{
    // Use the already-opened box instead of opening it again
    final box = _categoryBox;
    if(box.isNotEmpty) return;

    final dummyCategories = [
      CategoryHiveModel(categoryName: 'Electronics'),
      CategoryHiveModel(categoryName: 'Furniture'),
      CategoryHiveModel(categoryName: "Men's Clothing"),
      CategoryHiveModel(categoryName: "Women's Clothins"),
      CategoryHiveModel(categoryName: 'Groceries'),
      CategoryHiveModel(categoryName: 'Other'),
    ];
    for(var category in dummyCategories){
      await box.put(category.categoryId,category);
    }
    // Don't close the box here - it's used throughout the app
  }

   //Register all type adapters 
  void _registerAdapters() {
    if(!Hive.isAdapterRegistered(HiveTableConstant.categoryTypeId)){
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
    Hive.registerAdapter(AuthHiveModelAdapter());
    }

  }

//OPEN BOXES
  Future<void> _openBoxes() async {
    await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable);
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);

  }

    // box close
  Future<void> _close() async {
    await Hive.close();
  }


//ROLE METHODS
   Box<CategoryHiveModel> get _categoryBox =>
    Hive.box<CategoryHiveModel>(HiveTableConstant.categoryTable);

  
  //Create a new category 
  Future<CategoryHiveModel> createCategory(CategoryHiveModel category) async {
    await _categoryBox.put(category.categoryId,category);
    return category;
  }

  //Get all categories
  List<CategoryHiveModel> getAllCategories(){
    return _categoryBox.values.toList();
  }


  //Get category by ID
  CategoryHiveModel? getCategoryById(String categoryId){
    return _categoryBox.get(categoryId);
  }

  //Update a category
  Future<void> updateCategory(CategoryHiveModel category) async {
    await _categoryBox.put(category.categoryId,category);
  }


  //Delete a category
  Future<void> deleteCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
  }
 

}