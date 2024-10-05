// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DropdownTableTable extends DropdownTable
    with TableInfo<$DropdownTableTable, DropdownTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DropdownTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupKeyMeta =
      const VerificationMeta('groupKey');
  @override
  late final GeneratedColumn<String> groupKey = GeneratedColumn<String>(
      'group_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, value, groupKey, orderIndex, parentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dropdown_table';
  @override
  VerificationContext validateIntegrity(Insertable<DropdownTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('group_key')) {
      context.handle(_groupKeyMeta,
          groupKey.isAcceptableOrUnknown(data['group_key']!, _groupKeyMeta));
    } else if (isInserting) {
      context.missing(_groupKeyMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DropdownTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DropdownTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      groupKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_key'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id'])!,
    );
  }

  @override
  $DropdownTableTable createAlias(String alias) {
    return $DropdownTableTable(attachedDatabase, alias);
  }
}

class DropdownTableData extends DataClass
    implements Insertable<DropdownTableData> {
  final int id;
  final String name;
  final String value;
  final String groupKey;
  final int orderIndex;
  final String parentId;
  const DropdownTableData(
      {required this.id,
      required this.name,
      required this.value,
      required this.groupKey,
      required this.orderIndex,
      required this.parentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    map['group_key'] = Variable<String>(groupKey);
    map['order_index'] = Variable<int>(orderIndex);
    map['parent_id'] = Variable<String>(parentId);
    return map;
  }

  DropdownTableCompanion toCompanion(bool nullToAbsent) {
    return DropdownTableCompanion(
      id: Value(id),
      name: Value(name),
      value: Value(value),
      groupKey: Value(groupKey),
      orderIndex: Value(orderIndex),
      parentId: Value(parentId),
    );
  }

  factory DropdownTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DropdownTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
      groupKey: serializer.fromJson<String>(json['groupKey']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      parentId: serializer.fromJson<String>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
      'groupKey': serializer.toJson<String>(groupKey),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'parentId': serializer.toJson<String>(parentId),
    };
  }

  DropdownTableData copyWith(
          {int? id,
          String? name,
          String? value,
          String? groupKey,
          int? orderIndex,
          String? parentId}) =>
      DropdownTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        groupKey: groupKey ?? this.groupKey,
        orderIndex: orderIndex ?? this.orderIndex,
        parentId: parentId ?? this.parentId,
      );
  DropdownTableData copyWithCompanion(DropdownTableCompanion data) {
    return DropdownTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      groupKey: data.groupKey.present ? data.groupKey.value : this.groupKey,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DropdownTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('groupKey: $groupKey, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, value, groupKey, orderIndex, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DropdownTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.value == this.value &&
          other.groupKey == this.groupKey &&
          other.orderIndex == this.orderIndex &&
          other.parentId == this.parentId);
}

