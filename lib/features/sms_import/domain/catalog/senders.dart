/// What kind of institution a sender is; picks its icon in the sender list.
enum SmsSenderType { bank, wallet, instant }

/// A bank or wallet whose messages SMS Import knows. [aliases] are the
/// normalised sender IDs it texts from (see [SenderCatalog.normalize]).
class SmsSender {
  const SmsSender({required this.id, required this.name, required this.aliases, this.type = SmsSenderType.bank});

  /// Stable key, e.g. `cib`.
  final String id;

  /// Display name (a brand, shown as it is in both languages).
  final String name;
  final List<String> aliases;
  final SmsSenderType type;
}

/// The built-in banks and wallets. Messages from any other sender are only
/// imported after the user trusts it.
abstract final class SenderCatalog {
  static const senders = <SmsSender>[
    // Egypt
    SmsSender(id: 'egbank', name: 'EG Bank', aliases: ['EGBANK']),
    SmsSender(id: 'cib', name: 'CIB', aliases: ['CIB', 'CIBEG', 'CIBEGYPT']),
    SmsSender(id: 'nbe', name: 'NBE', aliases: ['NBE', 'NBEEG', 'NBEEGYPT']),
    SmsSender(id: 'banquemisr', name: 'Banque Misr', aliases: ['BANQUEMISR', 'BMISR']),
    SmsSender(id: 'qnb', name: 'QNB', aliases: ['QNB', 'QNBALAHLI', 'QNBEG']),
    SmsSender(id: 'bdc', name: 'Banque du Caire', aliases: ['BANQUEDUCAIRE', 'BDC']),
    SmsSender(id: 'aaib', name: 'AAIB', aliases: ['AAIB']),
    SmsSender(id: 'hsbc', name: 'HSBC', aliases: ['HSBC', 'HSBCEG']),
    SmsSender(
      id: 'vodafonecash',
      name: 'Vodafone Cash',
      aliases: ['VODAFONECASH', 'VFCASH'],
      type: SmsSenderType.wallet,
    ),
    SmsSender(id: 'instapay', name: 'InstaPay', aliases: ['INSTAPAY', 'IPN'], type: SmsSenderType.instant),
    SmsSender(id: 'fawry', name: 'Fawry', aliases: ['FAWRY'], type: SmsSenderType.wallet),
    SmsSender(id: 'orangecash', name: 'Orange Cash', aliases: ['ORANGECASH'], type: SmsSenderType.wallet),
    SmsSender(id: 'etisalatcash', name: 'Etisalat Cash', aliases: ['ETISALATCASH'], type: SmsSenderType.wallet),
    // Saudi Arabia
    SmsSender(id: 'alrajhi', name: 'Al Rajhi', aliases: ['ALRAJHI', 'ALRAJHIBANK']),
    SmsSender(id: 'snb', name: 'SNB', aliases: ['SNB', 'ALAHLI', 'SNBALAHLI']),
    SmsSender(id: 'riyad', name: 'Riyad Bank', aliases: ['RIYADBANK', 'RIYAD']),
    SmsSender(id: 'stcpay', name: 'STC Pay', aliases: ['STCPAY'], type: SmsSenderType.wallet),
    // UAE
    SmsSender(id: 'enbd', name: 'Emirates NBD', aliases: ['ENBD', 'EMIRATESNBD']),
    SmsSender(id: 'adcb', name: 'ADCB', aliases: ['ADCB']),
  ];

  /// Upper case, letters and digits only: `Vodafone-Cash` becomes `VODAFONECASH`.
  static String normalize(String sender) => sender.toUpperCase().replaceAll(RegExp('[^A-Z0-9\u0600-\u06FF]'), '');

  /// The built-in sender [address] belongs to, or null.
  static SmsSender? lookup(String address) {
    final normalized = normalize(address);
    if (normalized.isEmpty) return null;
    for (final sender in senders) {
      if (sender.aliases.contains(normalized)) return sender;
    }
    return null;
  }

  static bool isKnown(String address) => lookup(address) != null;

  /// The name to show for [address]: the bank's, or the address itself.
  static String displayName(String address) => lookup(address)?.name ?? address.trim();

  /// The key a sender is remembered by: the built-in sender's id (so every
  /// alias shares one switch), else the address as it was received.
  static String keyOf(String address) => lookup(address)?.id ?? address.trim();

  /// A phone number, i.e. a person rather than a bank (banks text from a
  /// name or a short code). These never get a "Trust this sender?" prompt.
  static bool looksPersonal(String address) => RegExp(r'^\+?[\d\s-]{7,}$').hasMatch(address.trim());
}
