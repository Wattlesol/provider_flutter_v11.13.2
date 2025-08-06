import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/product_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/products/add_product_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductData? product;
  Future<ProductData>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getProductDetailData();
  }

  void getProductDetailData() {
    appStore.setLoading(true);

    future = getProductDetail(widget.productId).then((response) {
      product = response;
      appStore.setLoading(false);
      setState(() {});
      return response;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  void editProduct() {
    if (product != null) {
      AddProductScreen(product: product).launch(context).then((value) {
        if (value == true) {
          getProductDetailData();
        }
      });
    }
  }

  void deleteProductConfirm() {
    if (product == null) return;

    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: 'Delete Product',
      subTitle: 'Are you sure you want to delete "${product!.name}"?',
      positiveText: 'Delete',
      negativeText: 'Cancel',
      onAccept: (v) async {
        appStore.setLoading(true);

        await deleteProduct(product!.id.validate()).then((value) {
          appStore.setLoading(false);
          toast('Product deleted successfully');
          finish(context, true);
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
        title: Text('Product Details'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: BackWidget(),
        actions: [
          if (product != null) ...[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: editProduct,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteProductConfirm,
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<ProductData>(
            future: future,
            builder: (context, snap) {
              if (snap.hasData && product != null) {
                return AnimatedScrollView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // Product Images
                    if (product!.imageAttachments?.isNotEmpty == true) ...[
                      Container(
                        height: 250,
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: context.cardColor,
                          borderRadius: radius(),
                        ),
                        child: PageView.builder(
                          itemCount: product!.imageAttachments!.length,
                          itemBuilder: (context, index) {
                            return CachedImageWidget(
                              url: product!.imageAttachments![index],
                              fit: BoxFit.cover,
                              height: 250,
                              width: context.width(),
                            ).cornerRadiusWithClipRRect(defaultRadius);
                          },
                        ),
                      ),
                      24.height,
                    ],

                    // Product Info Card
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: radius(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Status
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product!.name.validate(),
                                  style: boldTextStyle(size: 20),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: boxDecorationDefault(
                                  color: _getApprovalStatusColor(),
                                  borderRadius: radius(20),
                                ),
                                child: Text(
                                  _getApprovalStatusText(),
                                  style: boldTextStyle(color: white, size: 12),
                                ),
                              ),
                            ],
                          ),

                          16.height,

                          // Price
                          PriceWidget(
                            price: product!.basePrice.validate(),
                            color: primaryColor,
                            size: 18,
                            isFreeService: product!.basePrice.validate() == 0,
                          ),

                          16.height,

                          // Description
                          if (product!.description.validate().isNotEmpty) ...[
                            Text('Description', style: boldTextStyle()),
                            8.height,
                            Text(
                              product!.description.validate(),
                              style: secondaryTextStyle(),
                            ),
                            16.height,
                          ],

                          // Product Details Grid
                          Text('Product Details', style: boldTextStyle()),
                          16.height,

                          _buildDetailRow(
                              'Category', product!.categoryName.validate()),
                          _buildDetailRow('SKU', product!.sku.validate()),
                          _buildDetailRow('Stock',
                              '${product!.stockQuantity.validate()} units'),
                          _buildDetailRow(
                              'Weight', '${product!.weight.validate()} kg'),
                          if (product!.dimensions.validate().isNotEmpty)
                            _buildDetailRow(
                                'Dimensions', product!.dimensions.validate()),
                          _buildDetailRow('Status',
                              product!.isActive ? 'Active' : 'Inactive'),
                          _buildDetailRow('Featured',
                              product!.isFeaturedProduct ? 'Yes' : 'No'),
                          _buildDetailRow('Created',
                              formatDate(product!.createdAt.validate())),
                        ],
                      ),
                    ),

                    // Statistics Card (if available)
                    if (product!.totalSales != null ||
                        product!.totalRevenue != null) ...[
                      24.height,
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: context.cardColor,
                          borderRadius: radius(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Statistics', style: boldTextStyle()),
                            16.height,
                            Row(
                              children: [
                                if (product!.totalSales != null)
                                  Expanded(
                                    child: _buildStatCard(
                                      'Total Sales',
                                      '${product!.totalSales.validate()}',
                                      Icons.shopping_cart,
                                      primaryColor,
                                    ),
                                  ),
                                if (product!.totalSales != null &&
                                    product!.totalRevenue != null)
                                  16.width,
                                if (product!.totalRevenue != null)
                                  Expanded(
                                    child: _buildStatCard(
                                      'Revenue',
                                      '\$${product!.totalRevenue.validate()}',
                                      Icons.attach_money,
                                      Colors.green,
                                    ),
                                  ),
                              ],
                            ),
                            if (product!.averageRating != null ||
                                product!.totalReviews != null) ...[
                              16.height,
                              Row(
                                children: [
                                  if (product!.averageRating != null)
                                    Expanded(
                                      child: _buildStatCard(
                                        'Rating',
                                        '${product!.averageRating.validate().toStringAsFixed(1)}',
                                        Icons.star,
                                        Colors.orange,
                                      ),
                                    ),
                                  if (product!.averageRating != null &&
                                      product!.totalReviews != null)
                                    16.width,
                                  if (product!.totalReviews != null)
                                    Expanded(
                                      child: _buildStatCard(
                                        'Reviews',
                                        '${product!.totalReviews.validate()}',
                                        Icons.rate_review,
                                        Colors.blue,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    // Rejection Reason (if rejected)
                    if (product!.isRejected &&
                        product!.rejectReason.validate().isNotEmpty) ...[
                      24.height,
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationDefault(
                          color: redColor.withValues(alpha: 0.1),
                          borderRadius: radius(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.error, color: redColor),
                                8.width,
                                Text('Rejection Reason',
                                    style: boldTextStyle(color: redColor)),
                              ],
                            ),
                            12.height,
                            Text(
                              product!.rejectReason.validate(),
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              }

              return NoDataWidget(
                title: 'Product Not Found',
                subTitle: 'The requested product could not be found.',
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: boxDecorationDefault(
        color: color.withValues(alpha: 0.1),
        borderRadius: radius(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          8.height,
          Text(value, style: boldTextStyle(color: color, size: 16)),
          4.height,
          Text(title, style: secondaryTextStyle(size: 12)),
        ],
      ),
    );
  }

  Color _getApprovalStatusColor() {
    switch (product?.approvalStatus) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getApprovalStatusText() {
    switch (product?.approvalStatus) {
      case 'approved':
        return 'APPROVED';
      case 'pending':
        return 'PENDING';
      case 'rejected':
        return 'REJECTED';
      default:
        return 'UNKNOWN';
    }
  }
}
