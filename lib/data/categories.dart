
import 'package:category_ui_fix/models/category_model.dart';

//dummy category list to test if widgets works properly
final entryCategories = <Category>[
  Category(
    parentID: -1,
    label: "food",
    childIDs: [2,3],
    categoryID: 1,
  ),
  Category(
    parentID: 1,
    label: "fast food",
    childIDs: [],
    categoryID: 2,
  ),
  Category(
    parentID: 1,
    label: "burger",
    childIDs: [],
    categoryID: 3,
  ),
  Category(
    parentID: -1,
    label: "clothing",
    childIDs: [5],
    categoryID: 4,
  ),
  Category(
    parentID: 4,
    label: "dresses",
    childIDs: [],
    categoryID: 5,
  ),

  Category(
    parentID: -1,
    label: "transportation",
    childIDs: [7,8],
    categoryID: 6,
  ),
  Category(
    parentID: 6,
    label: "uber",
    childIDs: [],
    categoryID: 7,
  ),
  Category(
    parentID: 6,
    label: "gas",
    childIDs: [],
    categoryID: 8,
  ),
  Category(
    parentID: -1,
    label: "savings",
    childIDs: [],
    categoryID: 9,
  ),
  Category(
    parentID: -1,
    label: "medical",
    childIDs: [],
    categoryID: 10,
  ),
  Category(
    parentID: -1,
    label: "utilities",
    childIDs: [],
    categoryID: 11,
  ),
  Category(
    parentID: -1,
    label: "subscriptions",
    childIDs: [],
    categoryID: 12,
  ),
  Category(
    parentID: -1,
    label: "other",
    childIDs: [],
    categoryID: 13,
  ),
];