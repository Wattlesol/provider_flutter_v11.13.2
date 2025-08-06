import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/order_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';

import 'package:nb_utils/nb_utils.dart';

class UpdateOrderStatusScreen extends StatefulWidget {
  final OrderData order;

  UpdateOrderStatusScreen({required this.order});

  @override
  _UpdateOrderStatusScreenState createState() =>
      _UpdateOrderStatusScreenState();
}

class _UpdateOrderStatusScreenState extends State<UpdateOrderStatusScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController notesController = TextEditingController();
  TextEditingController trackingController = TextEditingController();

  FocusNode notesFocus = FocusNode();
  FocusNode trackingFocus = FocusNode();

  List<String> availableStatuses = [];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setupAvailableStatuses();

    // Pre-fill existing data
    notesController.text = widget.order.notes.validate();
    trackingController.text = widget.order.trackingNumber.validate();
  }

  void setupAvailableStatuses() {
    // Define status progression
    Map<String, List<String>> statusProgression = {
      'pending': ['confirmed', 'cancelled'],
      'confirmed': ['shipped', 'cancelled'],
      'shipped': ['delivered'],
      'delivered': [], // Final status
      'cancelled': [], // Final status
    };

    String currentStatus = widget.order.status?.toLowerCase() ?? 'pending';
    availableStatuses = statusProgression[currentStatus] ?? [];

    if (availableStatuses.isNotEmpty) {
      selectedStatus = availableStatuses.first;
    }

    setState(() {});
  }

  Future<void> updateStatus() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedStatus == null) {
      toast('Please select a status');
      return;
    }

    appStore.setLoading(true);

    await updateOrderStatus(
      orderId: widget.order.id.validate(),
      status: selectedStatus!,
      notes: notesController.text.trim().isNotEmpty
          ? notesController.text.trim()
          : null,
      trackingNumber: trackingController.text.trim().isNotEmpty
          ? trackingController.text.trim()
          : null,
    ).then((value) {
      appStore.setLoading(false);
      toast('Order status updated successfully');
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return primaryColor;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.capitalizeFirstLetter();
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'confirmed':
        return Icons.check_circle;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Update Order Status',
      actions: [
        TextButton(
          onPressed: updateStatus,
          child: Text(
            'Update',
            style: boldTextStyle(color: white),
          ),
        ),
      ],
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: AnimatedScrollView(
              padding: EdgeInsets.all(16),
              children: [
                // Current Order Info
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: context.cardColor,
                    borderRadius: radius(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Information', style: boldTextStyle()),
                      16.height,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order #${widget.order.orderNumber.validate()}',
                                  style: boldTextStyle(size: 16),
                                ),
                                4.height,
                                Text(
                                  'Customer: ${widget.order.customerName.validate()}',
                                  style: secondaryTextStyle(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: boxDecorationDefault(
                              color: _getStatusColor(
                                  widget.order.status.validate()),
                              borderRadius: radius(20),
                            ),
                            child: Text(
                              _getStatusDisplayName(
                                  widget.order.status.validate()),
                              style: boldTextStyle(color: white, size: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                24.height,

                // Status Selection
                if (availableStatuses.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: context.cardColor,
                      borderRadius: radius(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Update Status To:', style: boldTextStyle()),
                        16.height,
                        ...availableStatuses.map((status) {
                          bool isSelected = selectedStatus == status;

                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () {
                                selectedStatus = status;
                                setState(() {});
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: boxDecorationDefault(
                                  color: isSelected
                                      ? _getStatusColor(status)
                                          .withValues(alpha: 0.1)
                                      : context.scaffoldBackgroundColor,
                                  borderRadius: radius(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? _getStatusColor(status)
                                        : borderColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getStatusIcon(status),
                                      color: _getStatusColor(status),
                                      size: 24,
                                    ),
                                    16.width,
                                    Expanded(
                                      child: Text(
                                        _getStatusDisplayName(status),
                                        style: boldTextStyle(
                                          color: isSelected
                                              ? _getStatusColor(status)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: _getStatusColor(status),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  24.height,
                ],

                // Additional Information
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: context.cardColor,
                    borderRadius: radius(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Additional Information', style: boldTextStyle()),
                      16.height,

                      // Tracking Number (for shipped status)
                      if (selectedStatus == 'shipped') ...[
                        AppTextField(
                          controller: trackingController,
                          focus: trackingFocus,
                          nextFocus: notesFocus,
                          textFieldType: TextFieldType.OTHER,
                          decoration: inputDecoration(
                            context,
                            hint: 'Tracking Number',
                            fillColor: context.scaffoldBackgroundColor,
                          ),
                          validator: (value) {
                            if (selectedStatus == 'shipped' &&
                                value.validate().isEmpty) {
                              return 'Tracking number is required for shipped orders';
                            }
                            return null;
                          },
                        ),
                        16.height,
                      ],

                      // Notes
                      AppTextField(
                        controller: notesController,
                        focus: notesFocus,
                        textFieldType: TextFieldType.MULTILINE,
                        maxLines: 3,
                        decoration: inputDecoration(
                          context,
                          hint: 'Notes (optional)',
                          fillColor: context.scaffoldBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),

                24.height,

                // Update Button
                AppButton(
                  text: 'Update Order Status',
                  color: primaryColor,
                  textStyle: boldTextStyle(color: white),
                  width: context.width(),
                  onTap: updateStatus,
                ),
              ],
            ),
          ),
          Observer(
            builder: (context) =>
                LoaderWidget().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
