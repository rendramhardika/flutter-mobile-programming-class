import 'package:flutter/material.dart';
import '../models/air_quality_model.dart';

class AqiCard extends StatelessWidget {
  final AirQualityModel airQuality;

  const AqiCard({super.key, required this.airQuality});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.air,
                  color: airQuality.qualityColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Kualitas Udara',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // AQI Value and Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // AQI Circle
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: airQuality.qualityColor.withOpacity(0.1),
                    border: Border.all(
                      color: airQuality.qualityColor,
                      width: 4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${airQuality.aqi}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: airQuality.qualityColor,
                        ),
                      ),
                      Text(
                        'AQI',
                        style: TextStyle(
                          fontSize: 12,
                          color: airQuality.qualityColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                
                // Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            airQuality.qualityIcon,
                            color: airQuality.qualityColor,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              airQuality.qualityLevel,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: airQuality.qualityColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        airQuality.healthImplication,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Pollutants
            if (airQuality.pm25 != null || airQuality.pm10 != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Polutan Utama',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (airQuality.pm25 != null)
                          Expanded(
                            child: _buildPollutantItem(
                              'PM2.5',
                              '${airQuality.pm25!.toStringAsFixed(1)} µg/m³',
                            ),
                          ),
                        if (airQuality.pm25 != null && airQuality.pm10 != null)
                          const SizedBox(width: 16),
                        if (airQuality.pm10 != null)
                          Expanded(
                            child: _buildPollutantItem(
                              'PM10',
                              '${airQuality.pm10!.toStringAsFixed(1)} µg/m³',
                            ),
                          ),
                      ],
                    ),
                    if (airQuality.o3 != null || airQuality.no2 != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (airQuality.o3 != null)
                            Expanded(
                              child: _buildPollutantItem(
                                'O₃',
                                '${airQuality.o3!.toStringAsFixed(1)} µg/m³',
                              ),
                            ),
                          if (airQuality.o3 != null && airQuality.no2 != null)
                            const SizedBox(width: 16),
                          if (airQuality.no2 != null)
                            Expanded(
                              child: _buildPollutantItem(
                                'NO₂',
                                '${airQuality.no2!.toStringAsFixed(1)} µg/m³',
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollutantItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
