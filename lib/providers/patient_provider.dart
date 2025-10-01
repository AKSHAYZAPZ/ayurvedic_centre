import 'package:ayurvedic_centre/ui/widgets/app_button.dart';
import 'package:ayurvedic_centre/ui/widgets/app_drop_down_field.dart';
import 'package:ayurvedic_centre/ui/widgets/app_text_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/datasources/api_service.dart';
import '../data/models/branch.dart';
import '../data/models/treatment.dart';
import '../repositories/patient_repository.dart';
import '../ui/widgets/pdf_generator.dart';
import 'home_provider.dart';

class PatientProvider extends ChangeNotifier {
  final PatientRepository repository;

  bool loading = false;
  bool buttonLoading = false;

  List<Branch> branches = [];
  List<Treatment> treatments = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController advanceController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  TextEditingController treatmentDateController = TextEditingController();
  TextEditingController treatmentHourController = TextEditingController();
  TextEditingController treatmentMinuteController = TextEditingController();

  String? selectedLocation;
  String selectedBranchId = '';
  String paymentMethod = 'cash';
  DateTime? treatmentDate;
  TimeOfDay? treatmentTime;

  final List<String> staticLocations = [
    'Location A',
    'Location B',
    'Location C'
  ];

  final List<Map<String, dynamic>> treatmentsList = [];

  PatientProvider({PatientRepository? repo})
      : repository = repo ?? PatientRepository(ApiService()) {
    initControllers(); // your function to init controllers
  }

  void initControllers() {
    totalController.addListener(_updateBalance);
    discountController.addListener(_updateBalance);
    advanceController.addListener(_updateBalance);
    selectedLocation = null;
    selectedBranchId = '';
    paymentMethod = 'cash';
    treatmentDate = null;
    treatmentTime = null;
    treatmentsList.clear();
  }

  void _updateBalance() {
    final total = double.tryParse(totalController.text) ?? 0;
    final discount = double.tryParse(discountController.text) ?? 0;
    final advance = double.tryParse(advanceController.text) ?? 0;
    balanceController.text = (total - discount - advance).toStringAsFixed(2);
    notifyListeners();
  }

  void setPaymentMethod(String? method) {
    if (method != null) {
      paymentMethod = method;
      notifyListeners();
    }
  }

  void setSelectedLocation(String? location) {
    if (location != null) {
      selectedLocation = location;
      notifyListeners();
    }
  }

  void setSelectedBranch(String? branchId) {
    if (branchId != null) {
      selectedBranchId = branchId;
      notifyListeners();
    }
  }

  String? get safeSelectedLocation =>
      staticLocations.contains(selectedLocation) ? selectedLocation : null;

  String? get safeSelectedBranch =>
      branches.any((b) => b.id == selectedBranchId) ? selectedBranchId : null;