class DropdownTableCompanion extends UpdateCompanion<DropdownTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> value;
  final Value<String> groupKey;
  final Value<int> orderIndex;
  final Value<String> parentId;
  final Value<int> rowid;
  const DropdownTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.groupKey = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.parentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DropdownTableCompanion.insert({
    required int id,
    required String name,
    required String value,
    required String groupKey,
    required int orderIndex,
    required String parentId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        value = Value(value),
        groupKey = Value(groupKey),
        orderIndex = Value(orderIndex),
        parentId = Value(parentId);
  static Insertable<DropdownTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? value,
    Expression<String>? groupKey,
    Expression<int>? orderIndex,
    Expression<String>? parentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (groupKey != null) 'group_key': groupKey,
      if (orderIndex != null) 'order_index': orderIndex,
      if (parentId != null) 'parent_id': parentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DropdownTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? value,
      Value<String>? groupKey,
      Value<int>? orderIndex,
      Value<String>? parentId,
      Value<int>? rowid}) {
    return DropdownTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      groupKey: groupKey ?? this.groupKey,
      orderIndex: orderIndex ?? this.orderIndex,
      parentId: parentId ?? this.parentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (groupKey.present) {
      map['group_key'] = Variable<String>(groupKey.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DropdownTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('groupKey: $groupKey, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('parentId: $parentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CacheTableTable extends CacheTable
    with TableInfo<$CacheTableTable, CacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileMeta = const VerificationMeta('file');
  @override
  late final GeneratedColumn<String> file = GeneratedColumn<String>(
      'file', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, url, file, size, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_table';
  @override
  VerificationContext validateIntegrity(Insertable<CacheTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('file')) {
      context.handle(
          _fileMeta, file.isAcceptableOrUnknown(data['file']!, _fileMeta));
    } else if (isInserting) {
      context.missing(_fileMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      file: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file'])!,
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
    );
  }

  @override
  $CacheTableTable createAlias(String alias) {
    return $CacheTableTable(attachedDatabase, alias);
  }
}

class CacheTableData extends DataClass implements Insertable<CacheTableData> {
  final int id;
  final String url;
  final String file;
  final int size;
  final String category;
  const CacheTableData(
      {required this.id,
      required this.url,
      required this.file,
      required this.size,
      required this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['file'] = Variable<String>(file);
    map['size'] = Variable<int>(size);
    map['category'] = Variable<String>(category);
    return map;
  }

  CacheTableCompanion toCompanion(bool nullToAbsent) {
    return CacheTableCompanion(
      id: Value(id),
      url: Value(url),
      file: Value(file),
      size: Value(size),
      category: Value(category),
    );
  }

  factory CacheTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheTableData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      file: serializer.fromJson<String>(json['file']),
      size: serializer.fromJson<int>(json['size']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'file': serializer.toJson<String>(file),
      'size': serializer.toJson<int>(size),
      'category': serializer.toJson<String>(category),
    };
  }

  CacheTableData copyWith(
          {int? id, String? url, String? file, int? size, String? category}) =>
      CacheTableData(
        id: id ?? this.id,
        url: url ?? this.url,
        file: file ?? this.file,
        size: size ?? this.size,
        category: category ?? this.category,
      );
  CacheTableData copyWithCompanion(CacheTableCompanion data) {
    return CacheTableData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      file: data.file.present ? data.file.value : this.file,
      size: data.size.present ? data.size.value : this.size,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('file: $file, ')
          ..write('size: $size, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, file, size, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheTableData &&
          other.id == this.id &&
          other.url == this.url &&
          other.file == this.file &&
          other.size == this.size &&
          other.category == this.category);
}

class CacheTableCompanion extends UpdateCompanion<CacheTableData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> file;
  final Value<int> size;
  final Value<String> category;
  const CacheTableCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.file = const Value.absent(),
    this.size = const Value.absent(),
    this.category = const Value.absent(),
  });
  CacheTableCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String file,
    required int size,
    required String category,
  })  : url = Value(url),
        file = Value(file),
        size = Value(size),
        category = Value(category);
  static Insertable<CacheTableData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? file,
    Expression<int>? size,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (file != null) 'file': file,
      if (size != null) 'size': size,
      if (category != null) 'category': category,
    });
  }

  CacheTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? url,
      Value<String>? file,
      Value<int>? size,
      Value<String>? category}) {
    return CacheTableCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      file: file ?? this.file,
      size: size ?? this.size,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (file.present) {
      map['file'] = Variable<String>(file.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('file: $file, ')
          ..write('size: $size, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DropdownTableTable dropdownTable = $DropdownTableTable(this);
  late final $CacheTableTable cacheTable = $CacheTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dropdownTable, cacheTable];
}

typedef $$DropdownTableTableCreateCompanionBuilder = DropdownTableCompanion
    Function({
  required int id,
  required String name,
  required String value,
  required String groupKey,
  required int orderIndex,
  required String parentId,
  Value<int> rowid,
});
typedef $$DropdownTableTableUpdateCompanionBuilder = DropdownTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> value,
  Value<String> groupKey,
  Value<int> orderIndex,
  Value<String> parentId,
  Value<int> rowid,
});

