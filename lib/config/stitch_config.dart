class StitchConfig {
  static const String projectId = '17601237681150490789';

  static const Map<String, String> screenIds = {
    // Auth & Onboarding
    'splash': '9a55e9f23f09461fabca319699e2011c',
    'onboarding': '609f053e717445c8b144279e575a1206', // Aspirational Onboarding
    'login': '5cf48be27a8f4a388c899554f3dc3d5c',
    'signup': '99c314d8f49143839b40d211aaa77786',
    'forgot_password': '93e8427ce7f14fecb8797d2652db5f4e',
    'verify_otp': 'd1bcb8a6186543448cfd49fb78fbf057',

    // Core Interaction
    'home': '7f35f249a9b448bd825bc3f7f56599c5',
    'product_detail': '4d1a3b00261b4eb88bda50adecc366a8',
    'search': 'bea0dcab9d4c4cb7a7214d2f69b43a62',
    'search_results': 'fe46623e6b574c52a376fe3621ed9dbb',
    'filter': '32fa65f397444c0fa23e9269717d69c2',
    'wishlist': 'dace006b169541c1b5f2f766ffa76b76', // Your Design Selection
    // Checkout & Orders
    'checkout': '8dde548348d54c279b03004c23f9ce54',
    'orders': '94c47297e18a4a49b57622dd9ddedc80',
    'order_details': 'dd93d525134145dfafe62557d892da52',
    'delivery_tracking': '58ba45d35b194a34ae2b884178f8ea17',
    'order_confirmation': 'e6d75c7963e34bac9e265720536ce20f',

    // Profile & Settings
    'profile': '518ee69b71f844679989b0c567e0f7c8',
    'settings': 'db96a4b7ea044e449a744197be38e80d',
    'addresses': '8843aa9cfdcd43e4964a8334c93b19e9',
    'concierge': '2e06e82c416a49bb9fed60b59ae183b3',
    'gallery': '3a05e686ce904c6d898ac15ff1560d72',
    'reviews': 'e606dfbf668c48daa5e8ebaf3814e48a',
    'ar_preview': 'b4ecdc7557874270b35d03c98fe5e2c2',
    'store_locator': '9830d7b97cd644e2887ae443b2bd8fc7',

    // Stitch Extras
    'shipping_selection': 'ba7ffe80be41440b9c3f9f35796e6848',
    'card_management': '16a7ee43ad4841f9bf60d29a131f73fe',
    'craftsmanship_onboarding': '215e8fee0f0d47ceb812cfd81b2b5782',
    'personalization_onboarding': 'ac9ecfb98af7423f80b23cecfc5e560d',
  };
}
