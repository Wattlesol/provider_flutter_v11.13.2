import 'package:handyman_provider_flutter/models/attachment_model.dart';
import 'package:handyman_provider_flutter/models/pagination_model.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductListResponse {
  List<ProductData>? data;
  Pagination? pagination;

  ProductListResponse({this.data, this.pagination});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ProductData.fromJson(i)).toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class ProductData {
  int? id;
  String? name;
  String? description;
  String? shortDescription;
  num? basePrice;
  num? sellingPrice;
  String? priceFormat;
  int? productCategoryId;
  String? categoryName;
  String? sku;
  int? stockQuantity;
  int? lowStockThreshold;
  bool? trackInventory;
  int? status;
  String? statusLabel;
  int? isFeatured;
  num? weight;
  String? dimensions;
  String? createdByType;
  int? createdBy;
  String? createdByName;
  String? createdByImage;
  String? approvalStatus;
  String? approvalStatusLabel;
  String? rejectReason;
  String? createdAt;
  String? updatedAt;
  List<String>? imageAttachments;
  List<Attachments>? attachments;
  num? totalSales;
  num? totalRevenue;
  num? averageRating;
  int? totalReviews;

  // Local properties
  bool get isApproved => approvalStatus == 'approved';
  bool get isPending => approvalStatus == 'pending';
  bool get isRejected => approvalStatus == 'rejected';
  bool get isActive => status == 1;
  bool get isFeaturedProduct => isFeatured == 1;
  bool get isInStock => stockQuantity.validate() > 0;

  ProductData({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.basePrice,
    this.sellingPrice,
    this.priceFormat,
    this.productCategoryId,
    this.categoryName,
    this.sku,
    this.stockQuantity,
    this.lowStockThreshold,
    this.trackInventory,
    this.status,
    this.statusLabel,
    this.isFeatured,
    this.weight,
    this.dimensions,
    this.createdByType,
    this.createdBy,
    this.createdByName,
    this.createdByImage,
    this.approvalStatus,
    this.approvalStatusLabel,
    this.rejectReason,
    this.createdAt,
    this.updatedAt,
    this.imageAttachments,
    this.attachments,
    this.totalSales,
    this.totalRevenue,
    this.averageRating,
    this.totalReviews,
  });

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    shortDescription = json['short_description'];
    basePrice = json['base_price'];
    sellingPrice = json['selling_price'];
    priceFormat = json['price_format'];
    productCategoryId = json['product_category_id'];
    categoryName = json['category_name'];
    sku = json['sku'];
    stockQuantity = json['stock_quantity'];
    lowStockThreshold = json['low_stock_threshold'];
    trackInventory = json['track_inventory'];
    status = json['status'] is bool ? (json['status'] ? 1 : 0) : json['status'];
    statusLabel = json['status_label'];
    isFeatured = json['is_featured'] is bool
        ? (json['is_featured'] ? 1 : 0)
        : json['is_featured'];
    weight = json['weight'];
    dimensions = json['dimensions'];
    createdByType = json['created_by_type'];
    createdBy = json['created_by'];
    createdByName = json['created_by_name'];
    createdByImage = json['created_by_image'];
    approvalStatus = json['approval_status'];
    approvalStatusLabel = json['approval_status_label'];
    rejectReason = json['reject_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageAttachments =
        json['images'] != null ? List<String>.from(json['images']) : null;
    attachments = json['attachments'] != null
        ? (json['attachments'] as List)
            .map((i) => Attachments.fromJson(i))
            .toList()
        : null;
    totalSales = json['total_sales'];
    totalRevenue = json['total_revenue'];
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['short_description'] = this.shortDescription;
    data['base_price'] = this.basePrice;
    data['selling_price'] = this.sellingPrice;
    data['price_format'] = this.priceFormat;
    data['product_category_id'] = this.productCategoryId;
    data['category_name'] = this.categoryName;
    data['sku'] = this.sku;
    data['stock_quantity'] = this.stockQuantity;
    data['low_stock_threshold'] = this.lowStockThreshold;
    data['track_inventory'] = this.trackInventory;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['is_featured'] = this.isFeatured;
    data['weight'] = this.weight;
    data['dimensions'] = this.dimensions;
    data['created_by_type'] = this.createdByType;
    data['created_by'] = this.createdBy;
    data['created_by_name'] = this.createdByName;
    data['created_by_image'] = this.createdByImage;
    data['approval_status'] = this.approvalStatus;
    data['approval_status_label'] = this.approvalStatusLabel;
    data['reject_reason'] = this.rejectReason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.imageAttachments != null) {
      data['images'] = this.imageAttachments;
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    data['total_sales'] = this.totalSales;
    data['total_revenue'] = this.totalRevenue;
    data['average_rating'] = this.averageRating;
    data['total_reviews'] = this.totalReviews;
    return data;
  }
}

class ProductCategoryData {
  int? id;
  String? name;
  String? description;
  String? image;
  int? status;
  String? statusLabel;
  String? createdAt;
  String? updatedAt;

  ProductCategoryData({
    this.id,
    this.name,
    this.description,
    this.image,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
  });

  ProductCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    statusLabel = json['status_label'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ProductCategoryListResponse {
  List<ProductCategoryData>? data;

  ProductCategoryListResponse({this.data});

  factory ProductCategoryListResponse.fromJson(Map<String, dynamic> json) {
    return ProductCategoryListResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => ProductCategoryData.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
