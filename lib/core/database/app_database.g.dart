// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seedKeyMeta = const VerificationMeta(
    'seedKey',
  );
  @override
  late final GeneratedColumn<String> seedKey = GeneratedColumn<String>(
    'seed_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    check: () => kind.isIn(const ['expense', 'income']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('expense'),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isHiddenMeta = const VerificationMeta(
    'isHidden',
  );
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
    'is_hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seedKey,
    name,
    kind,
    icon,
    color,
    sortOrder,
    isHidden,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('seed_key')) {
      context.handle(
        _seedKeyMeta,
        seedKey.isAcceptableOrUnknown(data['seed_key']!, _seedKeyMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_hidden')) {
      context.handle(
        _isHiddenMeta,
        isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_key'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isHidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hidden'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final int id;
  final String? seedKey;
  final String? name;

  /// `expense` or `income`: every transaction in the category is of this kind.
  /// It can't change while an expense or template references the category.
  final String kind;

  /// Key into the curated icon registry, not a raw Material icon name.
  final String icon;

  /// ARGB colour.
  final int color;
  final int sortOrder;
  final bool isHidden;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoriesTableData({
    required this.id,
    this.seedKey,
    this.name,
    required this.kind,
    required this.icon,
    required this.color,
    required this.sortOrder,
    required this.isHidden,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || seedKey != null) {
      map['seed_key'] = Variable<String>(seedKey);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['kind'] = Variable<String>(kind);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_hidden'] = Variable<bool>(isHidden);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      seedKey: seedKey == null && nullToAbsent
          ? const Value.absent()
          : Value(seedKey),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      kind: Value(kind),
      icon: Value(icon),
      color: Value(color),
      sortOrder: Value(sortOrder),
      isHidden: Value(isHidden),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      seedKey: serializer.fromJson<String?>(json['seedKey']),
      name: serializer.fromJson<String?>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seedKey': serializer.toJson<String?>(seedKey),
      'name': serializer.toJson<String?>(name),
      'kind': serializer.toJson<String>(kind),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isHidden': serializer.toJson<bool>(isHidden),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoriesTableData copyWith({
    int? id,
    Value<String?> seedKey = const Value.absent(),
    Value<String?> name = const Value.absent(),
    String? kind,
    String? icon,
    int? color,
    int? sortOrder,
    bool? isHidden,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoriesTableData(
    id: id ?? this.id,
    seedKey: seedKey.present ? seedKey.value : this.seedKey,
    name: name.present ? name.value : this.name,
    kind: kind ?? this.kind,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    sortOrder: sortOrder ?? this.sortOrder,
    isHidden: isHidden ?? this.isHidden,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      seedKey: data.seedKey.present ? data.seedKey.value : this.seedKey,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('seedKey: $seedKey, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isHidden: $isHidden, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    seedKey,
    name,
    kind,
    icon,
    color,
    sortOrder,
    isHidden,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.seedKey == this.seedKey &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder &&
          other.isHidden == this.isHidden &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<int> id;
  final Value<String?> seedKey;
  final Value<String?> name;
  final Value<String> kind;
  final Value<String> icon;
  final Value<int> color;
  final Value<int> sortOrder;
  final Value<bool> isHidden;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    required String icon,
    required int color,
    required int sortOrder,
    this.isHidden = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : icon = Value(icon),
       color = Value(color),
       sortOrder = Value(sortOrder);
  static Insertable<CategoriesTableData> custom({
    Expression<int>? id,
    Expression<String>? seedKey,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<int>? sortOrder,
    Expression<bool>? isHidden,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seedKey != null) 'seed_key': seedKey,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isHidden != null) 'is_hidden': isHidden,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? seedKey,
    Value<String?>? name,
    Value<String>? kind,
    Value<String>? icon,
    Value<int>? color,
    Value<int>? sortOrder,
    Value<bool>? isHidden,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      seedKey: seedKey ?? this.seedKey,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isHidden: isHidden ?? this.isHidden,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seedKey.present) {
      map['seed_key'] = Variable<String>(seedKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('seedKey: $seedKey, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isHidden: $isHidden, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WalletsTableTable extends WalletsTable
    with TableInfo<$WalletsTableTable, WalletsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seedKeyMeta = const VerificationMeta(
    'seedKey',
  );
  @override
  late final GeneratedColumn<String> seedKey = GeneratedColumn<String>(
    'seed_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'UNIQUE COLLATE NOCASE CHECK (length(name) BETWEEN 1 AND 30)',
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seedKey,
    name,
    icon,
    color,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('seed_key')) {
      context.handle(
        _seedKeyMeta,
        seedKey.isAcceptableOrUnknown(data['seed_key']!, _seedKeyMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_key'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WalletsTableTable createAlias(String alias) {
    return $WalletsTableTable(attachedDatabase, alias);
  }
}

class WalletsTableData extends DataClass
    implements Insertable<WalletsTableData> {
  final int id;
  final String? seedKey;

  /// 1–30 characters. A custom constraint, because `UNIQUE COLLATE NOCASE`
  /// has no Drift builder; it carries the length check with it.
  final String? name;

  /// Key into the curated wallet icon registry.
  final String icon;

  /// ARGB colour.
  final int color;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WalletsTableData({
    required this.id,
    this.seedKey,
    this.name,
    required this.icon,
    required this.color,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || seedKey != null) {
      map['seed_key'] = Variable<String>(seedKey);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WalletsTableCompanion toCompanion(bool nullToAbsent) {
    return WalletsTableCompanion(
      id: Value(id),
      seedKey: seedKey == null && nullToAbsent
          ? const Value.absent()
          : Value(seedKey),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      icon: Value(icon),
      color: Value(color),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WalletsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletsTableData(
      id: serializer.fromJson<int>(json['id']),
      seedKey: serializer.fromJson<String?>(json['seedKey']),
      name: serializer.fromJson<String?>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seedKey': serializer.toJson<String?>(seedKey),
      'name': serializer.toJson<String?>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WalletsTableData copyWith({
    int? id,
    Value<String?> seedKey = const Value.absent(),
    Value<String?> name = const Value.absent(),
    String? icon,
    int? color,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WalletsTableData(
    id: id ?? this.id,
    seedKey: seedKey.present ? seedKey.value : this.seedKey,
    name: name.present ? name.value : this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WalletsTableData copyWithCompanion(WalletsTableCompanion data) {
    return WalletsTableData(
      id: data.id.present ? data.id.value : this.id,
      seedKey: data.seedKey.present ? data.seedKey.value : this.seedKey,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletsTableData(')
          ..write('id: $id, ')
          ..write('seedKey: $seedKey, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    seedKey,
    name,
    icon,
    color,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletsTableData &&
          other.id == this.id &&
          other.seedKey == this.seedKey &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WalletsTableCompanion extends UpdateCompanion<WalletsTableData> {
  final Value<int> id;
  final Value<String?> seedKey;
  final Value<String?> name;
  final Value<String> icon;
  final Value<int> color;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WalletsTableCompanion({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WalletsTableCompanion.insert({
    this.id = const Value.absent(),
    this.seedKey = const Value.absent(),
    this.name = const Value.absent(),
    required String icon,
    required int color,
    required int sortOrder,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : icon = Value(icon),
       color = Value(color),
       sortOrder = Value(sortOrder);
  static Insertable<WalletsTableData> custom({
    Expression<int>? id,
    Expression<String>? seedKey,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seedKey != null) 'seed_key': seedKey,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WalletsTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? seedKey,
    Value<String?>? name,
    Value<String>? icon,
    Value<int>? color,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return WalletsTableCompanion(
      id: id ?? this.id,
      seedKey: seedKey ?? this.seedKey,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seedKey.present) {
      map['seed_key'] = Variable<String>(seedKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsTableCompanion(')
          ..write('id: $id, ')
          ..write('seedKey: $seedKey, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RecurringExpensesTableTable extends RecurringExpensesTable
    with TableInfo<$RecurringExpensesTableTable, RecurringExpensesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringExpensesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(amountMinor).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wallets (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    check: () => frequency.isIn(const ['daily', 'weekly', 'monthly', 'yearly']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, String> startDate =
      GeneratedColumn<String>(
        'start_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>(
        $RecurringExpensesTableTable.$converterstartDate,
      );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, String> nextDueDate =
      GeneratedColumn<String>(
        'next_due_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>(
        $RecurringExpensesTableTable.$converternextDueDate,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amountMinor,
    walletId,
    categoryId,
    frequency,
    startDate,
    nextDueDate,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringExpensesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringExpensesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringExpensesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      startDate: $RecurringExpensesTableTable.$converterstartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}start_date'],
        )!,
      ),
      nextDueDate: $RecurringExpensesTableTable.$converternextDueDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}next_due_date'],
        )!,
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringExpensesTableTable createAlias(String alias) {
    return $RecurringExpensesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, String> $converterstartDate =
      const LocalDateConverter();
  static TypeConverter<LocalDate, String> $converternextDueDate =
      const LocalDateConverter();
}

class RecurringExpensesTableData extends DataClass
    implements Insertable<RecurringExpensesTableData> {
  final int id;
  final String title;
  final int amountMinor;

  /// The wallet its generated rows go to.
  final int walletId;

  /// The app reassigns templates to "Other" before deleting a category.
  final int categoryId;
  final String frequency;

  /// Anchor for occurrence calculation (occurrence n = startDate + n periods).
  final LocalDate startDate;
  final LocalDate nextDueDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecurringExpensesTableData({
    required this.id,
    required this.title,
    required this.amountMinor,
    required this.walletId,
    required this.categoryId,
    required this.frequency,
    required this.startDate,
    required this.nextDueDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['wallet_id'] = Variable<int>(walletId);
    map['category_id'] = Variable<int>(categoryId);
    map['frequency'] = Variable<String>(frequency);
    {
      map['start_date'] = Variable<String>(
        $RecurringExpensesTableTable.$converterstartDate.toSql(startDate),
      );
    }
    {
      map['next_due_date'] = Variable<String>(
        $RecurringExpensesTableTable.$converternextDueDate.toSql(nextDueDate),
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringExpensesTableCompanion toCompanion(bool nullToAbsent) {
    return RecurringExpensesTableCompanion(
      id: Value(id),
      title: Value(title),
      amountMinor: Value(amountMinor),
      walletId: Value(walletId),
      categoryId: Value(categoryId),
      frequency: Value(frequency),
      startDate: Value(startDate),
      nextDueDate: Value(nextDueDate),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringExpensesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringExpensesTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      walletId: serializer.fromJson<int>(json['walletId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      frequency: serializer.fromJson<String>(json['frequency']),
      startDate: serializer.fromJson<LocalDate>(json['startDate']),
      nextDueDate: serializer.fromJson<LocalDate>(json['nextDueDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'walletId': serializer.toJson<int>(walletId),
      'categoryId': serializer.toJson<int>(categoryId),
      'frequency': serializer.toJson<String>(frequency),
      'startDate': serializer.toJson<LocalDate>(startDate),
      'nextDueDate': serializer.toJson<LocalDate>(nextDueDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringExpensesTableData copyWith({
    int? id,
    String? title,
    int? amountMinor,
    int? walletId,
    int? categoryId,
    String? frequency,
    LocalDate? startDate,
    LocalDate? nextDueDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurringExpensesTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    amountMinor: amountMinor ?? this.amountMinor,
    walletId: walletId ?? this.walletId,
    categoryId: categoryId ?? this.categoryId,
    frequency: frequency ?? this.frequency,
    startDate: startDate ?? this.startDate,
    nextDueDate: nextDueDate ?? this.nextDueDate,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringExpensesTableData copyWithCompanion(
    RecurringExpensesTableCompanion data,
  ) {
    return RecurringExpensesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextDueDate: data.nextDueDate.present
          ? data.nextDueDate.value
          : this.nextDueDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpensesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('walletId: $walletId, ')
          ..write('categoryId: $categoryId, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amountMinor,
    walletId,
    categoryId,
    frequency,
    startDate,
    nextDueDate,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringExpensesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.amountMinor == this.amountMinor &&
          other.walletId == this.walletId &&
          other.categoryId == this.categoryId &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.nextDueDate == this.nextDueDate &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringExpensesTableCompanion
    extends UpdateCompanion<RecurringExpensesTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> amountMinor;
  final Value<int> walletId;
  final Value<int> categoryId;
  final Value<String> frequency;
  final Value<LocalDate> startDate;
  final Value<LocalDate> nextDueDate;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RecurringExpensesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.walletId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RecurringExpensesTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int amountMinor,
    required int walletId,
    required int categoryId,
    required String frequency,
    required LocalDate startDate,
    required LocalDate nextDueDate,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       amountMinor = Value(amountMinor),
       walletId = Value(walletId),
       categoryId = Value(categoryId),
       frequency = Value(frequency),
       startDate = Value(startDate),
       nextDueDate = Value(nextDueDate);
  static Insertable<RecurringExpensesTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? amountMinor,
    Expression<int>? walletId,
    Expression<int>? categoryId,
    Expression<String>? frequency,
    Expression<String>? startDate,
    Expression<String>? nextDueDate,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (walletId != null) 'wallet_id': walletId,
      if (categoryId != null) 'category_id': categoryId,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RecurringExpensesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? amountMinor,
    Value<int>? walletId,
    Value<int>? categoryId,
    Value<String>? frequency,
    Value<LocalDate>? startDate,
    Value<LocalDate>? nextDueDate,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RecurringExpensesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amountMinor: amountMinor ?? this.amountMinor,
      walletId: walletId ?? this.walletId,
      categoryId: categoryId ?? this.categoryId,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(
        $RecurringExpensesTableTable.$converterstartDate.toSql(startDate.value),
      );
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<String>(
        $RecurringExpensesTableTable.$converternextDueDate.toSql(
          nextDueDate.value,
        ),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpensesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('walletId: $walletId, ')
          ..write('categoryId: $categoryId, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TransfersTableTable extends TransfersTable
    with TableInfo<$TransfersTableTable, TransfersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransfersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransfersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransfersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransfersTableTable createAlias(String alias) {
    return $TransfersTableTable(attachedDatabase, alias);
  }
}

class TransfersTableData extends DataClass
    implements Insertable<TransfersTableData> {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TransfersTableData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransfersTableCompanion toCompanion(bool nullToAbsent) {
    return TransfersTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransfersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransfersTableData(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransfersTableData copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TransfersTableData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransfersTableData copyWithCompanion(TransfersTableCompanion data) {
    return TransfersTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransfersTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransfersTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransfersTableCompanion extends UpdateCompanion<TransfersTableData> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransfersTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransfersTableCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<TransfersTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransfersTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransfersTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTableTable extends ExpensesTable
    with TableInfo<$ExpensesTableTable, ExpensesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(amountMinor).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wallets (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($ExpensesTableTable.$converterdate);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurringExpenseIdMeta =
      const VerificationMeta('recurringExpenseId');
  @override
  late final GeneratedColumn<int> recurringExpenseId = GeneratedColumn<int>(
    'recurring_expense_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurring_expenses (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate?, String>
  occurrenceDate = GeneratedColumn<String>(
    'occurrence_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<LocalDate?>($ExpensesTableTable.$converteroccurrenceDaten);
  static const VerificationMeta _transferIdMeta = const VerificationMeta(
    'transferId',
  );
  @override
  late final GeneratedColumn<int> transferId = GeneratedColumn<int>(
    'transfer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transfers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    true,
    check: () => direction.isIn(const ['out', 'in']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    check: () => source.isIn(const ['manual', 'sms', 'recurring']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amountMinor,
    walletId,
    categoryId,
    date,
    note,
    recurringExpenseId,
    occurrenceDate,
    transferId,
    direction,
    source,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpensesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('recurring_expense_id')) {
      context.handle(
        _recurringExpenseIdMeta,
        recurringExpenseId.isAcceptableOrUnknown(
          data['recurring_expense_id']!,
          _recurringExpenseIdMeta,
        ),
      );
    }
    if (data.containsKey('transfer_id')) {
      context.handle(
        _transferIdMeta,
        transferId.isAcceptableOrUnknown(data['transfer_id']!, _transferIdMeta),
      );
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {recurringExpenseId, occurrenceDate},
  ];
  @override
  ExpensesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpensesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      walletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      date: $ExpensesTableTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      recurringExpenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurring_expense_id'],
      ),
      occurrenceDate: $ExpensesTableTable.$converteroccurrenceDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}occurrence_date'],
        ),
      ),
      transferId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transfer_id'],
      ),
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExpensesTableTable createAlias(String alias) {
    return $ExpensesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, String> $converterdate =
      const LocalDateConverter();
  static TypeConverter<LocalDate, String> $converteroccurrenceDate =
      const LocalDateConverter();
  static TypeConverter<LocalDate?, String?> $converteroccurrenceDaten =
      NullAwareTypeConverter.wrap($converteroccurrenceDate);
}

class ExpensesTableData extends DataClass
    implements Insertable<ExpensesTableData> {
  final int id;

  /// Optional: when null, the UI shows the category's display name.
  final String? title;
  final int amountMinor;

  /// The wallet the row belongs to. A transfer leg belongs to its own wallet.
  final int walletId;

  /// The app reassigns expenses to "Other" before deleting a category. Null
  /// only for transfer legs.
  final int? categoryId;
  final LocalDate date;
  final String? note;
  final int? recurringExpenseId;

  /// The template due date this row was generated for; kept after the
  /// template is deleted so the recurring badge survives.
  final LocalDate? occurrenceDate;

  /// Set on the two legs of a transfer; deleting the transfer deletes both.
  final int? transferId;

  /// `out` (the source wallet's leg) or `in` (the target's); set only on
  /// transfer legs.
  final String? direction;

  /// How the row came to be: `manual`, `sms` or `recurring`.
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ExpensesTableData({
    required this.id,
    this.title,
    required this.amountMinor,
    required this.walletId,
    this.categoryId,
    required this.date,
    this.note,
    this.recurringExpenseId,
    this.occurrenceDate,
    this.transferId,
    this.direction,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['wallet_id'] = Variable<int>(walletId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    {
      map['date'] = Variable<String>(
        $ExpensesTableTable.$converterdate.toSql(date),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || recurringExpenseId != null) {
      map['recurring_expense_id'] = Variable<int>(recurringExpenseId);
    }
    if (!nullToAbsent || occurrenceDate != null) {
      map['occurrence_date'] = Variable<String>(
        $ExpensesTableTable.$converteroccurrenceDaten.toSql(occurrenceDate),
      );
    }
    if (!nullToAbsent || transferId != null) {
      map['transfer_id'] = Variable<int>(transferId);
    }
    if (!nullToAbsent || direction != null) {
      map['direction'] = Variable<String>(direction);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpensesTableCompanion toCompanion(bool nullToAbsent) {
    return ExpensesTableCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      amountMinor: Value(amountMinor),
      walletId: Value(walletId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      recurringExpenseId: recurringExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringExpenseId),
      occurrenceDate: occurrenceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceDate),
      transferId: transferId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferId),
      direction: direction == null && nullToAbsent
          ? const Value.absent()
          : Value(direction),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExpensesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpensesTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      walletId: serializer.fromJson<int>(json['walletId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      date: serializer.fromJson<LocalDate>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      recurringExpenseId: serializer.fromJson<int?>(json['recurringExpenseId']),
      occurrenceDate: serializer.fromJson<LocalDate?>(json['occurrenceDate']),
      transferId: serializer.fromJson<int?>(json['transferId']),
      direction: serializer.fromJson<String?>(json['direction']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'walletId': serializer.toJson<int>(walletId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'date': serializer.toJson<LocalDate>(date),
      'note': serializer.toJson<String?>(note),
      'recurringExpenseId': serializer.toJson<int?>(recurringExpenseId),
      'occurrenceDate': serializer.toJson<LocalDate?>(occurrenceDate),
      'transferId': serializer.toJson<int?>(transferId),
      'direction': serializer.toJson<String?>(direction),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExpensesTableData copyWith({
    int? id,
    Value<String?> title = const Value.absent(),
    int? amountMinor,
    int? walletId,
    Value<int?> categoryId = const Value.absent(),
    LocalDate? date,
    Value<String?> note = const Value.absent(),
    Value<int?> recurringExpenseId = const Value.absent(),
    Value<LocalDate?> occurrenceDate = const Value.absent(),
    Value<int?> transferId = const Value.absent(),
    Value<String?> direction = const Value.absent(),
    String? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ExpensesTableData(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    amountMinor: amountMinor ?? this.amountMinor,
    walletId: walletId ?? this.walletId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    recurringExpenseId: recurringExpenseId.present
        ? recurringExpenseId.value
        : this.recurringExpenseId,
    occurrenceDate: occurrenceDate.present
        ? occurrenceDate.value
        : this.occurrenceDate,
    transferId: transferId.present ? transferId.value : this.transferId,
    direction: direction.present ? direction.value : this.direction,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExpensesTableData copyWithCompanion(ExpensesTableCompanion data) {
    return ExpensesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      recurringExpenseId: data.recurringExpenseId.present
          ? data.recurringExpenseId.value
          : this.recurringExpenseId,
      occurrenceDate: data.occurrenceDate.present
          ? data.occurrenceDate.value
          : this.occurrenceDate,
      transferId: data.transferId.present
          ? data.transferId.value
          : this.transferId,
      direction: data.direction.present ? data.direction.value : this.direction,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('walletId: $walletId, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('recurringExpenseId: $recurringExpenseId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('transferId: $transferId, ')
          ..write('direction: $direction, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amountMinor,
    walletId,
    categoryId,
    date,
    note,
    recurringExpenseId,
    occurrenceDate,
    transferId,
    direction,
    source,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpensesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.amountMinor == this.amountMinor &&
          other.walletId == this.walletId &&
          other.categoryId == this.categoryId &&
          other.date == this.date &&
          other.note == this.note &&
          other.recurringExpenseId == this.recurringExpenseId &&
          other.occurrenceDate == this.occurrenceDate &&
          other.transferId == this.transferId &&
          other.direction == this.direction &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesTableCompanion extends UpdateCompanion<ExpensesTableData> {
  final Value<int> id;
  final Value<String?> title;
  final Value<int> amountMinor;
  final Value<int> walletId;
  final Value<int?> categoryId;
  final Value<LocalDate> date;
  final Value<String?> note;
  final Value<int?> recurringExpenseId;
  final Value<LocalDate?> occurrenceDate;
  final Value<int?> transferId;
  final Value<String?> direction;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExpensesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.walletId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.recurringExpenseId = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.transferId = const Value.absent(),
    this.direction = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExpensesTableCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    required int amountMinor,
    required int walletId,
    this.categoryId = const Value.absent(),
    required LocalDate date,
    this.note = const Value.absent(),
    this.recurringExpenseId = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.transferId = const Value.absent(),
    this.direction = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : amountMinor = Value(amountMinor),
       walletId = Value(walletId),
       date = Value(date);
  static Insertable<ExpensesTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? amountMinor,
    Expression<int>? walletId,
    Expression<int>? categoryId,
    Expression<String>? date,
    Expression<String>? note,
    Expression<int>? recurringExpenseId,
    Expression<String>? occurrenceDate,
    Expression<int>? transferId,
    Expression<String>? direction,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (walletId != null) 'wallet_id': walletId,
      if (categoryId != null) 'category_id': categoryId,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (recurringExpenseId != null)
        'recurring_expense_id': recurringExpenseId,
      if (occurrenceDate != null) 'occurrence_date': occurrenceDate,
      if (transferId != null) 'transfer_id': transferId,
      if (direction != null) 'direction': direction,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExpensesTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? title,
    Value<int>? amountMinor,
    Value<int>? walletId,
    Value<int?>? categoryId,
    Value<LocalDate>? date,
    Value<String?>? note,
    Value<int?>? recurringExpenseId,
    Value<LocalDate?>? occurrenceDate,
    Value<int?>? transferId,
    Value<String?>? direction,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ExpensesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amountMinor: amountMinor ?? this.amountMinor,
      walletId: walletId ?? this.walletId,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      recurringExpenseId: recurringExpenseId ?? this.recurringExpenseId,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      transferId: transferId ?? this.transferId,
      direction: direction ?? this.direction,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $ExpensesTableTable.$converterdate.toSql(date.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (recurringExpenseId.present) {
      map['recurring_expense_id'] = Variable<int>(recurringExpenseId.value);
    }
    if (occurrenceDate.present) {
      map['occurrence_date'] = Variable<String>(
        $ExpensesTableTable.$converteroccurrenceDaten.toSql(
          occurrenceDate.value,
        ),
      );
    }
    if (transferId.present) {
      map['transfer_id'] = Variable<int>(transferId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('walletId: $walletId, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('recurringExpenseId: $recurringExpenseId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('transferId: $transferId, ')
          ..write('direction: $direction, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTableTable extends BudgetsTable
    with TableInfo<$BudgetsTableTable, BudgetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _limitMinorMeta = const VerificationMeta(
    'limitMinor',
  );
  @override
  late final GeneratedColumn<int> limitMinor = GeneratedColumn<int>(
    'limit_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(limitMinor).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    check: () => period.isIn(const ['weekly', 'monthly']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate?, String>
  lastAlertedPeriodStart =
      GeneratedColumn<String>(
        'last_alerted_period_start',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<LocalDate?>(
        $BudgetsTableTable.$converterlastAlertedPeriodStartn,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    limitMinor,
    period,
    lastAlertedPeriodStart,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('limit_minor')) {
      context.handle(
        _limitMinorMeta,
        limitMinor.isAcceptableOrUnknown(data['limit_minor']!, _limitMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_limitMinorMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      limitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_minor'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      lastAlertedPeriodStart: $BudgetsTableTable
          .$converterlastAlertedPeriodStartn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}last_alerted_period_start'],
            ),
          ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTableTable createAlias(String alias) {
    return $BudgetsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, String> $converterlastAlertedPeriodStart =
      const LocalDateConverter();
  static TypeConverter<LocalDate?, String?> $converterlastAlertedPeriodStartn =
      NullAwareTypeConverter.wrap($converterlastAlertedPeriodStart);
}

class BudgetsTableData extends DataClass
    implements Insertable<BudgetsTableData> {
  final int id;

  /// One budget per category; deleted together with its category.
  final int categoryId;
  final int limitMinor;
  final String period;

  /// Start of the period whose one-shot "exceeded" alert was already shown.
  final LocalDate? lastAlertedPeriodStart;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetsTableData({
    required this.id,
    required this.categoryId,
    required this.limitMinor,
    required this.period,
    this.lastAlertedPeriodStart,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['limit_minor'] = Variable<int>(limitMinor);
    map['period'] = Variable<String>(period);
    if (!nullToAbsent || lastAlertedPeriodStart != null) {
      map['last_alerted_period_start'] = Variable<String>(
        $BudgetsTableTable.$converterlastAlertedPeriodStartn.toSql(
          lastAlertedPeriodStart,
        ),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetsTableCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      limitMinor: Value(limitMinor),
      period: Value(period),
      lastAlertedPeriodStart: lastAlertedPeriodStart == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAlertedPeriodStart),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetsTableData(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      limitMinor: serializer.fromJson<int>(json['limitMinor']),
      period: serializer.fromJson<String>(json['period']),
      lastAlertedPeriodStart: serializer.fromJson<LocalDate?>(
        json['lastAlertedPeriodStart'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'limitMinor': serializer.toJson<int>(limitMinor),
      'period': serializer.toJson<String>(period),
      'lastAlertedPeriodStart': serializer.toJson<LocalDate?>(
        lastAlertedPeriodStart,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetsTableData copyWith({
    int? id,
    int? categoryId,
    int? limitMinor,
    String? period,
    Value<LocalDate?> lastAlertedPeriodStart = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetsTableData(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    limitMinor: limitMinor ?? this.limitMinor,
    period: period ?? this.period,
    lastAlertedPeriodStart: lastAlertedPeriodStart.present
        ? lastAlertedPeriodStart.value
        : this.lastAlertedPeriodStart,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetsTableData copyWithCompanion(BudgetsTableCompanion data) {
    return BudgetsTableData(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      limitMinor: data.limitMinor.present
          ? data.limitMinor.value
          : this.limitMinor,
      period: data.period.present ? data.period.value : this.period,
      lastAlertedPeriodStart: data.lastAlertedPeriodStart.present
          ? data.lastAlertedPeriodStart.value
          : this.lastAlertedPeriodStart,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableData(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('period: $period, ')
          ..write('lastAlertedPeriodStart: $lastAlertedPeriodStart, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    limitMinor,
    period,
    lastAlertedPeriodStart,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetsTableData &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.limitMinor == this.limitMinor &&
          other.period == this.period &&
          other.lastAlertedPeriodStart == this.lastAlertedPeriodStart &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsTableCompanion extends UpdateCompanion<BudgetsTableData> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<int> limitMinor;
  final Value<String> period;
  final Value<LocalDate?> lastAlertedPeriodStart;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BudgetsTableCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.limitMinor = const Value.absent(),
    this.period = const Value.absent(),
    this.lastAlertedPeriodStart = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BudgetsTableCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required int limitMinor,
    required String period,
    this.lastAlertedPeriodStart = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : categoryId = Value(categoryId),
       limitMinor = Value(limitMinor),
       period = Value(period);
  static Insertable<BudgetsTableData> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<int>? limitMinor,
    Expression<String>? period,
    Expression<String>? lastAlertedPeriodStart,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (limitMinor != null) 'limit_minor': limitMinor,
      if (period != null) 'period': period,
      if (lastAlertedPeriodStart != null)
        'last_alerted_period_start': lastAlertedPeriodStart,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BudgetsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryId,
    Value<int>? limitMinor,
    Value<String>? period,
    Value<LocalDate?>? lastAlertedPeriodStart,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BudgetsTableCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limitMinor: limitMinor ?? this.limitMinor,
      period: period ?? this.period,
      lastAlertedPeriodStart:
          lastAlertedPeriodStart ?? this.lastAlertedPeriodStart,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (limitMinor.present) {
      map['limit_minor'] = Variable<int>(limitMinor.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (lastAlertedPeriodStart.present) {
      map['last_alerted_period_start'] = Variable<String>(
        $BudgetsTableTable.$converterlastAlertedPeriodStartn.toSql(
          lastAlertedPeriodStart.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitMinor: $limitMinor, ')
          ..write('period: $period, ')
          ..write('lastAlertedPeriodStart: $lastAlertedPeriodStart, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SmsImportsTableTable extends SmsImportsTable
    with TableInfo<$SmsImportsTableTable, SmsImportsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsImportsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _smsKeyMeta = const VerificationMeta('smsKey');
  @override
  late final GeneratedColumn<String> smsKey = GeneratedColumn<String>(
    'sms_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    check: () => kind.isIn(const ['expense', 'income']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(amountMinor).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _cardLast4Meta = const VerificationMeta(
    'cardLast4',
  );
  @override
  late final GeneratedColumn<String> cardLast4 = GeneratedColumn<String>(
    'card_last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($SmsImportsTableTable.$converterdate);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    check: () =>
        status.isIn(const ['added', 'pending', 'ignored', 'cancelled']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
    'expense_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expenses (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    smsKey,
    sender,
    receivedAt,
    kind,
    amountMinor,
    currency,
    merchant,
    categoryId,
    cardLast4,
    date,
    note,
    status,
    expenseId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_imports';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsImportsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sms_key')) {
      context.handle(
        _smsKeyMeta,
        smsKey.isAcceptableOrUnknown(data['sms_key']!, _smsKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_smsKeyMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('card_last4')) {
      context.handle(
        _cardLast4Meta,
        cardLast4.isAcceptableOrUnknown(data['card_last4']!, _cardLast4Meta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsImportsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsImportsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      smsKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sms_key'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      cardLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_last4'],
      ),
      date: $SmsImportsTableTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_id'],
      ),
    );
  }

  @override
  $SmsImportsTableTable createAlias(String alias) {
    return $SmsImportsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, String> $converterdate =
      const LocalDateConverter();
}

class SmsImportsTableData extends DataClass
    implements Insertable<SmsImportsTableData> {
  final int id;
  final String smsKey;
  final String sender;
  final DateTime receivedAt;

  /// `expense` or `income`.
  final String kind;
  final int amountMinor;

  /// ISO 4217 code as written in the message (`EGP`).
  final String currency;
  final String? merchant;

  /// Resolved when the SMS arrived; cleared if the category is deleted.
  final int? categoryId;
  final String? cardLast4;
  final LocalDate date;
  final String? note;

  /// `added`, `pending` (waiting for the user), `ignored` or `cancelled`.
  final String status;

  /// The transaction this import became; cleared when that row is deleted.
  final int? expenseId;
  const SmsImportsTableData({
    required this.id,
    required this.smsKey,
    required this.sender,
    required this.receivedAt,
    required this.kind,
    required this.amountMinor,
    required this.currency,
    this.merchant,
    this.categoryId,
    this.cardLast4,
    required this.date,
    this.note,
    required this.status,
    this.expenseId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sms_key'] = Variable<String>(smsKey);
    map['sender'] = Variable<String>(sender);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['kind'] = Variable<String>(kind);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || cardLast4 != null) {
      map['card_last4'] = Variable<String>(cardLast4);
    }
    {
      map['date'] = Variable<String>(
        $SmsImportsTableTable.$converterdate.toSql(date),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || expenseId != null) {
      map['expense_id'] = Variable<int>(expenseId);
    }
    return map;
  }

  SmsImportsTableCompanion toCompanion(bool nullToAbsent) {
    return SmsImportsTableCompanion(
      id: Value(id),
      smsKey: Value(smsKey),
      sender: Value(sender),
      receivedAt: Value(receivedAt),
      kind: Value(kind),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      cardLast4: cardLast4 == null && nullToAbsent
          ? const Value.absent()
          : Value(cardLast4),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      expenseId: expenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseId),
    );
  }

  factory SmsImportsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsImportsTableData(
      id: serializer.fromJson<int>(json['id']),
      smsKey: serializer.fromJson<String>(json['smsKey']),
      sender: serializer.fromJson<String>(json['sender']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      kind: serializer.fromJson<String>(json['kind']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      cardLast4: serializer.fromJson<String?>(json['cardLast4']),
      date: serializer.fromJson<LocalDate>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      expenseId: serializer.fromJson<int?>(json['expenseId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'smsKey': serializer.toJson<String>(smsKey),
      'sender': serializer.toJson<String>(sender),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'kind': serializer.toJson<String>(kind),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'merchant': serializer.toJson<String?>(merchant),
      'categoryId': serializer.toJson<int?>(categoryId),
      'cardLast4': serializer.toJson<String?>(cardLast4),
      'date': serializer.toJson<LocalDate>(date),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'expenseId': serializer.toJson<int?>(expenseId),
    };
  }

  SmsImportsTableData copyWith({
    int? id,
    String? smsKey,
    String? sender,
    DateTime? receivedAt,
    String? kind,
    int? amountMinor,
    String? currency,
    Value<String?> merchant = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    Value<String?> cardLast4 = const Value.absent(),
    LocalDate? date,
    Value<String?> note = const Value.absent(),
    String? status,
    Value<int?> expenseId = const Value.absent(),
  }) => SmsImportsTableData(
    id: id ?? this.id,
    smsKey: smsKey ?? this.smsKey,
    sender: sender ?? this.sender,
    receivedAt: receivedAt ?? this.receivedAt,
    kind: kind ?? this.kind,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    merchant: merchant.present ? merchant.value : this.merchant,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    cardLast4: cardLast4.present ? cardLast4.value : this.cardLast4,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
    expenseId: expenseId.present ? expenseId.value : this.expenseId,
  );
  SmsImportsTableData copyWithCompanion(SmsImportsTableCompanion data) {
    return SmsImportsTableData(
      id: data.id.present ? data.id.value : this.id,
      smsKey: data.smsKey.present ? data.smsKey.value : this.smsKey,
      sender: data.sender.present ? data.sender.value : this.sender,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      cardLast4: data.cardLast4.present ? data.cardLast4.value : this.cardLast4,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsImportsTableData(')
          ..write('id: $id, ')
          ..write('smsKey: $smsKey, ')
          ..write('sender: $sender, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('kind: $kind, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('merchant: $merchant, ')
          ..write('categoryId: $categoryId, ')
          ..write('cardLast4: $cardLast4, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('expenseId: $expenseId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    smsKey,
    sender,
    receivedAt,
    kind,
    amountMinor,
    currency,
    merchant,
    categoryId,
    cardLast4,
    date,
    note,
    status,
    expenseId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsImportsTableData &&
          other.id == this.id &&
          other.smsKey == this.smsKey &&
          other.sender == this.sender &&
          other.receivedAt == this.receivedAt &&
          other.kind == this.kind &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.merchant == this.merchant &&
          other.categoryId == this.categoryId &&
          other.cardLast4 == this.cardLast4 &&
          other.date == this.date &&
          other.note == this.note &&
          other.status == this.status &&
          other.expenseId == this.expenseId);
}

class SmsImportsTableCompanion extends UpdateCompanion<SmsImportsTableData> {
  final Value<int> id;
  final Value<String> smsKey;
  final Value<String> sender;
  final Value<DateTime> receivedAt;
  final Value<String> kind;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String?> merchant;
  final Value<int?> categoryId;
  final Value<String?> cardLast4;
  final Value<LocalDate> date;
  final Value<String?> note;
  final Value<String> status;
  final Value<int?> expenseId;
  const SmsImportsTableCompanion({
    this.id = const Value.absent(),
    this.smsKey = const Value.absent(),
    this.sender = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.merchant = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.cardLast4 = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.expenseId = const Value.absent(),
  });
  SmsImportsTableCompanion.insert({
    this.id = const Value.absent(),
    required String smsKey,
    required String sender,
    required DateTime receivedAt,
    required String kind,
    required int amountMinor,
    required String currency,
    this.merchant = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.cardLast4 = const Value.absent(),
    required LocalDate date,
    this.note = const Value.absent(),
    required String status,
    this.expenseId = const Value.absent(),
  }) : smsKey = Value(smsKey),
       sender = Value(sender),
       receivedAt = Value(receivedAt),
       kind = Value(kind),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       date = Value(date),
       status = Value(status);
  static Insertable<SmsImportsTableData> custom({
    Expression<int>? id,
    Expression<String>? smsKey,
    Expression<String>? sender,
    Expression<DateTime>? receivedAt,
    Expression<String>? kind,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? merchant,
    Expression<int>? categoryId,
    Expression<String>? cardLast4,
    Expression<String>? date,
    Expression<String>? note,
    Expression<String>? status,
    Expression<int>? expenseId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (smsKey != null) 'sms_key': smsKey,
      if (sender != null) 'sender': sender,
      if (receivedAt != null) 'received_at': receivedAt,
      if (kind != null) 'kind': kind,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (merchant != null) 'merchant': merchant,
      if (categoryId != null) 'category_id': categoryId,
      if (cardLast4 != null) 'card_last4': cardLast4,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (expenseId != null) 'expense_id': expenseId,
    });
  }

  SmsImportsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? smsKey,
    Value<String>? sender,
    Value<DateTime>? receivedAt,
    Value<String>? kind,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String?>? merchant,
    Value<int?>? categoryId,
    Value<String?>? cardLast4,
    Value<LocalDate>? date,
    Value<String?>? note,
    Value<String>? status,
    Value<int?>? expenseId,
  }) {
    return SmsImportsTableCompanion(
      id: id ?? this.id,
      smsKey: smsKey ?? this.smsKey,
      sender: sender ?? this.sender,
      receivedAt: receivedAt ?? this.receivedAt,
      kind: kind ?? this.kind,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      merchant: merchant ?? this.merchant,
      categoryId: categoryId ?? this.categoryId,
      cardLast4: cardLast4 ?? this.cardLast4,
      date: date ?? this.date,
      note: note ?? this.note,
      status: status ?? this.status,
      expenseId: expenseId ?? this.expenseId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (smsKey.present) {
      map['sms_key'] = Variable<String>(smsKey.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (cardLast4.present) {
      map['card_last4'] = Variable<String>(cardLast4.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $SmsImportsTableTable.$converterdate.toSql(date.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsImportsTableCompanion(')
          ..write('id: $id, ')
          ..write('smsKey: $smsKey, ')
          ..write('sender: $sender, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('kind: $kind, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('merchant: $merchant, ')
          ..write('categoryId: $categoryId, ')
          ..write('cardLast4: $cardLast4, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('expenseId: $expenseId')
          ..write(')'))
        .toString();
  }
}

class $MerchantCategoriesTableTable extends MerchantCategoriesTable
    with TableInfo<$MerchantCategoriesTableTable, MerchantCategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantCategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _merchantKeyMeta = const VerificationMeta(
    'merchantKey',
  );
  @override
  late final GeneratedColumn<String> merchantKey = GeneratedColumn<String>(
    'merchant_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [merchantKey, categoryId, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchant_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<MerchantCategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('merchant_key')) {
      context.handle(
        _merchantKeyMeta,
        merchantKey.isAcceptableOrUnknown(
          data['merchant_key']!,
          _merchantKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_merchantKeyMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {merchantKey};
  @override
  MerchantCategoriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantCategoriesTableData(
      merchantKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_key'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MerchantCategoriesTableTable createAlias(String alias) {
    return $MerchantCategoriesTableTable(attachedDatabase, alias);
  }
}

class MerchantCategoriesTableData extends DataClass
    implements Insertable<MerchantCategoriesTableData> {
  final String merchantKey;
  final int categoryId;
  final DateTime updatedAt;
  const MerchantCategoriesTableData({
    required this.merchantKey,
    required this.categoryId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['merchant_key'] = Variable<String>(merchantKey);
    map['category_id'] = Variable<int>(categoryId);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MerchantCategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return MerchantCategoriesTableCompanion(
      merchantKey: Value(merchantKey),
      categoryId: Value(categoryId),
      updatedAt: Value(updatedAt),
    );
  }

  factory MerchantCategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantCategoriesTableData(
      merchantKey: serializer.fromJson<String>(json['merchantKey']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'merchantKey': serializer.toJson<String>(merchantKey),
      'categoryId': serializer.toJson<int>(categoryId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MerchantCategoriesTableData copyWith({
    String? merchantKey,
    int? categoryId,
    DateTime? updatedAt,
  }) => MerchantCategoriesTableData(
    merchantKey: merchantKey ?? this.merchantKey,
    categoryId: categoryId ?? this.categoryId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MerchantCategoriesTableData copyWithCompanion(
    MerchantCategoriesTableCompanion data,
  ) {
    return MerchantCategoriesTableData(
      merchantKey: data.merchantKey.present
          ? data.merchantKey.value
          : this.merchantKey,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantCategoriesTableData(')
          ..write('merchantKey: $merchantKey, ')
          ..write('categoryId: $categoryId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(merchantKey, categoryId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantCategoriesTableData &&
          other.merchantKey == this.merchantKey &&
          other.categoryId == this.categoryId &&
          other.updatedAt == this.updatedAt);
}

class MerchantCategoriesTableCompanion
    extends UpdateCompanion<MerchantCategoriesTableData> {
  final Value<String> merchantKey;
  final Value<int> categoryId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MerchantCategoriesTableCompanion({
    this.merchantKey = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MerchantCategoriesTableCompanion.insert({
    required String merchantKey,
    required int categoryId,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : merchantKey = Value(merchantKey),
       categoryId = Value(categoryId);
  static Insertable<MerchantCategoriesTableData> custom({
    Expression<String>? merchantKey,
    Expression<int>? categoryId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (merchantKey != null) 'merchant_key': merchantKey,
      if (categoryId != null) 'category_id': categoryId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MerchantCategoriesTableCompanion copyWith({
    Value<String>? merchantKey,
    Value<int>? categoryId,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MerchantCategoriesTableCompanion(
      merchantKey: merchantKey ?? this.merchantKey,
      categoryId: categoryId ?? this.categoryId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (merchantKey.present) {
      map['merchant_key'] = Variable<String>(merchantKey.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantCategoriesTableCompanion(')
          ..write('merchantKey: $merchantKey, ')
          ..write('categoryId: $categoryId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrustedSendersTableTable extends TrustedSendersTable
    with TableInfo<$TrustedSendersTableTable, TrustedSendersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrustedSendersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trustedMeta = const VerificationMeta(
    'trusted',
  );
  @override
  late final GeneratedColumn<bool> trusted = GeneratedColumn<bool>(
    'trusted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("trusted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [sender, trusted, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trusted_senders';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrustedSendersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('trusted')) {
      context.handle(
        _trustedMeta,
        trusted.isAcceptableOrUnknown(data['trusted']!, _trustedMeta),
      );
    } else if (isInserting) {
      context.missing(_trustedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sender};
  @override
  TrustedSendersTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrustedSendersTableData(
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      trusted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}trusted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TrustedSendersTableTable createAlias(String alias) {
    return $TrustedSendersTableTable(attachedDatabase, alias);
  }
}

class TrustedSendersTableData extends DataClass
    implements Insertable<TrustedSendersTableData> {
  final String sender;
  final bool trusted;
  final DateTime createdAt;
  const TrustedSendersTableData({
    required this.sender,
    required this.trusted,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sender'] = Variable<String>(sender);
    map['trusted'] = Variable<bool>(trusted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TrustedSendersTableCompanion toCompanion(bool nullToAbsent) {
    return TrustedSendersTableCompanion(
      sender: Value(sender),
      trusted: Value(trusted),
      createdAt: Value(createdAt),
    );
  }

  factory TrustedSendersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrustedSendersTableData(
      sender: serializer.fromJson<String>(json['sender']),
      trusted: serializer.fromJson<bool>(json['trusted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sender': serializer.toJson<String>(sender),
      'trusted': serializer.toJson<bool>(trusted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TrustedSendersTableData copyWith({
    String? sender,
    bool? trusted,
    DateTime? createdAt,
  }) => TrustedSendersTableData(
    sender: sender ?? this.sender,
    trusted: trusted ?? this.trusted,
    createdAt: createdAt ?? this.createdAt,
  );
  TrustedSendersTableData copyWithCompanion(TrustedSendersTableCompanion data) {
    return TrustedSendersTableData(
      sender: data.sender.present ? data.sender.value : this.sender,
      trusted: data.trusted.present ? data.trusted.value : this.trusted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrustedSendersTableData(')
          ..write('sender: $sender, ')
          ..write('trusted: $trusted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sender, trusted, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrustedSendersTableData &&
          other.sender == this.sender &&
          other.trusted == this.trusted &&
          other.createdAt == this.createdAt);
}

class TrustedSendersTableCompanion
    extends UpdateCompanion<TrustedSendersTableData> {
  final Value<String> sender;
  final Value<bool> trusted;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TrustedSendersTableCompanion({
    this.sender = const Value.absent(),
    this.trusted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrustedSendersTableCompanion.insert({
    required String sender,
    required bool trusted,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sender = Value(sender),
       trusted = Value(trusted);
  static Insertable<TrustedSendersTableData> custom({
    Expression<String>? sender,
    Expression<bool>? trusted,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sender != null) 'sender': sender,
      if (trusted != null) 'trusted': trusted,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrustedSendersTableCompanion copyWith({
    Value<String>? sender,
    Value<bool>? trusted,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TrustedSendersTableCompanion(
      sender: sender ?? this.sender,
      trusted: trusted ?? this.trusted,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (trusted.present) {
      map['trusted'] = Variable<bool>(trusted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrustedSendersTableCompanion(')
          ..write('sender: $sender, ')
          ..write('trusted: $trusted, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $WalletsTableTable walletsTable = $WalletsTableTable(this);
  late final $RecurringExpensesTableTable recurringExpensesTable =
      $RecurringExpensesTableTable(this);
  late final $TransfersTableTable transfersTable = $TransfersTableTable(this);
  late final $ExpensesTableTable expensesTable = $ExpensesTableTable(this);
  late final $BudgetsTableTable budgetsTable = $BudgetsTableTable(this);
  late final $SmsImportsTableTable smsImportsTable = $SmsImportsTableTable(
    this,
  );
  late final $MerchantCategoriesTableTable merchantCategoriesTable =
      $MerchantCategoriesTableTable(this);
  late final $TrustedSendersTableTable trustedSendersTable =
      $TrustedSendersTableTable(this);
  late final Index idxCategoriesKind = Index(
    'idx_categories_kind',
    'CREATE INDEX idx_categories_kind ON categories (kind)',
  );
  late final Index idxExpensesDate = Index(
    'idx_expenses_date',
    'CREATE INDEX idx_expenses_date ON expenses (date)',
  );
  late final Index idxExpensesCategoryDate = Index(
    'idx_expenses_category_date',
    'CREATE INDEX idx_expenses_category_date ON expenses (category_id, date)',
  );
  late final Index idxExpensesWalletDate = Index(
    'idx_expenses_wallet_date',
    'CREATE INDEX idx_expenses_wallet_date ON expenses (wallet_id, date)',
  );
  late final Index idxRecurringActiveDue = Index(
    'idx_recurring_active_due',
    'CREATE INDEX idx_recurring_active_due ON recurring_expenses (is_active, next_due_date)',
  );
  late final Index idxWalletsSortOrder = Index(
    'idx_wallets_sort_order',
    'CREATE INDEX idx_wallets_sort_order ON wallets (sort_order)',
  );
  late final Index idxSmsImportsReceivedAt = Index(
    'idx_sms_imports_received_at',
    'CREATE INDEX idx_sms_imports_received_at ON sms_imports (received_at)',
  );
  late final Index idxSmsImportsExpense = Index(
    'idx_sms_imports_expense',
    'CREATE INDEX idx_sms_imports_expense ON sms_imports (expense_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categoriesTable,
    walletsTable,
    recurringExpensesTable,
    transfersTable,
    expensesTable,
    budgetsTable,
    smsImportsTable,
    merchantCategoriesTable,
    trustedSendersTable,
    idxCategoriesKind,
    idxExpensesDate,
    idxExpensesCategoryDate,
    idxExpensesWalletDate,
    idxRecurringActiveDue,
    idxWalletsSortOrder,
    idxSmsImportsReceivedAt,
    idxSmsImportsExpense,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recurring_expenses',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transfers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budgets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sms_imports', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'expenses',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sms_imports', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('merchant_categories', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<String?> seedKey,
      Value<String?> name,
      Value<String> kind,
      required String icon,
      required int color,
      required int sortOrder,
      Value<bool> isHidden,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<String?> seedKey,
      Value<String?> name,
      Value<String> kind,
      Value<String> icon,
      Value<int> color,
      Value<int> sortOrder,
      Value<bool> isHidden,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CategoriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        > {
  $$CategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $RecurringExpensesTableTable,
    List<RecurringExpensesTableData>
  >
  _recurringExpensesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringExpensesTable,
        aliasName: 'categories__id__recurring_expenses__category_id',
      );

  $$RecurringExpensesTableTableProcessedTableManager
  get recurringExpensesTableRefs {
    final manager = $$RecurringExpensesTableTableTableManager(
      $_db,
      $_db.recurringExpensesTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringExpensesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTableTable, List<ExpensesTableData>>
  _expensesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensesTable,
    aliasName: 'categories__id__expenses__category_id',
  );

  $$ExpensesTableTableProcessedTableManager get expensesTableRefs {
    final manager = $$ExpensesTableTableTableManager(
      $_db,
      $_db.expensesTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTableTable, List<BudgetsTableData>>
  _budgetsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetsTable,
    aliasName: 'categories__id__budgets__category_id',
  );

  $$BudgetsTableTableProcessedTableManager get budgetsTableRefs {
    final manager = $$BudgetsTableTableTableManager(
      $_db,
      $_db.budgetsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SmsImportsTableTable, List<SmsImportsTableData>>
  _smsImportsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.smsImportsTable,
    aliasName: 'categories__id__sms_imports__category_id',
  );

  $$SmsImportsTableTableProcessedTableManager get smsImportsTableRefs {
    final manager = $$SmsImportsTableTableTableManager(
      $_db,
      $_db.smsImportsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _smsImportsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MerchantCategoriesTableTable,
    List<MerchantCategoriesTableData>
  >
  _merchantCategoriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.merchantCategoriesTable,
        aliasName: 'categories__id__merchant_categories__category_id',
      );

  $$MerchantCategoriesTableTableProcessedTableManager
  get merchantCategoriesTableRefs {
    final manager = $$MerchantCategoriesTableTableTableManager(
      $_db,
      $_db.merchantCategoriesTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _merchantCategoriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recurringExpensesTableRefs(
    Expression<bool> Function($$RecurringExpensesTableTableFilterComposer f) f,
  ) {
    final $$RecurringExpensesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringExpensesTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringExpensesTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringExpensesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> expensesTableRefs(
    Expression<bool> Function($$ExpensesTableTableFilterComposer f) f,
  ) {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableFilterComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsTableRefs(
    Expression<bool> Function($$BudgetsTableTableFilterComposer f) f,
  ) {
    final $$BudgetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> smsImportsTableRefs(
    Expression<bool> Function($$SmsImportsTableTableFilterComposer f) f,
  ) {
    final $$SmsImportsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsImportsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsImportsTableTableFilterComposer(
            $db: $db,
            $table: $db.smsImportsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> merchantCategoriesTableRefs(
    Expression<bool> Function($$MerchantCategoriesTableTableFilterComposer f) f,
  ) {
    final $$MerchantCategoriesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.merchantCategoriesTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MerchantCategoriesTableTableFilterComposer(
                $db: $db,
                $table: $db.merchantCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get seedKey =>
      $composableBuilder(column: $table.seedKey, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recurringExpensesTableRefs<T extends Object>(
    Expression<T> Function($$RecurringExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$RecurringExpensesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringExpensesTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringExpensesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringExpensesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> expensesTableRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetsTableRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> smsImportsTableRefs<T extends Object>(
    Expression<T> Function($$SmsImportsTableTableAnnotationComposer a) f,
  ) {
    final $$SmsImportsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsImportsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsImportsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.smsImportsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> merchantCategoriesTableRefs<T extends Object>(
    Expression<T> Function($$MerchantCategoriesTableTableAnnotationComposer a)
    f,
  ) {
    final $$MerchantCategoriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.merchantCategoriesTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MerchantCategoriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.merchantCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (CategoriesTableData, $$CategoriesTableTableReferences),
          CategoriesTableData,
          PrefetchHooks Function({
            bool recurringExpensesTableRefs,
            bool expensesTableRefs,
            bool budgetsTableRefs,
            bool smsImportsTableRefs,
            bool merchantCategoriesTableRefs,
          })
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                seedKey: seedKey,
                name: name,
                kind: kind,
                icon: icon,
                color: color,
                sortOrder: sortOrder,
                isHidden: isHidden,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                required String icon,
                required int color,
                required int sortOrder,
                Value<bool> isHidden = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                seedKey: seedKey,
                name: name,
                kind: kind,
                icon: icon,
                color: color,
                sortOrder: sortOrder,
                isHidden: isHidden,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recurringExpensesTableRefs = false,
                expensesTableRefs = false,
                budgetsTableRefs = false,
                smsImportsTableRefs = false,
                merchantCategoriesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurringExpensesTableRefs) db.recurringExpensesTable,
                    if (expensesTableRefs) db.expensesTable,
                    if (budgetsTableRefs) db.budgetsTable,
                    if (smsImportsTableRefs) db.smsImportsTable,
                    if (merchantCategoriesTableRefs) db.merchantCategoriesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurringExpensesTableRefs)
                        await $_getPrefetchedData<
                          CategoriesTableData,
                          $CategoriesTableTable,
                          RecurringExpensesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._recurringExpensesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringExpensesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesTableRefs)
                        await $_getPrefetchedData<
                          CategoriesTableData,
                          $CategoriesTableTable,
                          ExpensesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._expensesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetsTableRefs)
                        await $_getPrefetchedData<
                          CategoriesTableData,
                          $CategoriesTableTable,
                          BudgetsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._budgetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (smsImportsTableRefs)
                        await $_getPrefetchedData<
                          CategoriesTableData,
                          $CategoriesTableTable,
                          SmsImportsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._smsImportsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).smsImportsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (merchantCategoriesTableRefs)
                        await $_getPrefetchedData<
                          CategoriesTableData,
                          $CategoriesTableTable,
                          MerchantCategoriesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._merchantCategoriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).merchantCategoriesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (CategoriesTableData, $$CategoriesTableTableReferences),
      CategoriesTableData,
      PrefetchHooks Function({
        bool recurringExpensesTableRefs,
        bool expensesTableRefs,
        bool budgetsTableRefs,
        bool smsImportsTableRefs,
        bool merchantCategoriesTableRefs,
      })
    >;
typedef $$WalletsTableTableCreateCompanionBuilder =
    WalletsTableCompanion Function({
      Value<int> id,
      Value<String?> seedKey,
      Value<String?> name,
      required String icon,
      required int color,
      required int sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$WalletsTableTableUpdateCompanionBuilder =
    WalletsTableCompanion Function({
      Value<int> id,
      Value<String?> seedKey,
      Value<String?> name,
      Value<String> icon,
      Value<int> color,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$WalletsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $WalletsTableTable, WalletsTableData> {
  $$WalletsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $RecurringExpensesTableTable,
    List<RecurringExpensesTableData>
  >
  _recurringExpensesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringExpensesTable,
        aliasName: 'wallets__id__recurring_expenses__wallet_id',
      );

  $$RecurringExpensesTableTableProcessedTableManager
  get recurringExpensesTableRefs {
    final manager = $$RecurringExpensesTableTableTableManager(
      $_db,
      $_db.recurringExpensesTable,
    ).filter((f) => f.walletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringExpensesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTableTable, List<ExpensesTableData>>
  _expensesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensesTable,
    aliasName: 'wallets__id__expenses__wallet_id',
  );

  $$ExpensesTableTableProcessedTableManager get expensesTableRefs {
    final manager = $$ExpensesTableTableTableManager(
      $_db,
      $_db.expensesTable,
    ).filter((f) => f.walletId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WalletsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTableTable> {
  $$WalletsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recurringExpensesTableRefs(
    Expression<bool> Function($$RecurringExpensesTableTableFilterComposer f) f,
  ) {
    final $$RecurringExpensesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringExpensesTable,
          getReferencedColumn: (t) => t.walletId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringExpensesTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringExpensesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> expensesTableRefs(
    Expression<bool> Function($$ExpensesTableTableFilterComposer f) f,
  ) {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.walletId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableFilterComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WalletsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTableTable> {
  $$WalletsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTableTable> {
  $$WalletsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get seedKey =>
      $composableBuilder(column: $table.seedKey, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recurringExpensesTableRefs<T extends Object>(
    Expression<T> Function($$RecurringExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$RecurringExpensesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringExpensesTable,
          getReferencedColumn: (t) => t.walletId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringExpensesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringExpensesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> expensesTableRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.walletId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WalletsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletsTableTable,
          WalletsTableData,
          $$WalletsTableTableFilterComposer,
          $$WalletsTableTableOrderingComposer,
          $$WalletsTableTableAnnotationComposer,
          $$WalletsTableTableCreateCompanionBuilder,
          $$WalletsTableTableUpdateCompanionBuilder,
          (WalletsTableData, $$WalletsTableTableReferences),
          WalletsTableData,
          PrefetchHooks Function({
            bool recurringExpensesTableRefs,
            bool expensesTableRefs,
          })
        > {
  $$WalletsTableTableTableManager(_$AppDatabase db, $WalletsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletsTableCompanion(
                id: id,
                seedKey: seedKey,
                name: name,
                icon: icon,
                color: color,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required String icon,
                required int color,
                required int sortOrder,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WalletsTableCompanion.insert(
                id: id,
                seedKey: seedKey,
                name: name,
                icon: icon,
                color: color,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WalletsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recurringExpensesTableRefs = false,
                expensesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurringExpensesTableRefs) db.recurringExpensesTable,
                    if (expensesTableRefs) db.expensesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurringExpensesTableRefs)
                        await $_getPrefetchedData<
                          WalletsTableData,
                          $WalletsTableTable,
                          RecurringExpensesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WalletsTableTableReferences
                              ._recurringExpensesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WalletsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringExpensesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.walletId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesTableRefs)
                        await $_getPrefetchedData<
                          WalletsTableData,
                          $WalletsTableTable,
                          ExpensesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WalletsTableTableReferences
                              ._expensesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WalletsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.walletId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WalletsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletsTableTable,
      WalletsTableData,
      $$WalletsTableTableFilterComposer,
      $$WalletsTableTableOrderingComposer,
      $$WalletsTableTableAnnotationComposer,
      $$WalletsTableTableCreateCompanionBuilder,
      $$WalletsTableTableUpdateCompanionBuilder,
      (WalletsTableData, $$WalletsTableTableReferences),
      WalletsTableData,
      PrefetchHooks Function({
        bool recurringExpensesTableRefs,
        bool expensesTableRefs,
      })
    >;
typedef $$RecurringExpensesTableTableCreateCompanionBuilder =
    RecurringExpensesTableCompanion Function({
      Value<int> id,
      required String title,
      required int amountMinor,
      required int walletId,
      required int categoryId,
      required String frequency,
      required LocalDate startDate,
      required LocalDate nextDueDate,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$RecurringExpensesTableTableUpdateCompanionBuilder =
    RecurringExpensesTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> amountMinor,
      Value<int> walletId,
      Value<int> categoryId,
      Value<String> frequency,
      Value<LocalDate> startDate,
      Value<LocalDate> nextDueDate,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$RecurringExpensesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurringExpensesTableTable,
          RecurringExpensesTableData
        > {
  $$RecurringExpensesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WalletsTableTable _walletIdTable(_$AppDatabase db) =>
      db.walletsTable.createAlias('recurring_expenses__wallet_id__wallets__id');

  $$WalletsTableTableProcessedTableManager get walletId {
    final $_column = $_itemColumn<int>('wallet_id')!;

    final manager = $$WalletsTableTableTableManager(
      $_db,
      $_db.walletsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('recurring_expenses__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExpensesTableTable, List<ExpensesTableData>>
  _expensesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensesTable,
    aliasName: 'recurring_expenses__id__expenses__recurring_expense_id',
  );

  $$ExpensesTableTableProcessedTableManager get expensesTableRefs {
    final manager = $$ExpensesTableTableTableManager($_db, $_db.expensesTable)
        .filter(
          (f) => f.recurringExpenseId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_expensesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurringExpensesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTableTable> {
  $$RecurringExpensesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, String> get startDate =>
      $composableBuilder(
        column: $table.startDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, String>
  get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WalletsTableTableFilterComposer get walletId {
    final $$WalletsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.walletsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableTableFilterComposer(
            $db: $db,
            $table: $db.walletsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> expensesTableRefs(
    Expression<bool> Function($$ExpensesTableTableFilterComposer f) f,
  ) {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.recurringExpenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableFilterComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurringExpensesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTableTable> {
  $$RecurringExpensesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WalletsTableTableOrderingComposer get walletId {
    final $$WalletsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.walletsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableTableOrderingComposer(
            $db: $db,
            $table: $db.walletsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringExpensesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTableTable> {
  $$RecurringExpensesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate, String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate, String> get nextDueDate =>
      $composableBuilder(
        column: $table.nextDueDate,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WalletsTableTableAnnotationComposer get walletId {
    final $$WalletsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.walletsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.walletsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> expensesTableRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.recurringExpenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurringExpensesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringExpensesTableTable,
          RecurringExpensesTableData,
          $$RecurringExpensesTableTableFilterComposer,
          $$RecurringExpensesTableTableOrderingComposer,
          $$RecurringExpensesTableTableAnnotationComposer,
          $$RecurringExpensesTableTableCreateCompanionBuilder,
          $$RecurringExpensesTableTableUpdateCompanionBuilder,
          (RecurringExpensesTableData, $$RecurringExpensesTableTableReferences),
          RecurringExpensesTableData,
          PrefetchHooks Function({
            bool walletId,
            bool categoryId,
            bool expensesTableRefs,
          })
        > {
  $$RecurringExpensesTableTableTableManager(
    _$AppDatabase db,
    $RecurringExpensesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringExpensesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurringExpensesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringExpensesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<LocalDate> startDate = const Value.absent(),
                Value<LocalDate> nextDueDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RecurringExpensesTableCompanion(
                id: id,
                title: title,
                amountMinor: amountMinor,
                walletId: walletId,
                categoryId: categoryId,
                frequency: frequency,
                startDate: startDate,
                nextDueDate: nextDueDate,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int amountMinor,
                required int walletId,
                required int categoryId,
                required String frequency,
                required LocalDate startDate,
                required LocalDate nextDueDate,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RecurringExpensesTableCompanion.insert(
                id: id,
                title: title,
                amountMinor: amountMinor,
                walletId: walletId,
                categoryId: categoryId,
                frequency: frequency,
                startDate: startDate,
                nextDueDate: nextDueDate,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurringExpensesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                walletId = false,
                categoryId = false,
                expensesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (expensesTableRefs) db.expensesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (walletId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.walletId,
                                    referencedTable:
                                        $$RecurringExpensesTableTableReferences
                                            ._walletIdTable(db),
                                    referencedColumn:
                                        $$RecurringExpensesTableTableReferences
                                            ._walletIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$RecurringExpensesTableTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$RecurringExpensesTableTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (expensesTableRefs)
                        await $_getPrefetchedData<
                          RecurringExpensesTableData,
                          $RecurringExpensesTableTable,
                          ExpensesTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$RecurringExpensesTableTableReferences
                                  ._expensesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecurringExpensesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recurringExpenseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecurringExpensesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringExpensesTableTable,
      RecurringExpensesTableData,
      $$RecurringExpensesTableTableFilterComposer,
      $$RecurringExpensesTableTableOrderingComposer,
      $$RecurringExpensesTableTableAnnotationComposer,
      $$RecurringExpensesTableTableCreateCompanionBuilder,
      $$RecurringExpensesTableTableUpdateCompanionBuilder,
      (RecurringExpensesTableData, $$RecurringExpensesTableTableReferences),
      RecurringExpensesTableData,
      PrefetchHooks Function({
        bool walletId,
        bool categoryId,
        bool expensesTableRefs,
      })
    >;
typedef $$TransfersTableTableCreateCompanionBuilder =
    TransfersTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TransfersTableTableUpdateCompanionBuilder =
    TransfersTableCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TransfersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransfersTableTable,
          TransfersTableData
        > {
  $$TransfersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExpensesTableTable, List<ExpensesTableData>>
  _expensesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensesTable,
    aliasName: 'transfers__id__expenses__transfer_id',
  );

  $$ExpensesTableTableProcessedTableManager get expensesTableRefs {
    final manager = $$ExpensesTableTableTableManager(
      $_db,
      $_db.expensesTable,
    ).filter((f) => f.transferId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransfersTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransfersTableTable> {
  $$TransfersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesTableRefs(
    Expression<bool> Function($$ExpensesTableTableFilterComposer f) f,
  ) {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.transferId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableFilterComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransfersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransfersTableTable> {
  $$TransfersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransfersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransfersTableTable> {
  $$TransfersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> expensesTableRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.transferId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransfersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransfersTableTable,
          TransfersTableData,
          $$TransfersTableTableFilterComposer,
          $$TransfersTableTableOrderingComposer,
          $$TransfersTableTableAnnotationComposer,
          $$TransfersTableTableCreateCompanionBuilder,
          $$TransfersTableTableUpdateCompanionBuilder,
          (TransfersTableData, $$TransfersTableTableReferences),
          TransfersTableData,
          PrefetchHooks Function({bool expensesTableRefs})
        > {
  $$TransfersTableTableTableManager(
    _$AppDatabase db,
    $TransfersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransfersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransfersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransfersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransfersTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransfersTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransfersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expensesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expensesTableRefs) db.expensesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesTableRefs)
                    await $_getPrefetchedData<
                      TransfersTableData,
                      $TransfersTableTable,
                      ExpensesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$TransfersTableTableReferences
                          ._expensesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TransfersTableTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.transferId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TransfersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransfersTableTable,
      TransfersTableData,
      $$TransfersTableTableFilterComposer,
      $$TransfersTableTableOrderingComposer,
      $$TransfersTableTableAnnotationComposer,
      $$TransfersTableTableCreateCompanionBuilder,
      $$TransfersTableTableUpdateCompanionBuilder,
      (TransfersTableData, $$TransfersTableTableReferences),
      TransfersTableData,
      PrefetchHooks Function({bool expensesTableRefs})
    >;
typedef $$ExpensesTableTableCreateCompanionBuilder =
    ExpensesTableCompanion Function({
      Value<int> id,
      Value<String?> title,
      required int amountMinor,
      required int walletId,
      Value<int?> categoryId,
      required LocalDate date,
      Value<String?> note,
      Value<int?> recurringExpenseId,
      Value<LocalDate?> occurrenceDate,
      Value<int?> transferId,
      Value<String?> direction,
      Value<String> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ExpensesTableTableUpdateCompanionBuilder =
    ExpensesTableCompanion Function({
      Value<int> id,
      Value<String?> title,
      Value<int> amountMinor,
      Value<int> walletId,
      Value<int?> categoryId,
      Value<LocalDate> date,
      Value<String?> note,
      Value<int?> recurringExpenseId,
      Value<LocalDate?> occurrenceDate,
      Value<int?> transferId,
      Value<String?> direction,
      Value<String> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ExpensesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExpensesTableTable, ExpensesTableData> {
  $$ExpensesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WalletsTableTable _walletIdTable(_$AppDatabase db) =>
      db.walletsTable.createAlias('expenses__wallet_id__wallets__id');

  $$WalletsTableTableProcessedTableManager get walletId {
    final $_column = $_itemColumn<int>('wallet_id')!;

    final manager = $$WalletsTableTableTableManager(
      $_db,
      $_db.walletsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_walletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias('expenses__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecurringExpensesTableTable _recurringExpenseIdTable(
    _$AppDatabase db,
  ) => db.recurringExpensesTable.createAlias(
    'expenses__recurring_expense_id__recurring_expenses__id',
  );

  $$RecurringExpensesTableTableProcessedTableManager? get recurringExpenseId {
    final $_column = $_itemColumn<int>('recurring_expense_id');
    if ($_column == null) return null;
    final manager = $$RecurringExpensesTableTableTableManager(
      $_db,
      $_db.recurringExpensesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurringExpenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransfersTableTable _transferIdTable(_$AppDatabase db) =>
      db.transfersTable.createAlias('expenses__transfer_id__transfers__id');

  $$TransfersTableTableProcessedTableManager? get transferId {
    final $_column = $_itemColumn<int>('transfer_id');
    if ($_column == null) return null;
    final manager = $$TransfersTableTableTableManager(
      $_db,
      $_db.transfersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transferIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SmsImportsTableTable, List<SmsImportsTableData>>
  _smsImportsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.smsImportsTable,
    aliasName: 'expenses__id__sms_imports__expense_id',
  );

  $$SmsImportsTableTableProcessedTableManager get smsImportsTableRefs {
    final manager = $$SmsImportsTableTableTableManager(
      $_db,
      $_db.smsImportsTable,
    ).filter((f) => f.expenseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _smsImportsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpensesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate?, LocalDate, String>
  get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WalletsTableTableFilterComposer get walletId {
    final $$WalletsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.walletsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableTableFilterComposer(
            $db: $db,
            $table: $db.walletsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringExpensesTableTableFilterComposer get recurringExpenseId {
    final $$RecurringExpensesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurringExpenseId,
          referencedTable: $db.recurringExpensesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringExpensesTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringExpensesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransfersTableTableFilterComposer get transferId {
    final $$TransfersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferId,
      referencedTable: $db.transfersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableTableFilterComposer(
            $db: $db,
            $table: $db.transfersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> smsImportsTableRefs(
    Expression<bool> Function($$SmsImportsTableTableFilterComposer f) f,
  ) {
    final $$SmsImportsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsImportsTable,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsImportsTableTableFilterComposer(
            $db: $db,
            $table: $db.smsImportsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpensesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WalletsTableTableOrderingComposer get walletId {
    final $$WalletsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.walletsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableTableOrderingComposer(
            $db: $db,
            $table: $db.walletsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringExpensesTableTableOrderingComposer get recurringExpenseId {
    final $$RecurringExpensesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurringExpenseId,
          referencedTable: $db.recurringExpensesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringExpensesTableTableOrderingComposer(
                $db: $db,
                $table: $db.recurringExpensesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransfersTableTableOrderingComposer get transferId {
    final $$TransfersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferId,
      referencedTable: $db.transfersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableTableOrderingComposer(
            $db: $db,
            $table: $db.transfersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LocalDate, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate?, String> get occurrenceDate =>
      $composableBuilder(
        column: $table.occurrenceDate,
        builder: (column) => column,
      );

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WalletsTableTableAnnotationComposer get walletId {
    final $$WalletsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.walletId,
      referencedTable: $db.walletsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WalletsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.walletsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurringExpensesTableTableAnnotationComposer get recurringExpenseId {
    final $$RecurringExpensesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurringExpenseId,
          referencedTable: $db.recurringExpensesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringExpensesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringExpensesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransfersTableTableAnnotationComposer get transferId {
    final $$TransfersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferId,
      referencedTable: $db.transfersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.transfersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> smsImportsTableRefs<T extends Object>(
    Expression<T> Function($$SmsImportsTableTableAnnotationComposer a) f,
  ) {
    final $$SmsImportsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.smsImportsTable,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsImportsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.smsImportsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpensesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTableTable,
          ExpensesTableData,
          $$ExpensesTableTableFilterComposer,
          $$ExpensesTableTableOrderingComposer,
          $$ExpensesTableTableAnnotationComposer,
          $$ExpensesTableTableCreateCompanionBuilder,
          $$ExpensesTableTableUpdateCompanionBuilder,
          (ExpensesTableData, $$ExpensesTableTableReferences),
          ExpensesTableData,
          PrefetchHooks Function({
            bool walletId,
            bool categoryId,
            bool recurringExpenseId,
            bool transferId,
            bool smsImportsTableRefs,
          })
        > {
  $$ExpensesTableTableTableManager(_$AppDatabase db, $ExpensesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> walletId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<LocalDate> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> recurringExpenseId = const Value.absent(),
                Value<LocalDate?> occurrenceDate = const Value.absent(),
                Value<int?> transferId = const Value.absent(),
                Value<String?> direction = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExpensesTableCompanion(
                id: id,
                title: title,
                amountMinor: amountMinor,
                walletId: walletId,
                categoryId: categoryId,
                date: date,
                note: note,
                recurringExpenseId: recurringExpenseId,
                occurrenceDate: occurrenceDate,
                transferId: transferId,
                direction: direction,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required int amountMinor,
                required int walletId,
                Value<int?> categoryId = const Value.absent(),
                required LocalDate date,
                Value<String?> note = const Value.absent(),
                Value<int?> recurringExpenseId = const Value.absent(),
                Value<LocalDate?> occurrenceDate = const Value.absent(),
                Value<int?> transferId = const Value.absent(),
                Value<String?> direction = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExpensesTableCompanion.insert(
                id: id,
                title: title,
                amountMinor: amountMinor,
                walletId: walletId,
                categoryId: categoryId,
                date: date,
                note: note,
                recurringExpenseId: recurringExpenseId,
                occurrenceDate: occurrenceDate,
                transferId: transferId,
                direction: direction,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                walletId = false,
                categoryId = false,
                recurringExpenseId = false,
                transferId = false,
                smsImportsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (smsImportsTableRefs) db.smsImportsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (walletId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.walletId,
                                    referencedTable:
                                        $$ExpensesTableTableReferences
                                            ._walletIdTable(db),
                                    referencedColumn:
                                        $$ExpensesTableTableReferences
                                            ._walletIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$ExpensesTableTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$ExpensesTableTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (recurringExpenseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recurringExpenseId,
                                    referencedTable:
                                        $$ExpensesTableTableReferences
                                            ._recurringExpenseIdTable(db),
                                    referencedColumn:
                                        $$ExpensesTableTableReferences
                                            ._recurringExpenseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (transferId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.transferId,
                                    referencedTable:
                                        $$ExpensesTableTableReferences
                                            ._transferIdTable(db),
                                    referencedColumn:
                                        $$ExpensesTableTableReferences
                                            ._transferIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (smsImportsTableRefs)
                        await $_getPrefetchedData<
                          ExpensesTableData,
                          $ExpensesTableTable,
                          SmsImportsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ExpensesTableTableReferences
                              ._smsImportsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpensesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).smsImportsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expenseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExpensesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTableTable,
      ExpensesTableData,
      $$ExpensesTableTableFilterComposer,
      $$ExpensesTableTableOrderingComposer,
      $$ExpensesTableTableAnnotationComposer,
      $$ExpensesTableTableCreateCompanionBuilder,
      $$ExpensesTableTableUpdateCompanionBuilder,
      (ExpensesTableData, $$ExpensesTableTableReferences),
      ExpensesTableData,
      PrefetchHooks Function({
        bool walletId,
        bool categoryId,
        bool recurringExpenseId,
        bool transferId,
        bool smsImportsTableRefs,
      })
    >;
typedef $$BudgetsTableTableCreateCompanionBuilder =
    BudgetsTableCompanion Function({
      Value<int> id,
      required int categoryId,
      required int limitMinor,
      required String period,
      Value<LocalDate?> lastAlertedPeriodStart,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BudgetsTableTableUpdateCompanionBuilder =
    BudgetsTableCompanion Function({
      Value<int> id,
      Value<int> categoryId,
      Value<int> limitMinor,
      Value<String> period,
      Value<LocalDate?> lastAlertedPeriodStart,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$BudgetsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetsTableData> {
  $$BudgetsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias('budgets__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limitMinor => $composableBuilder(
    column: $table.limitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate?, LocalDate, String>
  get lastAlertedPeriodStart => $composableBuilder(
    column: $table.lastAlertedPeriodStart,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitMinor => $composableBuilder(
    column: $table.limitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastAlertedPeriodStart => $composableBuilder(
    column: $table.lastAlertedPeriodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get limitMinor => $composableBuilder(
    column: $table.limitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate?, String>
  get lastAlertedPeriodStart => $composableBuilder(
    column: $table.lastAlertedPeriodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTableTable,
          BudgetsTableData,
          $$BudgetsTableTableFilterComposer,
          $$BudgetsTableTableOrderingComposer,
          $$BudgetsTableTableAnnotationComposer,
          $$BudgetsTableTableCreateCompanionBuilder,
          $$BudgetsTableTableUpdateCompanionBuilder,
          (BudgetsTableData, $$BudgetsTableTableReferences),
          BudgetsTableData,
          PrefetchHooks Function({bool categoryId})
        > {
  $$BudgetsTableTableTableManager(_$AppDatabase db, $BudgetsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> limitMinor = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<LocalDate?> lastAlertedPeriodStart = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetsTableCompanion(
                id: id,
                categoryId: categoryId,
                limitMinor: limitMinor,
                period: period,
                lastAlertedPeriodStart: lastAlertedPeriodStart,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryId,
                required int limitMinor,
                required String period,
                Value<LocalDate?> lastAlertedPeriodStart = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetsTableCompanion.insert(
                id: id,
                categoryId: categoryId,
                limitMinor: limitMinor,
                period: period,
                lastAlertedPeriodStart: lastAlertedPeriodStart,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$BudgetsTableTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$BudgetsTableTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTableTable,
      BudgetsTableData,
      $$BudgetsTableTableFilterComposer,
      $$BudgetsTableTableOrderingComposer,
      $$BudgetsTableTableAnnotationComposer,
      $$BudgetsTableTableCreateCompanionBuilder,
      $$BudgetsTableTableUpdateCompanionBuilder,
      (BudgetsTableData, $$BudgetsTableTableReferences),
      BudgetsTableData,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$SmsImportsTableTableCreateCompanionBuilder =
    SmsImportsTableCompanion Function({
      Value<int> id,
      required String smsKey,
      required String sender,
      required DateTime receivedAt,
      required String kind,
      required int amountMinor,
      required String currency,
      Value<String?> merchant,
      Value<int?> categoryId,
      Value<String?> cardLast4,
      required LocalDate date,
      Value<String?> note,
      required String status,
      Value<int?> expenseId,
    });
typedef $$SmsImportsTableTableUpdateCompanionBuilder =
    SmsImportsTableCompanion Function({
      Value<int> id,
      Value<String> smsKey,
      Value<String> sender,
      Value<DateTime> receivedAt,
      Value<String> kind,
      Value<int> amountMinor,
      Value<String> currency,
      Value<String?> merchant,
      Value<int?> categoryId,
      Value<String?> cardLast4,
      Value<LocalDate> date,
      Value<String?> note,
      Value<String> status,
      Value<int?> expenseId,
    });

final class $$SmsImportsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SmsImportsTableTable,
          SmsImportsTableData
        > {
  $$SmsImportsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('sms_imports__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExpensesTableTable _expenseIdTable(_$AppDatabase db) =>
      db.expensesTable.createAlias('sms_imports__expense_id__expenses__id');

  $$ExpensesTableTableProcessedTableManager? get expenseId {
    final $_column = $_itemColumn<int>('expense_id');
    if ($_column == null) return null;
    final manager = $$ExpensesTableTableTableManager(
      $_db,
      $_db.expensesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SmsImportsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SmsImportsTableTable> {
  $$SmsImportsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smsKey => $composableBuilder(
    column: $table.smsKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardLast4 => $composableBuilder(
    column: $table.cardLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpensesTableTableFilterComposer get expenseId {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableFilterComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsImportsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SmsImportsTableTable> {
  $$SmsImportsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smsKey => $composableBuilder(
    column: $table.smsKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardLast4 => $composableBuilder(
    column: $table.cardLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpensesTableTableOrderingComposer get expenseId {
    final $$ExpensesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableOrderingComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsImportsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmsImportsTableTable> {
  $$SmsImportsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get smsKey =>
      $composableBuilder(column: $table.smsKey, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get cardLast4 =>
      $composableBuilder(column: $table.cardLast4, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpensesTableTableAnnotationComposer get expenseId {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SmsImportsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmsImportsTableTable,
          SmsImportsTableData,
          $$SmsImportsTableTableFilterComposer,
          $$SmsImportsTableTableOrderingComposer,
          $$SmsImportsTableTableAnnotationComposer,
          $$SmsImportsTableTableCreateCompanionBuilder,
          $$SmsImportsTableTableUpdateCompanionBuilder,
          (SmsImportsTableData, $$SmsImportsTableTableReferences),
          SmsImportsTableData,
          PrefetchHooks Function({bool categoryId, bool expenseId})
        > {
  $$SmsImportsTableTableTableManager(
    _$AppDatabase db,
    $SmsImportsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsImportsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsImportsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsImportsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> smsKey = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> cardLast4 = const Value.absent(),
                Value<LocalDate> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> expenseId = const Value.absent(),
              }) => SmsImportsTableCompanion(
                id: id,
                smsKey: smsKey,
                sender: sender,
                receivedAt: receivedAt,
                kind: kind,
                amountMinor: amountMinor,
                currency: currency,
                merchant: merchant,
                categoryId: categoryId,
                cardLast4: cardLast4,
                date: date,
                note: note,
                status: status,
                expenseId: expenseId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String smsKey,
                required String sender,
                required DateTime receivedAt,
                required String kind,
                required int amountMinor,
                required String currency,
                Value<String?> merchant = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> cardLast4 = const Value.absent(),
                required LocalDate date,
                Value<String?> note = const Value.absent(),
                required String status,
                Value<int?> expenseId = const Value.absent(),
              }) => SmsImportsTableCompanion.insert(
                id: id,
                smsKey: smsKey,
                sender: sender,
                receivedAt: receivedAt,
                kind: kind,
                amountMinor: amountMinor,
                currency: currency,
                merchant: merchant,
                categoryId: categoryId,
                cardLast4: cardLast4,
                date: date,
                note: note,
                status: status,
                expenseId: expenseId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SmsImportsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, expenseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$SmsImportsTableTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$SmsImportsTableTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (expenseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.expenseId,
                                referencedTable:
                                    $$SmsImportsTableTableReferences
                                        ._expenseIdTable(db),
                                referencedColumn:
                                    $$SmsImportsTableTableReferences
                                        ._expenseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SmsImportsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmsImportsTableTable,
      SmsImportsTableData,
      $$SmsImportsTableTableFilterComposer,
      $$SmsImportsTableTableOrderingComposer,
      $$SmsImportsTableTableAnnotationComposer,
      $$SmsImportsTableTableCreateCompanionBuilder,
      $$SmsImportsTableTableUpdateCompanionBuilder,
      (SmsImportsTableData, $$SmsImportsTableTableReferences),
      SmsImportsTableData,
      PrefetchHooks Function({bool categoryId, bool expenseId})
    >;
typedef $$MerchantCategoriesTableTableCreateCompanionBuilder =
    MerchantCategoriesTableCompanion Function({
      required String merchantKey,
      required int categoryId,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MerchantCategoriesTableTableUpdateCompanionBuilder =
    MerchantCategoriesTableCompanion Function({
      Value<String> merchantKey,
      Value<int> categoryId,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MerchantCategoriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MerchantCategoriesTableTable,
          MerchantCategoriesTableData
        > {
  $$MerchantCategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('merchant_categories__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MerchantCategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantCategoriesTableTable> {
  $$MerchantCategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantCategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantCategoriesTableTable> {
  $$MerchantCategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantCategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantCategoriesTableTable> {
  $$MerchantCategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MerchantCategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantCategoriesTableTable,
          MerchantCategoriesTableData,
          $$MerchantCategoriesTableTableFilterComposer,
          $$MerchantCategoriesTableTableOrderingComposer,
          $$MerchantCategoriesTableTableAnnotationComposer,
          $$MerchantCategoriesTableTableCreateCompanionBuilder,
          $$MerchantCategoriesTableTableUpdateCompanionBuilder,
          (
            MerchantCategoriesTableData,
            $$MerchantCategoriesTableTableReferences,
          ),
          MerchantCategoriesTableData,
          PrefetchHooks Function({bool categoryId})
        > {
  $$MerchantCategoriesTableTableTableManager(
    _$AppDatabase db,
    $MerchantCategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantCategoriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MerchantCategoriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MerchantCategoriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> merchantKey = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MerchantCategoriesTableCompanion(
                merchantKey: merchantKey,
                categoryId: categoryId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String merchantKey,
                required int categoryId,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MerchantCategoriesTableCompanion.insert(
                merchantKey: merchantKey,
                categoryId: categoryId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MerchantCategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$MerchantCategoriesTableTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$MerchantCategoriesTableTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MerchantCategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantCategoriesTableTable,
      MerchantCategoriesTableData,
      $$MerchantCategoriesTableTableFilterComposer,
      $$MerchantCategoriesTableTableOrderingComposer,
      $$MerchantCategoriesTableTableAnnotationComposer,
      $$MerchantCategoriesTableTableCreateCompanionBuilder,
      $$MerchantCategoriesTableTableUpdateCompanionBuilder,
      (MerchantCategoriesTableData, $$MerchantCategoriesTableTableReferences),
      MerchantCategoriesTableData,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$TrustedSendersTableTableCreateCompanionBuilder =
    TrustedSendersTableCompanion Function({
      required String sender,
      required bool trusted,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TrustedSendersTableTableUpdateCompanionBuilder =
    TrustedSendersTableCompanion Function({
      Value<String> sender,
      Value<bool> trusted,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TrustedSendersTableTableFilterComposer
    extends Composer<_$AppDatabase, $TrustedSendersTableTable> {
  $$TrustedSendersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trusted => $composableBuilder(
    column: $table.trusted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrustedSendersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TrustedSendersTableTable> {
  $$TrustedSendersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trusted => $composableBuilder(
    column: $table.trusted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrustedSendersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrustedSendersTableTable> {
  $$TrustedSendersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<bool> get trusted =>
      $composableBuilder(column: $table.trusted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TrustedSendersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrustedSendersTableTable,
          TrustedSendersTableData,
          $$TrustedSendersTableTableFilterComposer,
          $$TrustedSendersTableTableOrderingComposer,
          $$TrustedSendersTableTableAnnotationComposer,
          $$TrustedSendersTableTableCreateCompanionBuilder,
          $$TrustedSendersTableTableUpdateCompanionBuilder,
          (
            TrustedSendersTableData,
            BaseReferences<
              _$AppDatabase,
              $TrustedSendersTableTable,
              TrustedSendersTableData
            >,
          ),
          TrustedSendersTableData,
          PrefetchHooks Function()
        > {
  $$TrustedSendersTableTableTableManager(
    _$AppDatabase db,
    $TrustedSendersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrustedSendersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrustedSendersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TrustedSendersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sender = const Value.absent(),
                Value<bool> trusted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrustedSendersTableCompanion(
                sender: sender,
                trusted: trusted,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sender,
                required bool trusted,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrustedSendersTableCompanion.insert(
                sender: sender,
                trusted: trusted,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrustedSendersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrustedSendersTableTable,
      TrustedSendersTableData,
      $$TrustedSendersTableTableFilterComposer,
      $$TrustedSendersTableTableOrderingComposer,
      $$TrustedSendersTableTableAnnotationComposer,
      $$TrustedSendersTableTableCreateCompanionBuilder,
      $$TrustedSendersTableTableUpdateCompanionBuilder,
      (
        TrustedSendersTableData,
        BaseReferences<
          _$AppDatabase,
          $TrustedSendersTableTable,
          TrustedSendersTableData
        >,
      ),
      TrustedSendersTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$WalletsTableTableTableManager get walletsTable =>
      $$WalletsTableTableTableManager(_db, _db.walletsTable);
  $$RecurringExpensesTableTableTableManager get recurringExpensesTable =>
      $$RecurringExpensesTableTableTableManager(
        _db,
        _db.recurringExpensesTable,
      );
  $$TransfersTableTableTableManager get transfersTable =>
      $$TransfersTableTableTableManager(_db, _db.transfersTable);
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db, _db.expensesTable);
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db, _db.budgetsTable);
  $$SmsImportsTableTableTableManager get smsImportsTable =>
      $$SmsImportsTableTableTableManager(_db, _db.smsImportsTable);
  $$MerchantCategoriesTableTableTableManager get merchantCategoriesTable =>
      $$MerchantCategoriesTableTableTableManager(
        _db,
        _db.merchantCategoriesTable,
      );
  $$TrustedSendersTableTableTableManager get trustedSendersTable =>
      $$TrustedSendersTableTableTableManager(_db, _db.trustedSendersTable);
}
