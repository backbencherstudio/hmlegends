import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/presentation/view/admin_flow/admin/manage_branches/model/manage_branch_model.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/notification_admin/admin_notification_provider.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/profile/change_pass_provider.dart';
import 'package:hmlegends/presentation/view/widget/custom_app_bar_2.dart';
import 'package:provider/provider.dart';
import 'package:hmlegends/core/route/route_names.dart';
import '../../widget/search_filter.dart';
import '../view_model/manage_branch_provider.dart';
import '../widget/manage_branches_card.dart';
import 'package:hmlegends/core/utlis/utils.dart';

class ManageBranchesScreen extends StatefulWidget {
  const ManageBranchesScreen({super.key});

  @override
  State<ManageBranchesScreen> createState() => _ManageBranchesScreenState();
}

class _ManageBranchesScreenState extends State<ManageBranchesScreen> {
  String? _togglingBranchId;

  Widget _buildAvatarImage(String? avatar) {
    if (avatar == null || avatar.isEmpty) {
      return const Icon(Icons.person, size: 40);
    }
    final String fullAvatarUrl =
        avatar.startsWith('http')
            ? avatar
            : (avatar.startsWith('/')
                ? "${ApiEndpoints.baseUrl}$avatar"
                : "${ApiEndpoints.baseUrl}/storage/avatar/$avatar");
    return Image.network(
      fullAvatarUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder:
          (context, error, stackTrace) => const Icon(Icons.person, size: 40),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider =
      // ignore: use_build_context_synchronously
      Provider.of<ManageBranchProvider>(context, listen: false);
      provider.allBranch();
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

  List<Data> managersData = [];
  Timer? debouncer;

  List<Managers> _applyQueryFilter(List<Managers> managers) {
    if (context.read<ManageBranchProvider>().query.trim().isEmpty) {
      return managers;
    }
    final q = context.read<ManageBranchProvider>().query.trim().toLowerCase();
    return managers.where((manager) {
      final name = manager.name ?? '';
      return name.contains(q);
    }).toList();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<AdminNotificationProvider>(
      context,
    );
    final notification = notificationProvider.adminNotificationModel?.data;
    final profileProvider = Provider.of<ChangePasswordProvider>(context);
    final data = profileProvider.adminInfoModel?.data;

    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      body: Consumer<ManageBranchProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                CustomAppBarTwo(
                  title: 'Manage Branches',
                  notificationCount: notification?.length ?? 0,
                  profileImage: '${data?.avatar}',
                  colorMain: const Color(0xFFFFF5F5),
                  colorSpace: const Color(0xFFFFF5F5),
                  onBackTap: () => Navigator.pop(context),
                ),

                SizedBox(height: 16.h),

                ///------------------ Search Field ----------------------------------
                SearchField(
                  hintText: 'Search by manager name',
                  text: context.read<ManageBranchProvider>().query,
                  onChanged: (String value) {
                    debounce(() {
                      if (!mounted) return;
                      context.read<ManageBranchProvider>().setQuery(value);
                    });
                  },
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

                /// 🔥 Fixed: Removed Expanded and used flexible ListView
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount:
                        _applyQueryFilter(
                          _getFilteredManagers(provider),
                        ).length,
                    itemBuilder: (context, index) {
                      final filteredManagers = _applyQueryFilter(
                        _getFilteredManagers(provider),
                      );
                      final items = filteredManagers[index];
                      final bool isActive = items.status == "ACTIVE";

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(9.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Container(
                                      height: 80.h,
                                      width: 80.w,
                                      color: Colors.grey.shade200,
                                      child: _buildAvatarImage(items.avatar),
                                    ),
                                  ),

                                  SizedBox(width: 12.w),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                items.name ?? "N/A",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isActive
                                                        ? const Color(
                                                          0xffDEF0DC,
                                                        )
                                                        : const Color(
                                                          0xffFCE6E7,
                                                        ),
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                              ),
                                              child: Text(
                                                isActive ? "Active" : "Locked",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color:
                                                      isActive
                                                          ? const Color(
                                                            0xff5BB450,
                                                          )
                                                          : Colors.red,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 6.h),

                                        /// Location Row (Exact same layout)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 18.sp,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 6.w),
                                            Expanded(
                                              child: Text(
                                                items.address ??
                                                    "No address available",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 15.h),

                              /// 🔥 Bottom Action Buttons (Restored exactly)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      debugPrint("THe userIUD : ${items.id}");

                                      Navigator.pushNamed(
                                        context,
                                        RouteNames
                                            .manageBranchesToOrderSummaryScreen,
                                        arguments: items.id,
                                      );
                                    },
                                    child: _actionButton(
                                      Icons.file_present_rounded,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      debugPrint(
                                        "THe Edit Manager ID : ${items.id}",
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.editBranchScreen,
                                        arguments: items.id,
                                      );
                                    },
                                    child: _actionButton(Icons.edit),
                                  ),
                                  GestureDetector(
                                    onTap: _togglingBranchId != null || items.id == null
                                        ? null
                                        : () async {
                                            setState(() {
                                              _togglingBranchId = items.id;
                                            });
                                            try {
                                              final res = await provider.toggleBranch(items.id!);
                                              if (res != null && res["success"] == true) {
                                                Utils.showToast(
                                                  msg: res["message"] ?? "Status updated successfully",
                                                  backgroundColor: Colors.green,
                                                  textColor: Colors.white,
                                                );
                                              } else {
                                                Utils.showToast(
                                                  msg: res != null ? res["message"] ?? "Failed to update status" : "Failed to update status",
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                );
                                              }
                                            } catch (e) {
                                              debugPrint("Error toggling status: $e");
                                              Utils.showToast(
                                                msg: "An error occurred",
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                              );
                                            } finally {
                                              if (mounted) {
                                                setState(() {
                                                  _togglingBranchId = null;
                                                });
                                              }
                                            }
                                          },
                                    child: _actionButton(
                                      items.id != null && _togglingBranchId == items.id
                                          ? null
                                          : (isActive
                                              ? Icons.lock_open
                                              : Icons.lock_outline),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton(IconData? icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xffFCE6E7),
        shape: BoxShape.circle,
      ),
      child: icon == null
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          : Icon(icon, color: Colors.red),
    );
  }
}
