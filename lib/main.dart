import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Cartas")),
        body: MonthNavigator(),
      ),
    );
  }
}

class MonthNavigator extends StatefulWidget {
  @override
  HeatmapWithImages createState() => HeatmapWithImages();
}

class HeatmapWithImages extends State<MonthNavigator>
    with SingleTickerProviderStateMixin {
  // Datos de ejemplo
  final Map<DateTime, String> inputData = {
    DateTime(2024, 01, 01): 'assets/image1.JPG',
    DateTime(2024, 02, 01): 'assets/image2.jpg',
    DateTime(2024, 03, 01): '',
  };

  // Controlador para la animación
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  DateTime selectedDate = DateTime(2024, 01, 01);

  int getDaysInMonth(int year, int month) {
    // Obtiene el último día del mes
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    return lastDayOfMonth.day;
  }

  // Moverse al mes anterior
  void previousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
    });
  }

  // Moverse al mes siguiente
  void nextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  final months = [
    "Ene",
    "Feb",
    "Mar",
    "Abr",
    "May",
    "Jun",
    "Jul",
    "Ago",
    "Sep",
    "Oct",
    "Nov",
    "Dic",
  ];

  // Obtener nombre del mes
  String _getMonthName(int month) {
    return months[month - 1];
  }

  final years = [2024, 2025];

  @override
  Widget build(BuildContext context) {
    String monthName = _getMonthName(selectedDate.month);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado con el mes y los botones
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: previousMonth,
              ),
              Text(
                "$monthName ${selectedDate.year}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(icon: Icon(Icons.arrow_forward), onPressed: nextMonth),
            ],
          ),
        ),
        // Calendario
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // Días de la semana
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: getDaysInMonth(
              selectedDate.year,
              selectedDate.month,
            ), // Días del mes
            itemBuilder: (context, index) {
              int day = index + 1;
              DateTime date = DateTime(
                selectedDate.year,
                selectedDate.month,
                index + 1,
              );
              String imagePath = inputData[date] ?? '';

              return GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: () {
                  _controller.reverse();
                },
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Card(
                    color:
                        imagePath != '' ? Colors.blue[50] : Colors.grey[200],
                    child:
                        imagePath != ''
                            ? Image.asset(imagePath, fit: BoxFit.cover)
                            : Center(
                              child: Text(
                                "$day",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
