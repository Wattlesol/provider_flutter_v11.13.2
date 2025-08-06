import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/view_all_label_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/product_model.dart';
import 'package:handyman_provider_flutter/provider/components/product_card_widget.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class ProductListComponent extends StatelessWidget {
  final List<ProductData> products;
  final String title;
  final String? subtitle;
  final VoidCallback? onViewAll;
  final Function(ProductData)? onProductTap;
  final Function(ProductData)? onProductEdit;
  final Function(ProductData)? onProductDelete;
  final bool showActions;
  final int maxItems;

  const ProductListComponent({
    Key? key,
    required this.products,
    this.title = 'Products',
    this.subtitle,
    this.onViewAll,
    this.onProductTap,
    this.onProductEdit,
    this.onProductDelete,
    this.showActions = true,
    this.maxItems = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return Offstage();

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
              subLabel: subtitle ?? '${products.length} products',
              list: products,
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
              // Grid Layout for Products
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  products.take(maxItems).length,
                  (index) {
                    final product = products[index];
                    return ProductCardWidget(
                      product: product,
                      width: context.width() * 0.48 - 20,
                      showActions: showActions,
                      onTap: onProductTap != null
                          ? () => onProductTap!(product)
                          : null,
                      onEdit: onProductEdit != null
                          ? () => onProductEdit!(product)
                          : null,
                      onDelete: onProductDelete != null
                          ? () => onProductDelete!(product)
                          : null,
                    );
                  },
                ),
              ),

              // Empty State
              Observer(
                builder: (context) => NoDataWidget(
                  title: 'No Products Yet',
                  subTitle:
                      'Start by adding your first product to showcase your offerings.',
                  imageWidget: EmptyStateWidget(),
                ).visible(!appStore.isLoading && products.isEmpty),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductStatusWidget extends StatelessWidget {
  final String status;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const ProductStatusWidget({
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
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'rejected':
        return Icons.cancel;
      case 'total':
        return Icons.inventory;
      default:
        return Icons.help;
    }
  }
}

class ProductStatsComponent extends StatelessWidget {
  final int totalProducts;
  final int approvedProducts;
  final int pendingProducts;
  final int rejectedProducts;
  final Function(String)? onStatusTap;

  const ProductStatsComponent({
    Key? key,
    required this.totalProducts,
    required this.approvedProducts,
    required this.pendingProducts,
    required this.rejectedProducts,
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
          Text(
            'Product Overview',
            style: boldTextStyle(size: 18),
          ),
          16.height,
          Row(
            children: [
              Expanded(
                child: ProductStatusWidget(
                  status: 'Total',
                  count: totalProducts,
                  color: context.primaryColor,
                  onTap: onStatusTap != null ? () => onStatusTap!('all') : null,
                ),
              ),
              12.width,
              Expanded(
                child: ProductStatusWidget(
                  status: 'Approved',
                  count: approvedProducts,
                  color: greenColor,
                  onTap: onStatusTap != null
                      ? () => onStatusTap!('approved')
                      : null,
                ),
              ),
            ],
          ),
          12.height,
          Row(
            children: [
              Expanded(
                child: ProductStatusWidget(
                  status: 'Pending',
                  count: pendingProducts,
                  color: Colors.orange,
                  onTap: onStatusTap != null
                      ? () => onStatusTap!('pending')
                      : null,
                ),
              ),
              12.width,
              Expanded(
                child: ProductStatusWidget(
                  status: 'Rejected',
                  count: rejectedProducts,
                  color: redColor,
                  onTap: onStatusTap != null
                      ? () => onStatusTap!('rejected')
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
