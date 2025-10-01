import 'package:ayurvedic_centre/core/color_constants.dart';
import 'package:ayurvedic_centre/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/patient_provider.dart';
import '../widgets/app_drop_down_field.dart';
import '../widgets/app_text_formfield.dart';

class PatientFormScreen extends StatefulWidget {
  PatientFormScreen({super.key});

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  late PatientProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<PatientProvider>();
    provider.initControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadBranchesAndTreatments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined, size: 28),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        scrolledUnderElevation: 0.0,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  Text("Name"),
                  SizedBox(
                    height: 5,
                  ),
                  AppTextFormField(
                    controller: provider.nameController,
                    hintText: 'Enter your full name',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("WhatsApp Number"),
                  SizedBox(
                    height: 5,
                  ),
                  AppTextFormField(
                    controller: provider.phoneController,
                    hintText: 'Enter your whatsapp number',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Address"),
                  SizedBox(
                    height: 5,
                  ),
                  AppTextFormField(
                    controller: provider.addressController,
                    hintText: 'Enter your full address',
                  ),
                  const SizedBox(height: 12),
                  Text("Location"),
                  SizedBox(
                    height: 5,
                  ),
                  AppDropdownField<String>(
                    value: provider.selectedLocation,
                    items: provider.staticLocations
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: provider.setSelectedLocation,
                    hintText: 'Choose your location',
                  ),
                  const SizedBox(height: 12),
                  Text("Branch"),
                  SizedBox(
                    height: 5,
                  ),
                  AppDropdownField<String>(
                    value: provider.selectedBranchId != null &&
                            provider.branches
                                .any((b) => b.id == provider.selectedBranchId)
                        ? provider.selectedBranchId
                        : null,
                    items: provider.branches
                        .map((b) =>
                            DropdownMenuItem(value: b.id, child: Text(b.name)))
                        .toList(),
                    onChanged: provider.setSelectedBranch,
                    hintText: 'Select the branch',
                  ),
                  const SizedBox(height: 12),
                  Text("Total Amount"),
                  SizedBox(
                    height: 5,
                  ),
                  AppTextFormField(
                    controller: provider.totalController,
                    hintText: '',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  const Text('Treatments'),
                  const SizedBox(height: 6),
                  Column(
                    children:
                        provider.treatmentsList.asMap().entries.map((entry) {
                      int idx = entry.key + 1;
                      var t = entry.value;
                      return TreatmentCard(
                        index: idx,
                        patientName: t['name'] ?? '',
                        maleCount: t['male'] ?? 0,
                        femaleCount: t['female'] ?? 0,
                        onEdit: () =>
                            provider.openTreatmentDialog(context, editItem: t),
                        onDelete: () => provider.removeTreatment(t),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 8),
                  AppButton(
                    text: "Add Treatment",
                    color: ColorConstants.lightGreen,
                    onTap: () => provider.openTreatmentDialog(context),
                  ),
                  const SizedBox(height: 20),

                  Text("Discount Amount"),
                  SizedBox(
                    height: 5,
                  ),
                  AppTextFormField(
                    controller: provider.discountController,
                    hintText: '',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  const Text('Payment Options'),
                  Row(
                    children: ['cash', 'card', 'upi'].map((method) {
                      return Row(
                        children: [
                          Radio<String>(
                            value: method,
                            groupValue: provider.paymentMethod,
                            onChanged: provider.setPaymentMethod,
                            activeColor: ColorConstants.green,
                          ),
                          Text(method.toUpperCase()),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text("Advance Amount"),
                  SizedBox(
                    height: 5,
                  ),
                  AppTextFormField(
                    controller: provider.advanceController,
                    hintText: '',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  Text("Balance Amount"),
                  SizedBox(
                    height: 5,
                  ),
                  AppTextFormField(
                    controller: provider.balanceController,
                    hintText: '',
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),

                  // --- Treatment Date & Time ---
                  Text("Treatment Date"),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () => provider.pickTreatmentDate(context),
                    child: AbsorbPointer(
                      child: AppTextFormField(
                        controller: provider.treatmentDateController,
                        hintText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Treatment Time"),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          controller: provider.treatmentHourController,
                          hintText: 'Hour (HH)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextFormField(
                          controller: provider.treatmentMinuteController,
                          hintText: 'Minute (MM)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  provider.buttonLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AppButton(
                          text: "Save",
                          onTap: () async {
                            if (!provider.areAllRequiredFieldsFilled()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Please fill all the fields")),
                              );
                              return; // stop execution
                            }

                            await provider.addOrUpdatePatient(context);
                          },
                        ),
                ],
              ),
            ),
    );
  }
}

class TreatmentCard extends StatelessWidget {
  final String patientName;
  final int maleCount;
  final int femaleCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index; // optional for numbering

  const TreatmentCard({
    super.key,
    required this.patientName,
    required this.maleCount,
    required this.femaleCount,
    required this.onEdit,
    required this.onDelete,
    this.index = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$index.",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        patientName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(width: 1),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Male',
                                style: TextStyle(color: ColorConstants.green),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: ColorConstants.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 12),
                                  child: Text('$maleCount'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Female
                          Row(
                            children: [
                              Text(
                                'Female',
                                style: TextStyle(color: ColorConstants.green),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: ColorConstants.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 12),
                                  child: Text('$femaleCount'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: onDelete,
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onEdit,
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: ColorConstants.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

