import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../functions/uid_info_controller.dart';

final userIdProvider = FutureProvider.autoDispose((ref) => getUid());
