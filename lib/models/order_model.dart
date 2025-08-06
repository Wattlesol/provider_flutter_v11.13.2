import 'package:handyman_provider_flutter/models/pagination_model.dart';
import 'package:handyman_provider_flutter/models/product_model.dart';

class OrderListResponse {
  List<OrderData>? data;
  Pagination? pagination;
  String? totalRevenue;
  OrderSummary? orderSummary;

  OrderListResponse(
      {this.data, this.pagination, this.totalRevenue, this.orderSummary});

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => OrderData.fromJson(i)).toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      totalRevenue: json['total_revenue'],
      orderSummary: json['order_summary'] != null
          ? OrderSummary.fromJson(json['order_summary'])
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
    data['total_revenue'] = this.totalRevenue;
    if (this.orderSummary != null) {
      data['order_summary'] = this.orderSummary!.toJson();
    }
    return data;
  }
}

class OrderSummary {
  int? totalOrders;
  int? pendingOrders;
  int? confirmedOrders;
  int? shippedOrders;
  int? deliveredOrders;
  int? cancelledOrders;
  String? totalRevenue;

  OrderSummary({
    this.totalOrders,
    this.pendingOrders,
    this.confirmedOrders,
    this.shippedOrders,
    this.deliveredOrders,
    this.cancelledOrders,
    this.totalRevenue,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      totalOrders: json['total_orders'],
      pendingOrders: json['pending_orders'],
      confirmedOrders: json['confirmed_orders'],
      shippedOrders: json['shipped_orders'],
      deliveredOrders: json['delivered_orders'],
      cancelledOrders: json['cancelled_orders'],
      totalRevenue: json['total_revenue'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_orders'] = this.totalOrders;
    data['pending_orders'] = this.pendingOrders;
    data['confirmed_orders'] = this.confirmedOrders;
    data['shipped_orders'] = this.shippedOrders;
    data['delivered_orders'] = this.deliveredOrders;
    data['cancelled_orders'] = this.cancelledOrders;
    data['total_revenue'] = this.totalRevenue;
    return data;
  }
}

class OrderData {
  int? id;
  String? orderNumber;
  int? customerId;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? customerImage;
  String? status;
  String? statusLabel;
  num? totalAmount;
  String? totalAmountFormat;
  num? subtotal;
  num? taxAmount;
  num? shippingAmount;
  num? discountAmount;
  String? paymentStatus;
  String? paymentMethod;
  String? shippingAddress;
  String? billingAddress;
  String? notes;
  String? trackingNumber;
  String? createdAt;
  String? updatedAt;
  List<OrderItemData>? orderItems;

  // Local properties
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get isPaid => paymentStatus == 'paid';
  bool get canUpdateStatus => !isDelivered && !isCancelled;

  OrderData({
    this.id,
    this.orderNumber,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.customerImage,
    this.status,
    this.statusLabel,
    this.totalAmount,
    this.totalAmountFormat,
    this.subtotal,
    this.taxAmount,
    this.shippingAmount,
    this.discountAmount,
    this.paymentStatus,
    this.paymentMethod,
    this.shippingAddress,
    this.billingAddress,
    this.notes,
    this.trackingNumber,
    this.createdAt,
    this.updatedAt,
    this.orderItems,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];

    // Handle nested customer object
    if (json['customer'] != null && json['customer'] is Map) {
      var customer = json['customer'] as Map<String, dynamic>;
      customerId = customer['id'];
      customerName = customer['name'];
      customerEmail = customer['email'];
      customerPhone = customer['phone'];
      customerImage = customer['image'];
    } else {
      // Fallback to direct fields
      customerId = json['customer_id'];
      customerName = json['customer_name'];
      customerEmail = json['customer_email'];
      customerPhone = json['customer_phone'];
      customerImage = json['customer_image'];
    }

    status = _parseString(json['status']);
    statusLabel = _parseString(json['status_label']);

    // Handle numeric fields that might come as strings
    totalAmount = _parseNumeric(json['total_amount']);
    totalAmountFormat = json['total_amount_format'];
    subtotal = _parseNumeric(json['subtotal']);
    taxAmount = _parseNumeric(json['tax_amount']);
    shippingAmount = _parseNumeric(json['delivery_fee']) ??
        _parseNumeric(json['shipping_amount']);
    discountAmount = _parseNumeric(json['discount_amount']);

    paymentStatus = _parseString(json['payment_status']);
    paymentMethod = _parseString(json['payment_method']);

    // Handle delivery address
    if (json['delivery_address'] != null && json['delivery_address'] is Map) {
      var address = json['delivery_address'] as Map<String, dynamic>;
      shippingAddress =
          '${address['name']}, ${address['address']}, ${address['city']}';
    } else {
      shippingAddress = json['shipping_address'];
    }

    billingAddress = _parseString(json['billing_address']);
    notes = _parseString(json['delivery_notes']) ?? _parseString(json['notes']);
    trackingNumber = _parseString(json['tracking_number']);
    createdAt = _parseString(json['created_at']);
    updatedAt = _parseString(json['updated_at']);

    // Handle order items
    if (json['items'] != null && json['items'] is List) {
      orderItems = (json['items'] as List)
          .map((i) => OrderItemData.fromJson(i))
          .toList();
    } else if (json['order_items'] != null && json['order_items'] is List) {
      orderItems = (json['order_items'] as List)
          .map((i) => OrderItemData.fromJson(i))
          .toList();
    }
  }

  // Helper method to parse numeric values that might come as strings
  num? _parseNumeric(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  // Helper method to parse string values that might come as other types
  String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['customer_phone'] = this.customerPhone;
    data['customer_image'] = this.customerImage;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['total_amount'] = this.totalAmount;
    data['total_amount_format'] = this.totalAmountFormat;
    data['subtotal'] = this.subtotal;
    data['tax_amount'] = this.taxAmount;
    data['shipping_amount'] = this.shippingAmount;
    data['discount_amount'] = this.discountAmount;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['shipping_address'] = this.shippingAddress;
    data['billing_address'] = this.billingAddress;
    data['notes'] = this.notes;
    data['tracking_number'] = this.trackingNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItemData {
  int? id;
  int? orderId;
  int? productId;
  String? productName;
  String? productImage;
  String? productSku;
  int? quantity;
  num? unitPrice;
  String? unitPriceFormat;
  num? totalPrice;
  String? totalPriceFormat;
  ProductData? product;

  OrderItemData({
    this.id,
    this.orderId,
    this.productId,
    this.productName,
    this.productImage,
    this.productSku,
    this.quantity,
    this.unitPrice,
    this.unitPriceFormat,
    this.totalPrice,
    this.totalPriceFormat,
    this.product,
  });

  OrderItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];

    // Handle nested product object
    if (json['product'] != null && json['product'] is Map) {
      var product = json['product'] as Map<String, dynamic>;
      productId = product['id'];
      productName = _parseStringItem(product['name']);
      productImage = _parseStringItem(product['image']);
      productSku = _parseStringItem(product['sku']);
      this.product = ProductData.fromJson(product);
    } else {
      // Fallback to direct fields
      productId = json['product_id'];
      productName = _parseStringItem(json['product_name']);
      productImage = _parseStringItem(json['product_image']);
      productSku = _parseStringItem(json['product_sku']);
      product = json['product'] != null
          ? ProductData.fromJson(json['product'])
          : null;
    }

    quantity = json['quantity'];
    unitPrice = _parseNumeric(json['unit_price']);
    unitPriceFormat = json['unit_price_format'];
    totalPrice = _parseNumeric(json['total_price']);
    totalPriceFormat = json['total_price_format'];
  }

  // Helper method to parse numeric values that might come as strings
  num? _parseNumeric(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  // Helper method to parse string values that might come as other types
  String? _parseStringItem(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['product_sku'] = this.productSku;
    data['quantity'] = this.quantity;
    data['unit_price'] = this.unitPrice;
    data['unit_price_format'] = this.unitPriceFormat;
    data['total_price'] = this.totalPrice;
    data['total_price_format'] = this.totalPriceFormat;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