  Future<void> pickTreatmentDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: treatmentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      treatmentDate = date;
      treatmentDateController.text = DateFormat('dd/MM/yyyy').format(date);
      notifyListeners();
    }
  }

  void setTreatmentHour(String value) {
    treatmentHourController.text = value;
    notifyListeners();
  }

  void setTreatmentMinute(String value) {
    treatmentMinuteController.text = value;
    notifyListeners();
  }

  void openTreatmentDialog(BuildContext context,
      {Map<String, dynamic>? editItem}) {
    String? selectedTreatmentId;
    final maleController =
        TextEditingController(text: editItem?['male']?.toString() ?? '');
    final femaleController =
        TextEditingController(text: editItem?['female']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(editItem != null ? 'Edit Treatment' : 'Add Treatment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                    child: AppDropdownField(
                  value: selectedTreatmentId,
                  items: treatments
                      .map((t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(t.name),
                          ))
                      .toList(),
                  hintText: "Treatment",
                  onChanged: (v) {
                    if (v != null) selectedTreatmentId = v;
                  },
                )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            AppTextFormField(
              controller: maleController,
              keyboardType: TextInputType.number,
              hintText: 'Males',
            ),
            SizedBox(
              height: 10,
            ),
            AppTextFormField(
              controller: femaleController,
              keyboardType: TextInputType.number,
              hintText: 'Females',
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          AppButton(
            text: "Save",
            width: 100,
            onTap: () {
              if (selectedTreatmentId == null) return;

              final selectedTreatment =
                  treatments.firstWhere((t) => t.id == selectedTreatmentId);
              final male = int.tryParse(maleController.text) ?? 0;
              final female = int.tryParse(femaleController.text) ?? 0;

              double price = 0.0;
              if (selectedTreatment.price != null) {
                if (selectedTreatment.price is num) {
                  price = (selectedTreatment.price as num).toDouble();
                } else if (selectedTreatment.price is String) {
                  price = double.tryParse(selectedTreatment.price) ?? 0.0;
                }
              }

              final total = male * price + female * price;

              final newTreatment = {
                'id': selectedTreatment.id,
                'name': selectedTreatment.name,
                'price': selectedTreatment.price,
                'male': male,
                'female': female,
                'total': total,
              };

              if (editItem != null) {
                final index = treatmentsList.indexOf(editItem);
                treatmentsList[index] = newTreatment;
              } else {
                treatmentsList.add(newTreatment);
              }

              notifyListeners();
              Navigator.pop(ctx);
            },
          )
        ],
      ),
    );
  }

  void removeTreatment(Map<String, dynamic> treatment) {
    treatmentsList.remove(treatment);
    notifyListeners();
  }

  Future<void> loadBranchesAndTreatments() async {
    loading = true;
    notifyListeners();

    try {
      branches = await repository.apiService.fetchBranches();
      treatments = await repository.apiService.fetchTreatments();
    } catch (e) {
      print('Error loading branches or treatments: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addOrUpdatePatient(BuildContext context) async {
    try {
      buttonLoading = true;
      notifyListeners();
      final total = int.tryParse(totalController.text) ?? 0;
      final discount = int.tryParse(discountController.text) ?? 0;
      final advance = int.tryParse(advanceController.text) ?? 0;
      final balance = total - discount - advance;

      final treatmentIds =
          treatmentsList.map((t) => t['id'].toString()).join(',');
      final maleCounts =
          treatmentsList.map((t) => t['male'].toString()).join(',');
      final femaleCounts =
          treatmentsList.map((t) => t['female'].toString()).join(',');

      final fields = {
        'name': nameController.text,
        'excecutive': '',
        'payment': paymentMethod,
        'phone': phoneController.text,
        'address': addressController.text,
        'total_amount': total.toString(),
        'discount_amount': discount.toString(),
        'advance_amount': advance.toString(),
        'balance_amount': balance.toString(),
        'date_nd_time': DateFormat('dd/MM/yyyy-hh:mm a').format(DateTime.now()),
        'id': '',
        'male': maleCounts,
        'female': femaleCounts,
        'branch': selectedBranchId,
        'treatments': treatmentIds,
      };
      final branchName = selectedBranchId.isEmpty
          ? 'KUMARAKOM'
          : branches.firstWhere((b) => b.id == selectedBranchId).name;
      print(fields);
      await repository.addOrUpdatePatient(fields);
      await PdfGenerator.generatePatientPdf(
          fields, treatmentsList, nameController.text,
          branchName: branchName);
      Navigator.of(context).pop();
      final homeProvider = context.read<HomeProvider>();
      await homeProvider.loadPatients();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      buttonLoading = false;
      notifyListeners();
    }
  }

  bool areAllRequiredFieldsFilled() {
    if (nameController.text.trim().isEmpty) return false;
    if (phoneController.text.trim().isEmpty) return false;
    if (addressController.text.trim().isEmpty) return false;
    if (totalController.text.trim().isEmpty) return false;
    if (discountController.text.trim().isEmpty) return false;
    if (advanceController.text.trim().isEmpty) return false;
    if (treatmentDateController.text.trim().isEmpty) return false;
    if (treatmentHourController.text.trim().isEmpty) return false;
    if (treatmentMinuteController.text.trim().isEmpty) return false;
    if (selectedLocation == null) return false;
    if (selectedBranchId.isEmpty) return false;

    if (treatmentsList.isEmpty) return false;

    return true;
  }

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    totalController.clear();
    discountController.clear();
    advanceController.clear();
    balanceController.clear();
    treatmentDateController.clear();
    treatmentHourController.clear();
    treatmentMinuteController.clear();

    selectedLocation = null;
    selectedBranchId = '';
    paymentMethod = 'cash';
    treatmentDate = null;
    treatmentTime = null;

    treatmentsList.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    resetForm();
    super.dispose();
  }
}
