import 'package:go_router/go_router.dart';
import 'models/order.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/verify_otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/payment_methods_screen.dart';
import 'screens/mobile_money_payment_screen.dart';
import 'screens/add_new_card_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/ar_preview_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/delivery_tracking_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/product_reviews_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/addresses_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/search_screen.dart';
import 'screens/filter_screen.dart';
import 'screens/search_results_screen.dart';
import 'screens/concierge_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notification_preferences_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/store_locator_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/design_consultation_screen.dart';
import 'screens/showroom_visit_screen.dart';
import 'screens/personal_information_screen.dart';
import 'screens/password_security_screen.dart';
import 'screens/theme_settings_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: '/', // Root path
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      name: '/verify-otp',
      builder: (context, state) => const VerifyOtpScreen(),
    ),
    GoRoute(
      path: '/home',
      name: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/payment-methods',
      name: '/payment-methods',
      builder: (context, state) => const PaymentMethodsScreen(),
    ),
    GoRoute(
      path: '/mobile-money-payment',
      name: '/mobile-money-payment',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final total = extras?['total'] as double? ?? 0.0;
        return MobileMoneyPaymentScreen(total: total);
      },
    ),
    GoRoute(
      path: '/add-new-card',
      name: '/add-new-card',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final total = extras?['total'] as double? ?? 0.0;
        return AddNewCardScreen(total: total);
      },
    ),
    GoRoute(
      path: '/product-detail/:id',
      name: '/product-detail',
      builder: (context, state) {
        final id =
            state.pathParameters['id'] ?? 'prod_1'; // Fallback for dev/testing
        return ProductDetailScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/ar-preview',
      name: '/ar-preview',
      builder: (context, state) => const ArPreviewScreen(),
    ),
    GoRoute(
      path: '/order-confirmation',
      name: '/order-confirmation',
      builder: (context, state) {
        final order = state.extra as Order?;
        return OrderConfirmationScreen(order: order);
      },
    ),
    GoRoute(
      path: '/delivery-tracking',
      name: '/delivery-tracking',
      builder: (context, state) => const DeliveryTrackingScreen(),
    ),
    GoRoute(
      path: '/order-details/:orderId',
      name: '/order-details',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? '';
        return OrderDetailsScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/product-reviews',
      name: '/product-reviews',
      builder: (context, state) => const ProductReviewsScreen(),
    ),
    GoRoute(
      path: '/wishlist',
      name: '/wishlist',
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(
      path: '/addresses',
      name: '/addresses',
      builder: (context, state) => const AddressesScreen(),
    ),
    GoRoute(
      path: '/cart',
      name: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/search',
      name: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/filter',
      name: '/filter',
      builder: (context, state) => const FilterScreen(),
    ),
    GoRoute(
      path: '/search-results',
      name: '/search-results',
      builder: (context, state) => const SearchResultsScreen(),
    ),
    GoRoute(
      path: '/concierge',
      name: '/concierge',
      builder: (context, state) => const ConciergeScreen(),
    ),
    GoRoute(
      path: '/design-consultation',
      name: '/design-consultation',
      builder: (context, state) => const DesignConsultationScreen(),
    ),
    GoRoute(
      path: '/showroom-visit',
      name: '/showroom-visit',
      builder: (context, state) => const ShowroomVisitScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/notification-preferences',
      name: '/notification-preferences',
      builder: (context, state) => const NotificationPreferencesScreen(),
    ),
    GoRoute(
      path: '/gallery',
      name: '/gallery',
      builder: (context, state) => const GalleryScreen(),
    ),
    GoRoute(
      path: '/store-locator',
      name: '/store-locator',
      builder: (context, state) => const StoreLocatorScreen(),
    ),
    GoRoute(
      path: '/orders',
      name: '/orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/chat',
      name: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/personal-information',
      name: '/personal-information',
      builder: (context, state) => const PersonalInformationScreen(),
    ),
    GoRoute(
      path: '/password-security',
      name: '/password-security',
      builder: (context, state) => const PasswordSecurityScreen(),
    ),
    GoRoute(
      path: '/theme-settings',
      name: '/theme-settings',
      builder: (context, state) => const ThemeSettingsScreen(),
    ),
  ],
);
