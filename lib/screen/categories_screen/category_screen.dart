import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _categoryService = CategoryService();
  String _newCategoryName = '';
  String _newCategoryState = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'home', (route) => false);
          },
        ),
      ),
      body: FutureBuilder<CategoryList>(
        future: _categoryService.getCategoryList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final categories = snapshot.data?.categories ?? [];
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.categoryName),
                  subtitle: Text('ID: ${category.categoryId}, State: ${category.categoryState}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editCategory(category);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteCategory(category);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCategory();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editCategory(Category category) async {
  final result = await _showEditCategoryDialog(category.categoryName, category.categoryState);
  if (result != null) {
    try {
      await _categoryService.editCategory(category.categoryId, result['categoryName'] ?? '', result['categoryState'] ?? '');
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to edit category: $error'),
        ),
      );
    }
  }
}

  Future<Map<String, String>?> _showEditCategoryDialog(String currentName, String currentState) async {
  String newName = currentName;
  String newState = currentState;

  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: TextEditingController(text: currentName),
            decoration: InputDecoration(labelText: 'New Category Name'),
            onChanged: (value) => newName = value,
          ),
          TextField(
            controller: TextEditingController(text: currentState),
            decoration: InputDecoration(labelText: 'New Category State'),
            onChanged: (value) => newState = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {'categoryName': newName, 'categoryState': newState});
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}


  void _deleteCategory(Category category) async {
    try {
      await _categoryService.deleteCategory(category.categoryId);
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category: $error'),
        ),
      );
    }
  }

  void _addCategory() async {
  final result = await _showAddCategoryDialog();
  if (result != null) {
    try {
      await _categoryService.addCategory(result);
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add category: $error'),
        ),
      );
    }
  }
}


Future<Category?> _showAddCategoryDialog() async {
  return showDialog<Category>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Category Name'),
            onChanged: (value) => setState(() => _newCategoryName = value),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Category State'),
            onChanged: (value) => setState(() => _newCategoryState = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newCategory = Category(categoryId: 0, categoryName: _newCategoryName, categoryState: _newCategoryState);
            Navigator.pop(context, newCategory);
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}
}
