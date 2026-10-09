/// The five real EG Bank messages of the PRD (`Template Spec: EG Bank`), verbatim, odd spacing
/// included. The Arabic is written as escapes so the spaces can't be reflowed by an editor.
abstract final class EgBankSamples {
  /// Sample 1: money received by InstaPay.
  static const instaPayCredit =
      'Your account was credited by EGP 200 on 07-10 14:33 IPN REF# 65520277090 from NADA MOHAMED ABDELM** for details please call 19342';

  /// Sample 2: a purchase through GEIDEA, with a terminal code after the city.
  static const purchaseGeidea =
      '\u062a\u0645 \u0627\u0644\u0634\u0631\u0627\u0621 \u0628\u0645\u0628\u0644\u063a 143.37\u062c\u0645 \u0639\u0644\u0649 \u0627\u0644\u0643\u0627\u0631\u062a \u0631\u0642\u0645  +++9033 \u0645\u0646 GEIDEA ALBAN ZAHER 6  CAIRO S 07E';

  /// Sample 3: money sent by InstaPay, to nobody in particular.
  static const instaPayDebit =
      'Your account was charged by EGP 260 on 05-10 17:53 IPN REF# 13192168771 for details please call 19342';

  /// Sample 4: a purchase at Uber (the spaces are the bank's).
  static const purchaseUber =
      '\u062a\u0645 \u0627\u0644\u0634\u0631\u0627\u0621 \u0628\u0645\u0628\u0644\u063a 5\u062c\u0645 \u0639\u0644\u0649 \u0627\u0644\u0643\u0627\u0631\u062a \u0631\u0642\u0645  +++9033 \u0645\u0646 Uber                  Downtown';

  /// Sample 5: the cancellation of sample 4.
  static const cancelUber =
      '\u062a\u0645 \u0627\u0644\u063a\u0627\u0621 \u0627\u0644\u0634\u0631\u0627\u0621 \u0628\u0645\u0628\u0644\u063a 5\u062c\u0645 \u0639\u0644\u0649 \u0627\u0644\u0643\u0627\u0631\u062a \u0631\u0642\u0645  +++9033 \u0645\u0646 Uber                  Downtown';
}
