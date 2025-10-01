import 'package:ayurvedic_centre/core/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/patient.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final int count;
  const PatientCard({super.key, required this.patient, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstants.cardColor,
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 8,
                right: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$count.",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " ${patient.name}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        patient.details.isEmpty
                            ? SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 2, bottom: 5),
                                child: Text(
                                  patient.details
                                      .map((d) => d.treatmentName ?? '')
                                      .join(', '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    color: ColorConstants.green,
                                  ),
                                ),
                              ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  formatDateSafe(patient.dateTime),
                                  style: const TextStyle(
                                    color: ColorConstants.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.group_outlined,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  patient.name,
                                  style: const TextStyle(
                                    color: ColorConstants.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.07,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Booking details',
                        style: TextStyle(
                          color: ColorConstants.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: ColorConstants.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String formatDateSafe(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return '-';
  try {
    final dt = DateTime.tryParse(dateStr);
    if (dt != null) {
      return DateFormat('dd/MMM/yyyy').format(dt);
    } else {
      return dateStr;
    }
  } catch (_) {
    return dateStr;
  }
}
