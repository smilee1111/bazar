import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable{
  //defining variables
  final String? categoryId;
  final String categoryName;

  //constructor for role entity
  const CategoryEntity({
    this.categoryId,
    required this.categoryName,
  });

  // Equatable props override
  @override
  List<Object?> get props => [
    categoryId,
    categoryName,
  ];

}