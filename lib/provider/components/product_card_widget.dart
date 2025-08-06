import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/product_model.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductData product;
  final double? width;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const ProductCardWidget({
    Key? key,
    required this.product,
    this.width,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? context.width(),
      margin: EdgeInsets.only(bottom: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: appStore.isDarkMode ? cardDarkColor : cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Section
          SizedBox(
            height: 180,
            width: context.width(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CachedImageWidget(
                  url: product.imageAttachments?.isNotEmpty == true
                      ? product.imageAttachments!.first
                      : "",
                  fit: BoxFit.cover,
                  height: 180,
                  width: context.width(),
                ).cornerRadiusWithClipRRectOnly(
                  topRight: defaultRadius.toInt(),
                  topLeft: defaultRadius.toInt(),
                ),

                // Category Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: boxDecorationWithShadow(
                      backgroundColor: context.cardColor.withValues(alpha: 0.9),
                      borderRadius: radius(24),
                    ),
                    child: Text(
                      product.categoryName?.toUpperCase() ?? 'PRODUCT',
                      style: boldTextStyle(
                        color: appStore.isDarkMode ? white : primaryColor,
                        size: 12,
                      ),
                    ),
                  ),
                ),

                // Approval Status Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: boxDecorationDefault(
                      color: _getApprovalStatusColor(),
                      borderRadius: radius(24),
                    ),
                    child: Text(
                      _getApprovalStatusText(),
                      style: boldTextStyle(color: white, size: 12),
                    ),
                  ),
                ),

                // Price Badge
                Positioned(
                  bottom: 12,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: boxDecorationWithShadow(
                      backgroundColor: primaryColor,
                      borderRadius: radius(24),
                      border: Border.all(color: context.cardColor, width: 2),
                    ),
                    child: PriceWidget(
                      price: product.basePrice.validate(),
                      color: Colors.white,
                      size: 14,
                      isFreeService: product.basePrice.validate() == 0,
                    ),
                  ),
                ),

                // Stock Status
                if (!product.isInStock)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: boxDecorationDefault(
                        color: redColor,
                        borderRadius: radius(24),
                      ),
                      child: Text(
                        'OUT OF STOCK',
                        style: boldTextStyle(color: white, size: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Product Details Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.name.validate(),
                  style: boldTextStyle(size: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                8.height,

                // Product Description
                if (product.description.validate().isNotEmpty)
                  Text(
                    product.description.validate(),
                    style: secondaryTextStyle(size: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                8.height,

                // Product Info
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Stock: ${product.stockQuantity.validate()}',
                        style: secondaryTextStyle(size: 12),
                      ),
                    ),
                    if (product.totalSales.validate() > 0)
                      Text(
                        'Sales: ${product.totalSales.validate().toInt()}',
                        style: secondaryTextStyle(size: 12),
                      ),
                  ],
                ),

                4.height,

                // Rating and Weight Info
                Row(
                  children: [
                    if (product.averageRating.validate() > 0) ...[
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      4.width,
                      Text(
                        '${product.averageRating.validate().toStringAsFixed(1)} (${product.totalReviews.validate()})',
                        style: secondaryTextStyle(size: 12),
                      ),
                      Spacer(),
                    ],
                    if (product.weight.validate() > 0)
                      Text(
                        '${product.weight.validate()}kg',
                        style: secondaryTextStyle(size: 12),
                      ),
                  ],
                ),

                // Rejection Reason (if rejected)
                if (product.isRejected &&
                    product.rejectReason.validate().isNotEmpty) ...[
                  12.height,
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: boxDecorationDefault(
                      color: redColor.withValues(alpha: 0.1),
                      borderRadius: radius(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rejection Reason:',
                          style: boldTextStyle(color: redColor, size: 12),
                        ),
                        4.height,
                        Text(
                          product.rejectReason.validate(),
                          style: secondaryTextStyle(size: 12),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],

                // Action Buttons
                if (showActions) ...[
                  8.height,
                  Row(
                    children: [
                      if (onEdit != null)
                        Expanded(
                          child: AppButton(
                            text: 'Edit',
                            textStyle:
                                boldTextStyle(color: primaryColor, size: 14),
                            color: primaryColor.withValues(alpha: 0.1),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            onTap: onEdit,
                          ),
                        ),
                      if (onEdit != null && onDelete != null) 8.width,
                      if (onDelete != null)
                        Expanded(
                          child: AppButton(
                            text: 'Delete',
                            textStyle: boldTextStyle(color: redColor, size: 14),
                            color: redColor.withValues(alpha: 0.1),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            onTap: onDelete,
                          ),
                        ),
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

  Color _getApprovalStatusColor() {
    switch (product.approvalStatus) {
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
    switch (product.approvalStatus) {
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
