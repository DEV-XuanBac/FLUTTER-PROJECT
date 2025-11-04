import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeKeyConstants {
  static final String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  static final String publicKey = dotenv.env['STRIPE_PUBLIC_KEY'] ?? '';
}
