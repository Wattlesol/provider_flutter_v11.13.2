import 'package:flutter/material.dart';

// ============================================================================
// BRAND COLORS - CENTRALIZED COLOR SYSTEM
// ============================================================================

// Primary Brand Colors - Light Theme
const brandGreenLight = Color(0xFF2DB665); // Handyman Primary
const brandRedLight = Color(0xFFEF5535); // Provider Primary
const brandYellowLight = Color(0xFFF0B521); // Accent/Secondary
const brandBlueLight = Color(0xFF4A75FB); // Accent/Secondary

// Primary Brand Colors - Dark Theme
const brandGreenDark = Color(0xFF005F2D); // Handyman Primary (Dark)
const brandRedDark = Color(0xFF9B1F0B); // Provider Primary (Dark)
const brandYellowDark = Color(0xFF8D6710); // Accent/Secondary (Dark)
const brandBlueDark = Color(0xFF004CB2); // Accent/Secondary (Dark)

// ============================================================================
// UI COLORS - NEUTRAL AND BACKGROUND COLORS
// ============================================================================

const ryColor = Color(0xfff1f1f6);
const lightPrimaryColor = Color(0xffebebf7);
const cardColor = Color(0xFFF6F7F9);

// Text Colors
const appTextPrimaryColor = Color(0xff1C1F34);
const appTextSecondaryColor = Color(0xff6C757D);
const borderColor = Color(0xFFEBEBEB);

// Dark Theme Colors
const scaffoldColorDark = Color(0xFF0E1116);
const scaffoldSecondaryDark = Color(0xFF1C1F26);
const appButtonColorDark = Color(0xFF282828);

// Utility Colors
const primaryColorWithOpacity = Color(0xFFBCBCC7);
const ratingBarColor = Color(0xfff5c609);

// ============================================================================
// STATUS COLORS - USING BRAND COLORS FOR CONSISTENCY
// ============================================================================

// Booking Status Colors
const pending = brandRedLight;
const accept = brandGreenLight;
const on_going = brandYellowLight;
const in_progress = brandBlueLight;
const hold = brandYellowLight;
const cancelled = brandRedLight;
const rejected = brandRedDark;
const failed = brandRedLight;
const completed = brandGreenLight;
const defaultStatus = brandGreenLight;
const pendingApprovalColor = brandBlueDark;
const waiting = brandBlueLight;

// Activity Status Colors
const add_booking = brandRedLight;
const assigned_booking = brandYellowLight;
const transfer_booking = brandGreenLight;
const update_booking_status = brandGreenLight;
const cancel_booking = brandRedLight;
const payment_message_status = brandYellowLight;
const defaultActivityStatus = brandGreenLight;

// ============================================================================
// SPECIALIZED COLORS - SPECIFIC FEATURES
// ============================================================================

// Wallet Colors
const add_wallet = Color(0xFF3CAE5C);
const update_wallet = Color(0xFFFFBD49);
const wallet_payout_transfer = Color(0xFFFD6922);

// Rating Colors
const rattingColor = Color(0xfff5c609);
const showRedForZeroRatingColor = Color(0xFFFA6565);

// Feature-Specific Colors
const startDriveButtonColor = Color(0xff40c474);
const addExtraCharge = Color(0xFFFD6922);
const promotionalBannerPendingStatus = Color(0xFFF88A16);

// Service Approval Colors
const pending_service = Color(0xFFF98900);
const rejected_service = Color(0xFFFB2F2F);
const approved_service = Color(0xFF3CAE5C);
