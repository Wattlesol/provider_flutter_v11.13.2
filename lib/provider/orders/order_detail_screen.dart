import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/order_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/orders/update_order_status_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  OrderDetailScreen({required this.orderId});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderData? order;
  Future<OrderData>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getOrderDetailData();
  }

  void getOrderDetailData() {
    appStore.setLoading(true);

    future = getOrderDetail(widget.orderId).then((response) {
      order = response;
      appStore.setLoading(false);
      setState(() {});
      return response;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  void updateOrderStatus() {
    if (order != null) {
      UpdateOrderStatusScreen(order: order!).launch(context).then((value) {
        if (value == true) {
          getOrderDetailData();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Order Details',
      actions: [
        if (order != null && order!.canUpdateStatus)
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: updateOrderStatus,
          ),
      ],
      body: Stack(
        children: [
          FutureBuilder<OrderData>(
            future: future,
            builder: (context, snap) {
              if (snap.hasData && order != null) {
                return AnimatedScrollView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // Order Header
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: radius(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Order #${order!.orderNumber.validate()}',
                                      style: boldTextStyle(size: 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  8.width,
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: boxDecorationDefault(
                                      color: _getStatusColor(),
                                      borderRadius: radius(20),
                                    ),
                                    child: Text(
                                      _getStatusText(),
                                      style:
                                          boldTextStyle(color: white, size: 12),
                                    ),
                                  ),
                                ],
                              ),
                              8.height,
                              Text(
                                formatDate(order!.createdAt.validate()),
                                style: secondaryTextStyle(),
                              ),
                            ],
                          ),

                          16.height,

                          // Total Amount
                          Row(
                            children: [
                              Expanded(
                                child: Text('Total Amount:',
                                    style: boldTextStyle()),
                              ),
                              PriceWidget(
                                price: order!.totalAmount.validate(),
                                color: primaryColor,
                                size: 18,
                                isFreeService:
                                    order!.totalAmount.validate() == 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    24.height,

                    // Customer Information
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: radius(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer Information', style: boldTextStyle()),
                          16.height,
                          Row(
                            children: [
                              CachedImageWidget(
                                url: order!.customerImage.validate(),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                radius: 25,
                              ),
                              16.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order!.customerName.validate(),
                                      style: boldTextStyle(),
                                    ),
                                    4.height,
                                    Text(
                                      order!.customerEmail.validate(),
                                      style: secondaryTextStyle(),
                                    ),
                                    if (order!.customerPhone
                                        .validate()
                                        .isNotEmpty) ...[
                                      4.height,
                                      Text(
                                        order!.customerPhone.validate(),
                                        style: secondaryTextStyle(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    24.height,

                    // Order Items
                    if (order!.orderItems?.isNotEmpty == true) ...[
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: context.cardColor,
                          borderRadius: radius(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order Items', style: boldTextStyle()),
                            16.height,
                            ...order!.orderItems!.map((item) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(12),
                                decoration: boxDecorationDefault(
                                  color: context.scaffoldBackgroundColor,
                                  borderRadius: radius(8),
                                ),
                                child: Row(
                                  children: [
                                    CachedImageWidget(
                                      url: item.productImage.validate(),
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                      radius: 8,
                                    ),
                                    12.width,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName.validate(),
                                            style: boldTextStyle(size: 14),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          4.height,
                                          Text(
                                            'SKU: ${item.productSku.validate()}',
                                            style: secondaryTextStyle(size: 12),
                                          ),
                                          4.height,
                                          Row(
                                            children: [
                                              Text(
                                                'Qty: ${item.quantity.validate()}',
                                                style: secondaryTextStyle(
                                                    size: 12),
                                              ),
                                              Spacer(),
                                              Flexible(
                                                child: Text(
                                                  item.totalPriceFormat
                                                      .validate(),
                                                  style: boldTextStyle(
                                                      color: primaryColor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      24.height,
                    ],

                    // Payment & Shipping Info
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: radius(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment & Shipping', style: boldTextStyle()),
                          16.height,
                          _buildInfoRow('Payment Status',
                              order!.paymentStatus?.toUpperCase() ?? 'UNKNOWN'),
                          _buildInfoRow('Payment Method',
                              order!.paymentMethod?.toUpperCase() ?? 'N/A'),
                          if (order!.trackingNumber.validate().isNotEmpty)
                            _buildInfoRow('Tracking Number',
                                order!.trackingNumber.validate()),
                          if (order!.shippingAddress.validate().isNotEmpty) ...[
                            16.height,
                            Text('Shipping Address:',
                                style: boldTextStyle(size: 14)),
                            8.height,
                            Text(
                              order!.shippingAddress.validate(),
                              style: secondaryTextStyle(),
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ],
                          if (order!.notes.validate().isNotEmpty) ...[
                            16.height,
                            Text('Notes:', style: boldTextStyle(size: 14)),
                            8.height,
                            Text(
                              order!.notes.validate(),
                              style: secondaryTextStyle(),
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Update Status Button
                    if (order!.canUpdateStatus) ...[
                      24.height,
                      AppButton(
                        text: 'Update Order Status',
                        color: primaryColor,
                        textStyle: boldTextStyle(color: white),
                        width: context.width(),
                        onTap: updateOrderStatus,
                      ),
                    ],
                  ],
                );
              }

              return NoDataWidget(
                title: 'Order Not Found',
                subTitle: 'The requested order could not be found.',
                imageWidget: ErrorStateWidget(),
              ).paddingTop(50);
            },
          ),
          Observer(
            builder: (context) =>
                LoaderWidget().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: boldTextStyle(size: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: secondaryTextStyle(size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (order?.status?.toLowerCase()) {
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
    switch (order?.status?.toLowerCase()) {
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
