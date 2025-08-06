import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/view_all_label_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/order_model.dart';
import 'package:handyman_provider_flutter/provider/components/order_card_widget.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class OrderListComponent extends StatelessWidget {
  final List<OrderData> orders;
  final String title;
  final String? subtitle;
  final VoidCallback? onViewAll;
  final Function(OrderData)? onOrderTap;
  final Function(OrderData)? onUpdateStatus;
  final bool showActions;
  final int maxItems;

  const OrderListComponent({
    Key? key,
    required this.orders,
    this.title = 'Orders',
    this.subtitle,
    this.onViewAll,
    this.onOrderTap,
    this.onUpdateStatus,
    this.showActions = true,
    this.maxItems = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return Offstage();

    return Container(
      color: context.cardColor,
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onViewAll != null)
            ViewAllLabel(
              label: title,
              subLabel: subtitle ?? '${orders.length} orders',
              list: orders,
              onTap: onViewAll,
            )
          else
            Text(
              title,
              style: boldTextStyle(size: 18),
            ),
          
          16.height,
          
          Stack(
            children: [
              // List of Orders
              Column(
                children: List.generate(
                  orders.take(maxItems).length,
                  (index) {
                    final order = orders[index];
                    return OrderCardWidget(
                      order: order,
                      showActions: showActions,
                      onTap: onOrderTap != null ? () => onOrderTap!(order) : null,
                      onUpdateStatus: onUpdateStatus != null ? () => onUpdateStatus!(order) : null,
                    );
                  },
                ),
              ),
              
              // Empty State
              Observer(
                builder: (context) => NoDataWidget(
                  title: 'No Orders Yet',
                  subTitle: 'Orders for your products will appear here.',
                  imageWidget: EmptyStateWidget(),
                ).visible(!appStore.isLoading && orders.isEmpty),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderStatusWidget extends StatelessWidget {
  final String status;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const OrderStatusWidget({
    Key? key,
    required this.status,
    required this.count,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count.toString(),
                style: boldTextStyle(color: color, size: 24),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.2),
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
          8.height,
          Text(
            status,
            style: boldTextStyle(color: color, size: 14),
          ),
        ],
      ),
    ).onTap(onTap);
  }

  IconData _getStatusIcon() {
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
      case 'total':
        return Icons.shopping_cart;
      default:
        return Icons.help;
    }
  }
}

class OrderStatsComponent extends StatelessWidget {
  final int totalOrders;
  final int pendingOrders;
  final int confirmedOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final String? totalRevenue;
  final Function(String)? onStatusTap;

  const OrderStatsComponent({
    Key? key,
    required this.totalOrders,
    required this.pendingOrders,
    required this.confirmedOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    this.totalRevenue,
    this.onStatusTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cardColor,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Overview',
                style: boldTextStyle(size: 18),
              ),
              if (totalRevenue != null)
                Text(
                  totalRevenue!,
                  style: boldTextStyle(color: primaryColor, size: 16),
                ),
            ],
          ),
          16.height,
          
          // First Row
          Row(
            children: [
              Expanded(
                child: OrderStatusWidget(
                  status: 'Total',
                  count: totalOrders,
                  color: primaryColor,
                  onTap: onStatusTap != null ? () => onStatusTap!('all') : null,
                ),
              ),
              12.width,
              Expanded(
                child: OrderStatusWidget(
                  status: 'Pending',
                  count: pendingOrders,
                  color: Colors.orangeAccent,
                  onTap: onStatusTap != null ? () => onStatusTap!('pending') : null,
                ),
              ),
            ],
          ),
          12.height,
          
          // Second Row
          Row(
            children: [
              Expanded(
                child: OrderStatusWidget(
                  status: 'Confirmed',
                  count: confirmedOrders,
                  color: blueColor,
                  onTap: onStatusTap != null ? () => onStatusTap!('confirmed') : null,
                ),
              ),
              12.width,
              Expanded(
                child: OrderStatusWidget(
                  status: 'Shipped',
                  count: shippedOrders,
                  color: primaryColor,
                  onTap: onStatusTap != null ? () => onStatusTap!('shipped') : null,
                ),
              ),
            ],
          ),
          12.height,
          
          // Third Row
          Row(
            children: [
              Expanded(
                child: OrderStatusWidget(
                  status: 'Delivered',
                  count: deliveredOrders,
                  color: greenColor,
                  onTap: onStatusTap != null ? () => onStatusTap!('delivered') : null,
                ),
              ),
              12.width,
              Expanded(
                child: OrderStatusWidget(
                  status: 'Cancelled',
                  count: cancelledOrders,
                  color: redColor,
                  onTap: onStatusTap != null ? () => onStatusTap!('cancelled') : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