class $$DropdownTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DropdownTableTable> {
  $$DropdownTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get groupKey => $state.composableBuilder(
      column: $state.table.groupKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get orderIndex => $state.composableBuilder(
      column: $state.table.orderIndex,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get parentId => $state.composableBuilder(
      column: $state.table.parentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$DropdownTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DropdownTableTable> {
  $$DropdownTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get groupKey => $state.composableBuilder(
      column: $state.table.groupKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get orderIndex => $state.composableBuilder(
      column: $state.table.orderIndex,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get parentId => $state.composableBuilder(
      column: $state.table.parentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$DropdownTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DropdownTableTable,
    DropdownTableData,
    $$DropdownTableTableFilterComposer,
    $$DropdownTableTableOrderingComposer,
    $$DropdownTableTableCreateCompanionBuilder,
    $$DropdownTableTableUpdateCompanionBuilder,
    (
      DropdownTableData,
      BaseReferences<_$AppDatabase, $DropdownTableTable, DropdownTableData>
    ),
    DropdownTableData,
    PrefetchHooks Function()> {
  $$DropdownTableTableTableManager(_$AppDatabase db, $DropdownTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DropdownTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DropdownTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<String> groupKey = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<String> parentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DropdownTableCompanion(
            id: id,
            name: name,
            value: value,
            groupKey: groupKey,
            orderIndex: orderIndex,
            parentId: parentId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String name,
            required String value,
            required String groupKey,
            required int orderIndex,
            required String parentId,
            Value<int> rowid = const Value.absent(),
          }) =>
              DropdownTableCompanion.insert(
            id: id,
            name: name,
            value: value,
            groupKey: groupKey,
            orderIndex: orderIndex,
            parentId: parentId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DropdownTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DropdownTableTable,
    DropdownTableData,
    $$DropdownTableTableFilterComposer,
    $$DropdownTableTableOrderingComposer,
    $$DropdownTableTableCreateCompanionBuilder,
    $$DropdownTableTableUpdateCompanionBuilder,
    (
      DropdownTableData,
      BaseReferences<_$AppDatabase, $DropdownTableTable, DropdownTableData>
    ),
    DropdownTableData,
    PrefetchHooks Function()>;
typedef $$CacheTableTableCreateCompanionBuilder = CacheTableCompanion Function({
  Value<int> id,
  required String url,
  required String file,
  required int size,
  required String category,
});
typedef $$CacheTableTableUpdateCompanionBuilder = CacheTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> file,
  Value<int> size,
  Value<String> category,
});

class $$CacheTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CacheTableTable> {
  $$CacheTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get file => $state.composableBuilder(
      column: $state.table.file,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get size => $state.composableBuilder(
      column: $state.table.size,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CacheTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CacheTableTable> {
  $$CacheTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get file => $state.composableBuilder(
      column: $state.table.file,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get size => $state.composableBuilder(
      column: $state.table.size,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$CacheTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CacheTableTable,
    CacheTableData,
    $$CacheTableTableFilterComposer,
    $$CacheTableTableOrderingComposer,
    $$CacheTableTableCreateCompanionBuilder,
    $$CacheTableTableUpdateCompanionBuilder,
    (
      CacheTableData,
      BaseReferences<_$AppDatabase, $CacheTableTable, CacheTableData>
    ),
    CacheTableData,
    PrefetchHooks Function()> {
  $$CacheTableTableTableManager(_$AppDatabase db, $CacheTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CacheTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CacheTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> file = const Value.absent(),
            Value<int> size = const Value.absent(),
            Value<String> category = const Value.absent(),
          }) =>
              CacheTableCompanion(
            id: id,
            url: url,
            file: file,
            size: size,
            category: category,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String url,
            required String file,
            required int size,
            required String category,
          }) =>
              CacheTableCompanion.insert(
            id: id,
            url: url,
            file: file,
            size: size,
            category: category,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CacheTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CacheTableTable,
    CacheTableData,
    $$CacheTableTableFilterComposer,
    $$CacheTableTableOrderingComposer,
    $$CacheTableTableCreateCompanionBuilder,
    $$CacheTableTableUpdateCompanionBuilder,
    (
      CacheTableData,
      BaseReferences<_$AppDatabase, $CacheTableTable, CacheTableData>
    ),
    CacheTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DropdownTableTableTableManager get dropdownTable =>
      $$DropdownTableTableTableManager(_db, _db.dropdownTable);
  $$CacheTableTableTableManager get cacheTable =>
      $$CacheTableTableTableManager(_db, _db.cacheTable);
}
