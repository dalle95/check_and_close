import 'package:check_and_close/common/entities/wo.dart';

import '/common/entities/woprocess.dart';

class WODetailState {
  const WODetailState({
    this.wo,
    this.woprocess = const [],
  });

  final WO? wo;
  final List<WOProcess>? woprocess;

  WODetailState copyWith({
    WO? wo,
    List<WOProcess>? woprocess,
  }) {
    return WODetailState(
      wo: wo ?? this.wo,
      woprocess: woprocess ?? this.woprocess,
    );
  }
}
