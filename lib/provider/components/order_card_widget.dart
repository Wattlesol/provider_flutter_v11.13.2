import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/order_model.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';

import 'package:nb_utils/nb_utils.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderData order;
  final VoidCallback? onTap;
  final VoidCallback? onUpdateStatus;
  final bool showActions;

  const OrderCardWidget({
    Key? key,
    required this.order,
    this.onTap,
    this.onUpdateStatus,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: appStore.isDarkMode ? cardDarkColor : cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultRadius),
                topRight: Radius.circular(defaultRadius),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderNumber.validate()}',
                        style: boldTextStyle(size: 16),
                      ),
                      4.height,
                      Text(
                        formatDate(order.createdAt.validate()),
                        style: secondaryTextStyle(size: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: boxDecorationDefault(
                    color: _getStatusColor(),
                    borderRadius: radius(20),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: boldTextStyle(color: white, size: 12),
                  ),
                ),
              ],
            ),
          ),

          // Customer Information
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CachedImageWidget(
                      url: order.customerImage.validate(),
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      radius: 20,
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName.validate(),
                            style: boldTextStyle(size: 14),
                          ),
                          4.height,
                          Text(
                            order.customerEmail.validate(),
                            style: secondaryTextStyle(size: 12),
                          ),
                        ],
                      ),
                    ),
                    PriceWidget(
                      price: order.totalAmount.validate(),
                      color: primaryColor,
                      size: 16,
                      isFreeService: order.totalAmount.validate() == 0,
                    ),
                  ],
                ),

                16.height,

                // Order Items Summary
                if (order.orderItems?.isNotEmpty == true) ...[
                  Text(
                    'Items (${order.orderItems!.length}):',
                    style: boldTextStyle(size: 14),
                  ),
                  8.height,
                  ...order.orderItems!
                      .take(3)
                      .map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.productName.validate()}',
                                    style: secondaryTextStyle(size: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  item.totalPriceFormat.validate(),
                                  style: boldTextStyle(size: 12),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  if (order.orderItems!.length > 3)
                    Text(
                      '... and ${order.orderItems!.length - 3} more items',
                      style: secondaryTextStyle(
                          size: 12, fontStyle: FontStyle.italic),
                    ),
                  16.height,
                ],

                // Payment Status
                Row(
                  children: [
                    Icon(
                      order.isPaid ? Icons.check_circle : Icons.pending,
                      color: order.isPaid ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                    8.width,
                    Text(
                      'Payment: ${order.paymentStatus?.toUpperCase() ?? 'UNKNOWN'}',
                      style: secondaryTextStyle(size: 12),
                    ),
                    Spacer(),
                    if (order.paymentMethod.validate().isNotEmpty)
                      Text(
                        order.paymentMethod.validate().toUpperCase(),
                        style: boldTextStyle(size: 12, color: primaryColor),
                      ),
                  ],
                ),

                // Tracking Number (if available)
                if (order.trackingNumber.validate().isNotEmpty) ...[
                  12.height,
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: boxDecorationDefault(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: radius(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping,
                            color: primaryColor, size: 16),
                        8.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tracking Number:',
                                style: boldTextStyle(size: 12),
                              ),
                              Text(
                                order.trackingNumber.validate(),
                                style: secondaryTextStyle(size: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Action Buttons
                if (showActions && order.canUpdateStatus) ...[
                  16.height,
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'View Details',
                          textStyle: boldTextStyle(color: primaryColor),
                          color: primaryColor.withValues(alpha: 0.1),
                          elevation: 0,
                          onTap: onTap,
                        ),
                      ),
                      if (onUpdateStatus != null) ...[
                        12.width,
                        Expanded(
                          child: AppButton(
                            text: 'Update Status',
                            textStyle: boldTextStyle(color: white),
                            color: primaryColor,
                            elevation: 0,
                            onTap: onUpdateStatus,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).onTap(onTap);
  }

  Color _getStatusColor() {
    switch (order.status?.toLowerCase()) {
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

  String _getStatusText() {
    switch (order.status?.toLowerCase()) {
      case 'pending':
        return 'PENDING';
      case 'confirmed':
        return 'CONFIRMED';
      case 'shipped':
        return 'SHIPPED';
      case 'delivered':
        return 'DELIVERED';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return 'UNKNOWN';
    }
  }
}
