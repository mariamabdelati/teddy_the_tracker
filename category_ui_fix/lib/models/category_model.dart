//dummy category class
class Category {
  final int budget;
  final int categoryID;
  final List<int> childIDs;
  final String label;
  final int parentID;

  Category({
    required this.parentID,
    required this.label,
    required this.childIDs,
    this.budget = 0,
    required this.categoryID,
  });
}

