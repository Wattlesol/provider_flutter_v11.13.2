import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';

import 'package:nb_utils/nb_utils.dart';

class ProductListShimmer extends StatelessWidget {
  final double? width;
  final bool isGridView;

  ProductListShimmer({this.width, this.isGridView = true});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: isGridView
          ? Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                  6, (index) => _buildProductShimmerCard(context)),
            )
          : Column(
              children: List.generate(5,
                  (index) => _buildProductShimmerCard(context, isGrid: false)),
            ),
    );
  }

  Widget _buildProductShimmerCard(BuildContext context, {bool isGrid = true}) {
    return Container(
      width: isGrid ? (width ?? context.width() * 0.48 - 20) : context.width(),
      margin: EdgeInsets.only(bottom: isGrid ? 0 : 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          ShimmerWidget(
            height: 180,
            width: context.width(),
            backgroundColor: context.scaffoldBackgroundColor,
          ).cornerRadiusWithClipRRectOnly(
            topRight: defaultRadius.toInt(),
            topLeft: defaultRadius.toInt(),
          ),

          // Content shimmer
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                ShimmerWidget(
                  height: 16,
                  width: context.width() * 0.7,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),

                8.height,

                // Description shimmer
                ShimmerWidget(
                  height: 12,
                  width: context.width() * 0.9,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),

                4.height,

                ShimmerWidget(
                  height: 12,
                  width: context.width() * 0.6,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),

                8.height,

                // SKU and Stock shimmer
                Row(
                  children: [
                    Expanded(
                      child: ShimmerWidget(
                        height: 12,
                        width: context.width() * 0.3,
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                    ),
                    ShimmerWidget(
                      height: 12,
                      width: context.width() * 0.2,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ),
                  ],
                ),

                16.height,

                // Action buttons shimmer
                Row(
                  children: [
                    Expanded(
                      child: ShimmerWidget(
                        height: 36,
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: ShimmerWidget(
                        height: 36,
                        backgroundColor: context.scaffoldBackgroundColor,
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
  }
}

class ProductDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          ShimmerWidget(
            height: 250,
            width: context.width(),
            backgroundColor: context.scaffoldBackgroundColor,
          ).cornerRadiusWithClipRRect(defaultRadius),

          24.height,

          // Product info card shimmer
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: radius(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and status row
                Row(
                  children: [
                    Expanded(
                      child: ShimmerWidget(
                        height: 20,
                        width: context.width() * 0.6,
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                    ),
                    ShimmerWidget(
                      height: 24,
                      width: 80,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ),
                  ],
                ),

                16.height,

                // Price shimmer
                ShimmerWidget(
                  height: 18,
                  width: 100,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),

                16.height,

                // Description shimmer
                ShimmerWidget(
                  height: 14,
                  width: context.width() * 0.9,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),

                8.height,

                ShimmerWidget(
                  height: 14,
                  width: context.width() * 0.7,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),

                16.height,

                // Details shimmer
                ...List.generate(
                    6,
                    (index) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              ShimmerWidget(
                                height: 14,
                                width: 100,
                                backgroundColor:
                                    context.scaffoldBackgroundColor,
                              ),
                              16.width,
                              Expanded(
                                child: ShimmerWidget(
                                  height: 14,
                                  width: context.width() * 0.4,
                                  backgroundColor:
                                      context.scaffoldBackgroundColor,
                                ),
                              ),
                            ],
                          ),
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
