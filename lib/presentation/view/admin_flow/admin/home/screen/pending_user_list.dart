import 'package:flutter/material.dart';
import 'package:hmlegends/presentation/view/admin_flow/view_model/home/home_screen_provider.dart';
import 'package:provider/provider.dart';

class PendingUserList extends StatelessWidget {
  const PendingUserList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeScreenProvider>(context);
    final pendingData = homeProvider.pendingUserModel?.data?.users ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Pending Approvals")),
      body:
          pendingData.isEmpty
              ? const Center(child: Text("No Pending Approvals"))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: pendingData.length,
                      itemBuilder: (context, index) {
                        final user = pendingData[index];

                        final bool isThisButtonLoading =
                            homeProvider.loadingUserId == user.id;

                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name ?? "No Name",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(user.email ?? "No Email"),
                                  Text("Type: ${user.type}"),
                                  Text("Status: ${user.approvedBy}"),
                                ],
                              ),

                              // Buttons Column
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        isThisButtonLoading
                                            ? null
                                            : () async {
                                              await homeProvider.acceptRequest(
                                                user.id ?? "",
                                                "APPROVED",
                                              );

                                              if (!context.mounted) return;

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "${user.name} approved",
                                                  ),
                                                ),
                                              );
                                            },
                                    child:
                                        isThisButtonLoading
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                            : const Text("Accept"),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        isThisButtonLoading
                                            ? null
                                            : () async {
                                              await homeProvider.acceptRequest(
                                                user.id ?? "",
                                                "REJECTED",
                                              );

                                              if (!context.mounted) return;

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "${user.name} rejected",
                                                  ),
                                                ),
                                              );
                                            },
                                    child:
                                        isThisButtonLoading
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                            : const Text(
                                              "Reject",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
