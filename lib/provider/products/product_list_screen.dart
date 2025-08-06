import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/product_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/components/product_card_widget.dart';
import 'package:handyman_provider_flutter/provider/products/add_product_screen.dart';
import 'package:handyman_provider_flutter/provider/products/product_detail_screen.dart';

import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController searchController = TextEditingController();

  List<ProductData> products = [];
  Future<ProductListResponse>? future;

  List<String> statusTabs = ['All', 'Approved', 'Pending', 'Rejected'];
  String selectedStatus = 'All';

  int page = 1;
  bool isLastPage = false;
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getProductListAPI();
  }

  void getProductListAPI() {
    appStore.setLoading(true);

    String status = selectedStatus.toLowerCase() != 'all'
        ? selectedStatus.toLowerCase()
        : '';

    future = getProductList(
      page: page,
      status: '',
      approvalStatus: status,
      search: searchController.text.trim(),
    ).then((response) {
      appStore.setLoading(false);

      if (page == 1) products.clear();
      products.addAll(response.data ?? []);

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
    getProductListAPI();
  }

  void loadMore() {
    if (!isLastPage) {
      page++;
      getProductListAPI();
    }
  }

  void onStatusTabChanged(String status) {
    selectedStatus = status;
    page = 1;
    getProductListAPI();
  }

  void onSearchChanged() {
    page = 1;
    getProductListAPI();
  }

  void deleteProductConfirm(ProductData product) {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: 'Delete Product',
      subTitle: 'Are you sure you want to delete "${product.name}"?',
      positiveText: 'Delete',
      negativeText: 'Cancel',
      onAccept: (v) async {
        appStore.setLoading(true);

        await deleteProduct(product.id.validate()).then((value) {
          appStore.setLoading(false);
          toast('Product deleted successfully');
          onRefresh();
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: BackWidget(),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              AddProductScreen().launch(context).then((value) {
                if (value == true) {
                  onRefresh();
                }
              });
            },
          ),
        ],
      ),
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
                hint: 'Search products...',
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
                      color: isSelected ? white : primaryColor,
                      size: 14,
                    ),
                    color: isSelected
                        ? primaryColor
                        : primaryColor.withValues(alpha: 0.1),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: () => onStatusTabChanged(status),
                  ),
                );
              },
            ),
          ),

          // Product List
          Expanded(
            child: Stack(
              children: [
                FutureBuilder<ProductListResponse>(
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
                        if (products.isNotEmpty)
                          isGridView
                              ? Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: products.map((product) {
                                    return ProductCardWidget(
                                      product: product,
                                      width: context.width() * 0.48 - 20,
                                      onTap: () {
                                        ProductDetailScreen(
                                                productId:
                                                    product.id.validate())
                                            .launch(context);
                                      },
                                      onEdit: () {
                                        AddProductScreen(product: product)
                                            .launch(context)
                                            .then((value) {
                                          if (value == true) {
                                            onRefresh();
                                          }
                                        });
                                      },
                                      onDelete: () =>
                                          deleteProductConfirm(product),
                                    );
                                  }).toList(),
                                )
                              : Column(
                                  children: products.map((product) {
                                    return ProductCardWidget(
                                      product: product,
                                      onTap: () {
                                        ProductDetailScreen(
                                                productId:
                                                    product.id.validate())
                                            .launch(context);
                                      },
                                      onEdit: () {
                                        AddProductScreen(product: product)
                                            .launch(context)
                                            .then((value) {
                                          if (value == true) {
                                            onRefresh();
                                          }
                                        });
                                      },
                                      onDelete: () =>
                                          deleteProductConfirm(product),
                                    );
                                  }).toList(),
                                ),
                        if (products.isEmpty && !appStore.isLoading)
                          NoDataWidget(
                            title: 'No Products Found',
                            subTitle: selectedStatus == 'All'
                                ? 'Start by adding your first product'
                                : 'No products found with status: $selectedStatus',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddProductScreen().launch(context).then((value) {
            if (value == true) {
              onRefresh();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
