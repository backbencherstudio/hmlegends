import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/asset_path.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/manage_branch_model.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/core/route/route_names.dart';

import '../view_model/manage_branch_provider.dart';
import '../widget/branch_list.dart';
import '../widget/manage_branches_card.dart';

class ManageBranchesScreen extends StatefulWidget {
  const ManageBranchesScreen({super.key});

  @override
  State<ManageBranchesScreen> createState() => _ManageBranchesScreenState();
}

class _ManageBranchesScreenState extends State<ManageBranchesScreen> {
  

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ManageBranchProvider>(context, listen: false).allBranch();
    });
  }

  List<Managers> _getFilteredManagers(ManageBranchProvider provider) {
    final allManagers = provider.manageBranchModel?.data?.managers ?? [];

    switch (provider.selectedBranchFilter) {
      case 0: // All branches
        return allManagers;
      case 1: // Active branches
        return allManagers
            .where((manager) => manager.status == "ACTIVE")
            .toList();
      case 2: // Locked branches
        return allManagers
            .where((manager) => manager.status != "ACTIVE")
            .toList();
      default:
        return allManagers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      body: Consumer<ManageBranchProvider>(
        builder: (context, provider, child) {
          final summary = provider.manageBranchModel?.data?.summary;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBarTwo(
                    title: 'Order Summary',
                    notificationCount: 4,
                    profileImage: AssetPaths.personIcon,
                    colorMain: const Color(0xFFFFF5F5),
                    colorSpace: const Color(0xFFFFF5F5),
                    onBackTap: () => Navigator.pop(context),
                  ),

                  SizedBox(height: 16.h),

                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffEFEFEF),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xffFEECEE),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xffFEECEE),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xffFEECEE),
                          width: 1,
                        ),
                      ),
                      hintText: "Search",
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Manage Branches",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.addNewBranchesScreen,
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Add New Branch",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  if (provider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ManageBranchesCard(
                      totalBranches:
                          provider
                              .manageBranchModel
                              ?.data
                              ?.summary
                              ?.totalBranch ??
                          0,
                      activeBranches:
                          provider
                              .manageBranchModel
                              ?.data
                              ?.summary
                              ?.totalActiveBranch ??
                          0,
                      lockedBranches:
                          provider
                              .manageBranchModel
                              ?.data
                              ?.summary
                              ?.totalLockedBranch ??
                          0,
                      selectedIndex: provider.selectedBranchFilter,
                      onCardTap: (index) {
                        provider.setSelectedBranchFilter(index);
                      },
                    ),

                  const SizedBox(height: 20),

                  BranchList(managers: _getFilteredManagers(provider)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
