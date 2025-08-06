import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/app_theme.dart';
import 'package:handyman_provider_flutter/models/product_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/components/total_widget.dart';
import 'package:handyman_provider_flutter/provider/orders/order_list_screen.dart';
import 'package:handyman_provider_flutter/provider/products/add_product_screen.dart';
import 'package:handyman_provider_flutter/provider/products/product_list_screen.dart';
import 'package:handyman_provider_flutter/screens/total_earning_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/extensions/num_extenstions.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ProviderStoreFragment extends StatefulWidget {
  @override
  _ProviderStoreFragmentState createState() => _ProviderStoreFragmentState();
}

class _ProviderStoreFragmentState extends State<ProviderStoreFragment> {
  ProductAnalytics? analytics;
  bool isLoading = true;
  List<ProductData> recentProducts = [];

  @override
  void initState() {
    super.initState();
    fetchStoreData();
  }

  Future<void> fetchStoreData() async {
    try {
      setState(() => isLoading = true);

      log('🏪 [StoreData] Starting to fetch store analytics...');

      // Fetch products with stats
      final response = await getProductList(withStats: true, perPage: 100);
      log('🏪 [StoreData] Raw response type: ${response.runtimeType}');
      log('🏪 [StoreData] Response data type: ${response.data.runtimeType}');
      log('🏪 [StoreData] Products count: ${response.data?.length ?? 0}');

      final products = response.data ?? [];

      if (products.isNotEmpty) {
        log('🏪 [StoreData] First product sample: ${products.first.toJson()}');
      }

      // Calculate analytics
      analytics = ProductAnalytics.fromProducts(products);
      log('🏪 [StoreData] Analytics calculated - Total: ${analytics!.totalProducts}, Active: ${analytics!.activeProducts}');
      log('🏪 [StoreData] Sales: ${analytics!.totalSales}, Revenue: ${analytics!.totalRevenue}');

      // Get recent products (last 5)
      recentProducts = products.take(5).toList();
      log('🏪 [StoreData] Recent products: ${recentProducts.length}');

      setState(() => isLoading = false);
      log('🏪 [StoreData] Store data fetch completed successfully');
    } catch (e, stackTrace) {
      setState(() => isLoading = false);
      log('❌ [StoreData] Error fetching store data: $e');
      log('❌ [StoreData] Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return AnimatedScrollView(
            padding: EdgeInsets.only(bottom: 16),
            physics: AlwaysScrollableScrollPhysics(),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Analytics Section
              _buildAnalyticsSection(),

              // Quick Actions Section
              _buildQuickActionsSection(),

              // Recent Products Section
              _buildRecentProductsSection(),

              // Low Stock Alert Section
              if (analytics != null && analytics!.lowStockProducts > 0)
                _buildLowStockAlert(),
            ],
            onSwipeRefresh: () async {
              await fetchStoreData();
              return await 1.seconds.delay;
            },
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    if (isLoading) {
      return Container(
        height: 200,
        margin: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (analytics == null) {
      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(24),
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: context.cardColor,
        ),
        child: Column(
          children: [
            Icon(Icons.store, size: 48, color: appTextSecondaryColor),
            16.height,
            Text('No products found', style: boldTextStyle()),
            8.height,
            Text('Start by adding your first product',
                style: secondaryTextStyle()),
            16.height,
            AppButton(
              text: 'Add Product',
              onTap: () => AddProductScreen().launch(context),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('Store Analytics', style: boldTextStyle(size: 18)),
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            TotalWidget(
              title: 'Total Products',
              total: analytics!.totalProducts.toString(),
              icon: services,
              color: context.brandColors.brandBlue,
            ).onTap(() => ProductListScreen().launch(context)),
            TotalWidget(
              title: 'Active Products',
              total: analytics!.activeProducts.toString(),
              icon: ic_verified,
              color: context.brandColors.brandGreen,
            ).onTap(() => ProductListScreen().launch(context)),
            TotalWidget(
              title: 'Total Sales',
              total: analytics!.totalSales.toString(),
              icon: purchase,
              color: context.brandColors.brandYellow,
            ).onTap(() => ProductListScreen().launch(context)),
            TotalWidget(
              title: 'Product Revenue',
              total: analytics!.totalRevenue.toPriceFormat(),
              icon: total_revenue_final,
              color: context.brandColors.brandRed,
            ).onTap(() => ProductListScreen().launch(context)),
          ],
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('Quick Actions', style: boldTextStyle(size: 18)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(16),
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor,
          ),
          child: Column(
            children: [
              _buildQuickActionTile(
                icon: Icons.add_circle_outline,
                title: 'Add New Product',
                subtitle: 'Create a new product listing',
                onTap: () => AddProductScreen().launch(context),
              ),
              Divider(),
              _buildQuickActionTile(
                icon: Icons.inventory_2_outlined,
                title: 'Manage Products',
                subtitle: 'View and edit your products',
                onTap: () => ProductListScreen().launch(context),
              ),
              Divider(),
              _buildQuickActionTile(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View customer orders',
                onTap: () => OrderListScreen().launch(context),
              ),
              Divider(),
              _buildQuickActionTile(
                icon: Icons.analytics_outlined,
                title: 'Sales Reports',
                subtitle: 'View detailed analytics',
                onTap: () => TotalEarningScreen().launch(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: primaryColor),
      ),
      title: Text(title, style: boldTextStyle()),
      subtitle: Text(subtitle, style: secondaryTextStyle()),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildRecentProductsSection() {
    if (recentProducts.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Products', style: boldTextStyle(size: 18)),
              TextButton(
                onPressed: () => ProductListScreen().launch(context),
                child:
                    Text('View All', style: boldTextStyle(color: primaryColor)),
              ),
            ],
          ),
        ),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentProducts.length,
            itemBuilder: (context, index) {
              final product = recentProducts[index];
              return Container(
                width: 200,
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(12),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: context.cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name.validate(),
                      style: boldTextStyle(size: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.height,
                    Text(
                      product.categoryName.validate(),
                      style: secondaryTextStyle(size: 12),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.basePrice.validate().toPriceFormat(),
                          style: boldTextStyle(color: primaryColor, size: 14),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.isApproved
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.approvalStatusLabel.validate(),
                            style: boldTextStyle(color: Colors.white, size: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLowStockAlert() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        borderRadius: radius(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Low Stock Alert', style: boldTextStyle()),
                Text(
                  '${analytics!.lowStockProducts} products are running low on stock',
                  style: secondaryTextStyle(),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => ProductListScreen().launch(context),
            child: Text('View', style: boldTextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}

// Product Analytics Model
class ProductAnalytics {
  final int totalProducts;
  final int activeProducts;
  final int pendingProducts;
  final int approvedProducts;
  final int rejectedProducts;
  final int featuredProducts;
  final int lowStockProducts;
  final num totalSales;
  final num totalRevenue;
  final num averageRating;
  final int totalReviews;

  ProductAnalytics({
    required this.totalProducts,
    required this.activeProducts,
    required this.pendingProducts,
    required this.approvedProducts,
    required this.rejectedProducts,
    required this.featuredProducts,
    required this.lowStockProducts,
    required this.totalSales,
    required this.totalRevenue,
    required this.averageRating,
    required this.totalReviews,
  });

  factory ProductAnalytics.fromProducts(List<ProductData> products) {
    int totalProducts = products.length;
    int activeProducts = products.where((p) => p.isActive).length;
    int pendingProducts = products.where((p) => p.isPending).length;
    int approvedProducts = products.where((p) => p.isApproved).length;
    int rejectedProducts = products.where((p) => p.isRejected).length;
    int featuredProducts = products.where((p) => p.isFeaturedProduct).length;
    int lowStockProducts = products
        .where((p) =>
            p.stockQuantity.validate() <= p.lowStockThreshold.validate() &&
            p.lowStockThreshold.validate() > 0)
        .length;

    // Calculate totals with proper error handling
    num totalSales = 0;
    num totalRevenue = 0;

    for (var product in products) {
      try {
        totalSales += product.totalSales ?? 0;
        totalRevenue += product.totalRevenue ?? 0;
      } catch (e) {
        log('⚠️ [Analytics] Error processing product ${product.id} stats: $e');
      }
    }

    log('📊 [Analytics] Calculated totals - Sales: $totalSales, Revenue: $totalRevenue');

    List<ProductData> ratedProducts = products
        .where((p) => p.averageRating != null && p.averageRating! > 0)
        .toList();

    num averageRating = ratedProducts.isEmpty
        ? 0
        : ratedProducts.fold(0.0, (sum, p) => sum + (p.averageRating ?? 0)) /
            ratedProducts.length;

    int totalReviews =
        products.fold(0, (sum, p) => sum + (p.totalReviews ?? 0));

    return ProductAnalytics(
      totalProducts: totalProducts,
      activeProducts: activeProducts,
      pendingProducts: pendingProducts,
      approvedProducts: approvedProducts,
      rejectedProducts: rejectedProducts,
      featuredProducts: featuredProducts,
      lowStockProducts: lowStockProducts,
      totalSales: totalSales,
      totalRevenue: totalRevenue,
      averageRating: averageRating,
      totalReviews: totalReviews,
    );
  }
}
