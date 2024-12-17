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

class HeatmapWithImages extends State<MonthNavigator> {
  // Datos de ejemplo
  final Map<DateTime, String> inputData = {
    DateTime(2024, 01, 01): 'assets/image1.JPG',
    DateTime(2024, 02, 01): 'assets/image2.jpg',
    DateTime(2024, 03, 01): '',
  };

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

              return AnimatedCard(day: day, imagePath: imagePath);
            },
          ),
        ),
      ],
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final int day;
  final String? imagePath;

  const AnimatedCard({required this.day, this.imagePath});

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  bool isFront = true; // Indica si estamos viendo el frente del Card

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.00,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCard() {
    if (isFront) {
      _controller.forward(); // Gira hacia atrás
    } else {
      _controller.reverse(); // Gira hacia el frente
    }
    setState(() {
      isFront = !isFront; // Cambia el estado (frente o reverso)
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          final angle = _rotationAnimation.value * 3.14159265359; // π radianes

          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspectiva
                  ..rotateY(angle),
            child:
                angle >
                        1.5708 // Mayor a 90°: mostrar el reverso
                    ? _buildBackCard()
                    : _buildFrontCard(),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Card(
      color: widget.imagePath != '' ? Colors.blue[100] : Colors.grey[300],
      child:
          widget.imagePath != ''
              ? Image.asset(widget.imagePath!, fit: BoxFit.cover)
              : Center(
                child: Text("${widget.day}", style: TextStyle(fontSize: 16)),
              ),
    );
  }

  Widget _buildBackCard() {
    return Card(
      color: Colors.white,
      child: Center(
        child: Text("Te amo como a los esquites", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
