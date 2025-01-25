import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionWidget extends StatelessWidget {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  const NutritionWidget({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Diagram',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: _buildPieChartSections(),
              centerSpaceRadius: 40,
              sectionsSpace: 4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Kalori: $calories kcal',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Protein: $protein g',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Karbohidrat: $carbs g',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Lemak: $fat g',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final total = protein + carbs + fat;
    return [
      PieChartSectionData(
        color: Colors.green[400],
        value: (protein / total) * 100,
        title: 'Protein',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.blue[400],
        value: (carbs / total) * 100,
        title: 'Karbo',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red[400],
        value: (fat / total) * 100,
        title: 'Lemak',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }
}
