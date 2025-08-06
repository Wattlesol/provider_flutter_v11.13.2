import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/order_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/components/order_card_widget.dart';
import 'package:handyman_provider_flutter/provider/orders/order_detail_screen.dart';
import 'package:handyman_provider_flutter/provider/orders/update_order_status_screen.dart';

import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  TextEditingController searchController = TextEditingController();

  List<OrderData> orders = [];
  Future<OrderListResponse>? future;

  List<String> statusTabs = [
    'All',
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Cancelled'
  ];
  String selectedStatus = 'All';

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getOrderListAPI();
  }

  void getOrderListAPI() {
    appStore.setLoading(true);

    String status = selectedStatus.toLowerCase() != 'all'
        ? selectedStatus.toLowerCase()
        : '';

    future = getOrderList(
      page: page,
      status: status,
      search: searchController.text.trim(),
    ).then((response) {
      appStore.setLoading(false);

      if (page == 1) orders.clear();
      orders.addAll(response.data ?? []);

      isLastPage = (response.data?.length ?? 0) < PER_PAGE_ITEM;
      setState(() {});

      return response;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  void onRefresh() {
    page = 1;
    getOrderListAPI();
  }

  void loadMore() {
    if (!isLastPage) {
      page++;
      getOrderListAPI();
    }
  }

  void onStatusTabChanged(String status) {
    selectedStatus = status;
    page = 1;
    getOrderListAPI();
  }

  void onSearchChanged() {
    page = 1;
    getOrderListAPI();
  }

  void updateOrderStatus(OrderData order) {
    UpdateOrderStatusScreen(order: order).launch(context).then((value) {
      if (value == true) {
        onRefresh();
      }
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Orders',
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            color: context.cardColor,
            child: AppTextField(
              controller: searchController,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context,
                hint: 'Search orders...',
                prefixIcon: Icon(Icons.search),
                fillColor: context.scaffoldBackgroundColor,
              ),
              onChanged: (value) {
                if (value.isEmpty || value.length > 2) {
                  1.seconds.delay.then((_) => onSearchChanged());
                }
              },
            ),
          ),

          // Status Tabs
          Container(
            height: 50,
            color: context.cardColor,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: statusTabs.length,
              itemBuilder: (context, index) {
                String status = statusTabs[index];
                bool isSelected = selectedStatus == status;

                return Container(
                  margin: EdgeInsets.only(right: 12, top: 8, bottom: 8),
                  child: AppButton(
                    text: status,
                    textStyle: boldTextStyle(
                      color: isSelected ? white : _getStatusColor(status),
                      size: 14,
                    ),
                    color: isSelected
                        ? _getStatusColor(status)
                        : _getStatusColor(status).withValues(alpha: 0.1),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: () => onStatusTabChanged(status),
                  ),
                );
              },
            ),
          ),

          // Order List
          Expanded(
            child: Stack(
              children: [
                FutureBuilder<OrderListResponse>(
                  future: future,
                  builder: (context, snap) {
                    return AnimatedScrollView(
                      padding: EdgeInsets.all(16),
                      onSwipeRefresh: () async {
                        onRefresh();
                        return await 2.seconds.delay;
                      },
                      onNextPage: loadMore,
                      children: [
                        if (orders.isNotEmpty)
                          Column(
                            children: orders.map((order) {
                              return OrderCardWidget(
                                order: order,
                                onTap: () {
                                  OrderDetailScreen(
                                          orderId: order.id.validate())
                                      .launch(context);
                                },
                                onUpdateStatus: order.canUpdateStatus
                                    ? () => updateOrderStatus(order)
                                    : null,
                              );
                            }).toList(),
                          ),
                        if (orders.isEmpty && !appStore.isLoading)
                          NoDataWidget(
                            title: 'No Orders Found',
                            subTitle: selectedStatus == 'All'
                                ? 'No orders have been placed yet'
                                : 'No orders found with status: $selectedStatus',
                            imageWidget: EmptyStateWidget(),
                          ).paddingTop(50),
                      ],
                    );
                  },
                ),
                Observer(
                  builder: (context) =>
                      LoaderWidget().center().visible(appStore.isLoading),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
