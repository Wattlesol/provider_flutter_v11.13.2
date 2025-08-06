import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/product_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class AddProductScreen extends StatefulWidget {
  final ProductData? product;

  AddProductScreen({this.product});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController basePriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController lowStockController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController dimensionsController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode shortDescriptionFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode sellingPriceFocus = FocusNode();
  FocusNode skuFocus = FocusNode();
  FocusNode stockFocus = FocusNode();
  FocusNode lowStockFocus = FocusNode();
  FocusNode weightFocus = FocusNode();
  FocusNode dimensionsFocus = FocusNode();

  List<ProductCategoryData> categories = [];
  ProductCategoryData? selectedCategory;

  List<File> imageFiles = [];
  List<String> existingImages = [];

  bool isFeatured = false;
  bool isActive = true;
  bool trackInventory = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getCategories();

    if (widget.product != null) {
      setProductData();
    }
  }

  Future<void> getCategories() async {
    appStore.setLoading(true);

    await getProductCategories().then((response) {
      categories = response.data ?? [];

      if (widget.product != null && widget.product!.productCategoryId != null) {
        selectedCategory = categories.firstWhere(
          (cat) => cat.id == widget.product!.productCategoryId,
          orElse: () =>
              categories.isNotEmpty ? categories.first : ProductCategoryData(),
        );
      }

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void setProductData() {
    if (widget.product == null) return;

    final product = widget.product!;
    nameController.text = product.name.validate();
    descriptionController.text = product.description.validate();
    shortDescriptionController.text = product.shortDescription.validate();
    basePriceController.text = product.basePrice.toString();
    sellingPriceController.text =
        (product.sellingPrice ?? product.basePrice).toString();
    skuController.text = product.sku.validate();
    stockController.text = product.stockQuantity.toString();
    lowStockController.text = (product.lowStockThreshold ?? 10).toString();
    weightController.text = product.weight.toString();
    dimensionsController.text = product.dimensions.validate();

    isFeatured = product.isFeaturedProduct;
    isActive = product.isActive;
    trackInventory = product.trackInventory ?? true;

    existingImages = product.imageAttachments ?? [];
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      setState(() {
        imageFiles.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  void removeImage(int index, {bool isExisting = false}) {
    setState(() {
      if (isExisting) {
        existingImages.removeAt(index);
      } else {
        imageFiles.removeAt(index);
      }
    });
  }

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      toast('Please select a category');
      return;
    }

    Map<String, dynamic> request = {
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'base_price': basePriceController.text.trim(),
      'selling_price': sellingPriceController.text.trim(),
      'short_description': shortDescriptionController.text.trim(),
      'low_stock_threshold': lowStockController.text.trim(),
      'track_inventory': trackInventory,
      'product_category_id': selectedCategory!.id,
      'sku': skuController.text.trim(),
      'stock_quantity': stockController.text.trim(),
      'status': isActive ? 1 : 0,
      'is_featured': isFeatured ? 1 : 0,
      'weight': weightController.text.trim().isNotEmpty
          ? weightController.text.trim()
          : '0',
      'dimensions': dimensionsController.text.trim(),
    };

    if (widget.product != null) {
      // Update existing product
      appStore.setLoading(true);

      await updateProduct(widget.product!.id.validate(), request).then((value) {
        appStore.setLoading(false);
        toast('Product updated successfully');
        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    } else {
      // Create new product
      if (imageFiles.isEmpty) {
        toast('Please add at least one product image');
        return;
      }

      // Create new product with multipart
      appStore.setLoading(true);

      await createProduct(request).then((value) {
        appStore.setLoading(false);
        toast('Product created successfully');
        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Edit Product' : 'Add Product'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: BackWidget(),
        actions: [
          TextButton(
            onPressed: saveProduct,
            child: Text(
              'Save',
              style: boldTextStyle(color: white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: AnimatedScrollView(
              padding: EdgeInsets.all(16),
              children: [
                // Product Images
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: context.cardColor,
                    borderRadius: radius(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Images', style: boldTextStyle()),
                      16.height,

                      // Existing Images
                      if (existingImages.isNotEmpty) ...[
                        Text('Current Images:', style: secondaryTextStyle()),
                        8.height,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: existingImages.asMap().entries.map((entry) {
                            return Stack(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: boxDecorationWithRoundedCorners(
                                    borderRadius: radius(8),
                                  ),
                                  child: Image.network(
                                    entry.value,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(8),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: redColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: white,
                                      size: 16,
                                    ).onTap(() => removeImage(entry.key,
                                        isExisting: true)),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        16.height,
                      ],

                      // New Images
                      if (imageFiles.isNotEmpty) ...[
                        Text('New Images:', style: secondaryTextStyle()),
                        8.height,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: imageFiles.asMap().entries.map((entry) {
                            return Stack(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: boxDecorationWithRoundedCorners(
                                    borderRadius: radius(8),
                                  ),
                                  child: Image.file(
                                    entry.value,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(8),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: redColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: white,
                                      size: 16,
                                    ).onTap(() => removeImage(entry.key)),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        16.height,
                      ],

                      // Add Images Button
                      AppButton(
                        text: 'Add Images',
                        textStyle: boldTextStyle(color: primaryColor),
                        color: primaryColor.withValues(alpha: 0.1),
                        elevation: 0,
                        onTap: pickImages,
                      ),
                    ],
                  ),
                ),

                24.height,

                // Product Details
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: context.cardColor,
                    borderRadius: radius(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Details', style: boldTextStyle()),
                      16.height,

                      // Product Name
                      AppTextField(
                        controller: nameController,
                        focus: nameFocus,
                        nextFocus: descriptionFocus,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(
                          context,
                          hint: 'Product Name',
                          fillColor: context.scaffoldBackgroundColor,
                        ),
                        validator: (value) {
                          if (value.validate().isEmpty)
                            return 'Product name is required';
                          return null;
                        },
                      ),

                      16.height,

                      // Description
                      AppTextField(
                        controller: descriptionController,
                        focus: descriptionFocus,
                        nextFocus: priceFocus,
                        textFieldType: TextFieldType.MULTILINE,
                        maxLines: 3,
                        decoration: inputDecoration(
                          context,
                          hint: 'Product Description',
                          fillColor: context.scaffoldBackgroundColor,
                        ),
                      ),

                      16.height,

                      // Price and Category Row
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: basePriceController,
                              focus: priceFocus,
                              nextFocus: skuFocus,
                              textFieldType: TextFieldType.PHONE,
                              decoration: inputDecoration(
                                context,
                                hint: 'Price',
                                fillColor: context.scaffoldBackgroundColor,
                              ),
                              validator: (value) {
                                if (value.validate().isEmpty)
                                  return 'Price is required';
                                if (double.tryParse(value!) == null)
                                  return 'Invalid price';
                                return null;
                              },
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: DropdownButtonFormField<ProductCategoryData>(
                              value: selectedCategory,
                              decoration: inputDecoration(
                                context,
                                hint: 'Category',
                                fillColor: context.scaffoldBackgroundColor,
                              ),
                              items: categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.validate()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedCategory = value;
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null)
                                  return 'Category is required';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      16.height,

                      // SKU and Stock Row
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: skuController,
                              focus: skuFocus,
                              nextFocus: stockFocus,
                              textFieldType: TextFieldType.OTHER,
                              decoration: inputDecoration(
                                context,
                                hint: 'SKU',
                                fillColor: context.scaffoldBackgroundColor,
                              ),
                              validator: (value) {
                                if (value.validate().isEmpty)
                                  return 'SKU is required';
                                return null;
                              },
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: AppTextField(
                              controller: stockController,
                              focus: stockFocus,
                              nextFocus: weightFocus,
                              textFieldType: TextFieldType.PHONE,
                              decoration: inputDecoration(
                                context,
                                hint: 'Stock Quantity',
                                fillColor: context.scaffoldBackgroundColor,
                              ),
                              validator: (value) {
                                if (value.validate().isEmpty)
                                  return 'Stock is required';
                                if (int.tryParse(value!) == null)
                                  return 'Invalid stock';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      16.height,

                      // Weight and Dimensions Row
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: weightController,
                              focus: weightFocus,
                              nextFocus: dimensionsFocus,
                              textFieldType: TextFieldType.PHONE,
                              decoration: inputDecoration(
                                context,
                                hint: 'Weight (kg)',
                                fillColor: context.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: AppTextField(
                              controller: dimensionsController,
                              focus: dimensionsFocus,
                              textFieldType: TextFieldType.OTHER,
                              decoration: inputDecoration(
                                context,
                                hint: 'Dimensions (LxWxH)',
                                fillColor: context.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      16.height,

                      // Switches
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: Text('Featured Product',
                                  style: primaryTextStyle()),
                              value: isFeatured,
                              onChanged: (value) {
                                isFeatured = value ?? false;
                                setState(() {});
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: Text('Active', style: primaryTextStyle()),
                              value: isActive,
                              onChanged: (value) {
                                isActive = value ?? true;
                                setState(() {});
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                24.height,

                // Save Button
                AppButton(
                  text:
                      widget.product != null ? 'Update Product' : 'Add Product',
                  color: primaryColor,
                  textStyle: boldTextStyle(color: white),
                  width: context.width(),
                  onTap: saveProduct,
                ),
              ],
            ),
          ),
          Observer(
            builder: (context) =>
                LoaderWidget().center().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
