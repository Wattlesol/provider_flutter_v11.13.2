import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/shimmer_widget.dart';

import 'package:nb_utils/nb_utils.dart';

class OrderListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: List.generate(5, (index) => _buildOrderShimmerCard(context)),
      ),
    );
  }

  Widget _buildOrderShimmerCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header shimmer
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor.withValues(alpha: 0.5),
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
                      ShimmerWidget(
                        height: 16,
                        width: context.width() * 0.4,
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      4.height,
                      ShimmerWidget(
                        height: 12,
                        width: context.width() * 0.3,
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                    ],
                  ),
                ),
                ShimmerWidget(
                  height: 24,
                  width: 80,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),
              ],
            ),
          ),

          // Order content shimmer
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer info row
                Row(
                  children: [
                    ShimmerWidget(
                      height: 40,
                      width: 40,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ).cornerRadiusWithClipRRect(20),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(
                            height: 14,
                            width: context.width() * 0.4,
                            backgroundColor: context.scaffoldBackgroundColor,
                          ),
                          4.height,
                          ShimmerWidget(
                            height: 12,
                            width: context.width() * 0.5,
                            backgroundColor: context.scaffoldBackgroundColor,
                          ),
                        ],
                      ),
                    ),
                    ShimmerWidget(
                      height: 16,
                      width: 80,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ),
                  ],
                ),

                16.height,

                // Items section shimmer
                ShimmerWidget(
                  height: 14,
                  width: context.width() * 0.3,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),

                8.height,

                // Item list shimmer
                ...List.generate(
                    2,
                    (index) => Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: ShimmerWidget(
                                  height: 12,
                                  width: context.width() * 0.6,
                                  backgroundColor:
                                      context.scaffoldBackgroundColor,
                                ),
                              ),
                              ShimmerWidget(
                                height: 12,
                                width: 60,
                                backgroundColor:
                                    context.scaffoldBackgroundColor,
                              ),
                            ],
                          ),
                        )),

                16.height,

                // Payment status shimmer
                Row(
                  children: [
                    ShimmerWidget(
                      height: 16,
                      width: 16,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ),
                    8.width,
                    Expanded(
                      child: ShimmerWidget(
                        height: 12,
                        width: context.width() * 0.4,
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                    ),
                    ShimmerWidget(
                      height: 12,
                      width: 60,
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
                    12.width,
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

class OrderDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header card shimmer
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: radius(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(
                          height: 18,
                          width: context.width() * 0.4,
                          backgroundColor: context.scaffoldBackgroundColor,
                        ),
                        4.height,
                        ShimmerWidget(
                          height: 14,
                          width: context.width() * 0.3,
                          backgroundColor: context.scaffoldBackgroundColor,
                        ),
                      ],
                    ),
                    ShimmerWidget(
                      height: 24,
                      width: 80,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ),
                  ],
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerWidget(
                      height: 16,
                      width: 100,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ),
                    ShimmerWidget(
                      height: 18,
                      width: 80,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ),
                  ],
                ),
              ],
            ),
          ),

          24.height,

          // Customer info card shimmer
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: radius(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  height: 16,
                  width: context.width() * 0.4,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),
                16.height,
                Row(
                  children: [
                    ShimmerWidget(
                      height: 50,
                      width: 50,
                      backgroundColor: context.scaffoldBackgroundColor,
                    ).cornerRadiusWithClipRRect(25),
                    16.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(
                            height: 16,
                            width: context.width() * 0.4,
                            backgroundColor: context.scaffoldBackgroundColor,
                          ),
                          4.height,
                          ShimmerWidget(
                            height: 14,
                            width: context.width() * 0.5,
                            backgroundColor: context.scaffoldBackgroundColor,
                          ),
                          4.height,
                          ShimmerWidget(
                            height: 14,
                            width: context.width() * 0.3,
                            backgroundColor: context.scaffoldBackgroundColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          24.height,

          // Order items card shimmer
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: radius(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  height: 16,
                  width: context.width() * 0.3,
                  backgroundColor: context.scaffoldBackgroundColor,
                ),
                16.height,

                // Order items shimmer
                ...List.generate(
                    3,
                    (index) => Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(12),
                          decoration: boxDecorationDefault(
                            color: context.scaffoldBackgroundColor
                                .withValues(alpha: 0.5),
                            borderRadius: radius(8),
                          ),
                          child: Row(
                            children: [
                              ShimmerWidget(
                                height: 60,
                                width: 60,
                                backgroundColor:
                                    context.scaffoldBackgroundColor,
                              ).cornerRadiusWithClipRRect(8),
                              12.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerWidget(
                                      height: 14,
                                      width: context.width() * 0.5,
                                      backgroundColor:
                                          context.scaffoldBackgroundColor,
                                    ),
                                    4.height,
                                    ShimmerWidget(
                                      height: 12,
                                      width: context.width() * 0.3,
                                      backgroundColor:
                                          context.scaffoldBackgroundColor,
                                    ),
                                    4.height,
                                    Row(
                                      children: [
                                        ShimmerWidget(
                                          height: 12,
                                          width: 50,
                                          backgroundColor:
                                              context.scaffoldBackgroundColor,
                                        ),
                                        Spacer(),
                                        ShimmerWidget(
                                          height: 14,
                                          width: 60,
                                          backgroundColor:
                                              context.scaffoldBackgroundColor,
                                        ),
                                      ],
                                    ),
                                  ],
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
