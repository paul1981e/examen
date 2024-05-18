import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
        automaticallyImplyLeading: true,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          children: [
            _ModuleBox(
              title: 'Módulo de Proveedores',
              color: Colors.blue,
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'provider');
              },
            ),
            _ModuleBox(
              title: 'Módulo de Categorías',
              color: Colors.green,
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'category');
              },
            ),
            _ModuleBox(
              title: 'Módulo de Productos',
              color: Colors.orange,
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'list');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleBox extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const _ModuleBox({
    required this.title,
    required this.color,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
