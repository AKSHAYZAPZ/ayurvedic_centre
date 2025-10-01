import 'package:ayurvedic_centre/ui/widgets/app_button.dart';
import 'package:ayurvedic_centre/ui/widgets/app_text_formfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/color_constants.dart';
import '../../providers/home_provider.dart';
import '../widgets/empty_list_widget.dart';
import '../widgets/patient_card.dart';
import 'patient_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      if (provider.patients.isEmpty) {
        provider.loadPatients();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
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

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
        child: AppButton(
          text: "Register Now",
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => PatientFormScreen()))
              .then((_) {}),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RefreshIndicator(
          onRefresh: () => context.read<HomeProvider>().refreshPatients(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: AppTextFormField(
                        controller: provider.searchController,
                        hintText: 'Search patients',
                        fillColor: ColorConstants.white,
                        suffixIcon: Icon(Icons.search, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorConstants.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Text(
                        'Search',
                        style: TextStyle(color: ColorConstants.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: Row(
                        children: [
                          Text(
                            'Sort by :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: ColorConstants.grey.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                      child: Row(
                        children: [
                          Text('Date',style: TextStyle(color: ColorConstants.grey,fontSize: 15,),),
                          SizedBox(
                            width: 50,
                          ),
                          Icon(Icons.keyboard_arrow_down,size: 18,color: ColorConstants.green,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              provider.loading
                  ? Expanded(
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.green,
                        ),
                      ),
                    )
                  : provider.patients.isEmpty
                  ? ListView(children: const [EmptyListWidget()])
                  : Expanded(
                      child: ListView.builder(
                        itemCount: provider.patients.length,
                        itemBuilder: (_, i) => PatientCard(
                          patient: provider.patients[i],
                          count: i + 1,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
