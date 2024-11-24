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
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
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
  final String? parentId;
  const DropdownTableData(
      {required this.id,
      required this.name,
      required this.value,
      required this.groupKey,
      required this.orderIndex,
      this.parentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    map['group_key'] = Variable<String>(groupKey);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    return map;
  }

  DropdownTableCompanion toCompanion(bool nullToAbsent) {
    return DropdownTableCompanion(
      id: Value(id),
      name: Value(name),
      value: Value(value),
      groupKey: Value(groupKey),
      orderIndex: Value(orderIndex),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
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
      parentId: serializer.fromJson<String?>(json['parentId']),
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
      'parentId': serializer.toJson<String?>(parentId),
    };
  }

  DropdownTableData copyWith(
          {int? id,
          String? name,
          String? value,
          String? groupKey,
          int? orderIndex,
          Value<String?> parentId = const Value.absent()}) =>
      DropdownTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        groupKey: groupKey ?? this.groupKey,
        orderIndex: orderIndex ?? this.orderIndex,
        parentId: parentId.present ? parentId.value : this.parentId,
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
  final Value<String?> parentId;
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
    this.parentId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        value = Value(value),
        groupKey = Value(groupKey),
        orderIndex = Value(orderIndex);
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
      Value<String?>? parentId,
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
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
      'hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _file_idMeta =
      const VerificationMeta('file_id');
  @override
  late final GeneratedColumn<String> file_id = GeneratedColumn<String>(
      'file_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, url, file, size, category, hash, file_id];
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
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    }
    if (data.containsKey('file_id')) {
      context.handle(_file_idMeta,
          file_id.isAcceptableOrUnknown(data['file_id']!, _file_idMeta));
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
      hash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash']),
      file_id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_id']),
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
  final String? hash;
  final String? file_id;
  const CacheTableData(
      {required this.id,
      required this.url,
      required this.file,
      required this.size,
      required this.category,
      this.hash,
      this.file_id});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['file'] = Variable<String>(file);
    map['size'] = Variable<int>(size);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || hash != null) {
      map['hash'] = Variable<String>(hash);
    }
    if (!nullToAbsent || file_id != null) {
      map['file_id'] = Variable<String>(file_id);
    }
    return map;
  }

  CacheTableCompanion toCompanion(bool nullToAbsent) {
    return CacheTableCompanion(
      id: Value(id),
      url: Value(url),
      file: Value(file),
      size: Value(size),
      category: Value(category),
      hash: hash == null && nullToAbsent ? const Value.absent() : Value(hash),
      file_id: file_id == null && nullToAbsent
          ? const Value.absent()
          : Value(file_id),
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
      hash: serializer.fromJson<String?>(json['hash']),
      file_id: serializer.fromJson<String?>(json['file_id']),
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
      'hash': serializer.toJson<String?>(hash),
      'file_id': serializer.toJson<String?>(file_id),
    };
  }

  CacheTableData copyWith(
          {int? id,
          String? url,
          String? file,
          int? size,
          String? category,
          Value<String?> hash = const Value.absent(),
          Value<String?> file_id = const Value.absent()}) =>
      CacheTableData(
        id: id ?? this.id,
        url: url ?? this.url,
        file: file ?? this.file,
        size: size ?? this.size,
        category: category ?? this.category,
        hash: hash.present ? hash.value : this.hash,
        file_id: file_id.present ? file_id.value : this.file_id,
      );
  CacheTableData copyWithCompanion(CacheTableCompanion data) {
    return CacheTableData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      file: data.file.present ? data.file.value : this.file,
      size: data.size.present ? data.size.value : this.size,
      category: data.category.present ? data.category.value : this.category,
      hash: data.hash.present ? data.hash.value : this.hash,
      file_id: data.file_id.present ? data.file_id.value : this.file_id,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('file: $file, ')
          ..write('size: $size, ')
          ..write('category: $category, ')
          ..write('hash: $hash, ')
          ..write('file_id: $file_id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, file, size, category, hash, file_id);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheTableData &&
          other.id == this.id &&
          other.url == this.url &&
          other.file == this.file &&
          other.size == this.size &&
          other.category == this.category &&
          other.hash == this.hash &&
          other.file_id == this.file_id);
}

class CacheTableCompanion extends UpdateCompanion<CacheTableData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> file;
  final Value<int> size;
  final Value<String> category;
  final Value<String?> hash;
  final Value<String?> file_id;
  const CacheTableCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.file = const Value.absent(),
    this.size = const Value.absent(),
    this.category = const Value.absent(),
    this.hash = const Value.absent(),
    this.file_id = const Value.absent(),
  });
  CacheTableCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String file,
    required int size,
    required String category,
    this.hash = const Value.absent(),
    this.file_id = const Value.absent(),
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
    Expression<String>? hash,
    Expression<String>? file_id,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (file != null) 'file': file,
      if (size != null) 'size': size,
      if (category != null) 'category': category,
      if (hash != null) 'hash': hash,
      if (file_id != null) 'file_id': file_id,
    });
  }

  CacheTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? url,
      Value<String>? file,
      Value<int>? size,
      Value<String>? category,
      Value<String?>? hash,
      Value<String?>? file_id}) {
    return CacheTableCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      file: file ?? this.file,
      size: size ?? this.size,
      category: category ?? this.category,
      hash: hash ?? this.hash,
      file_id: file_id ?? this.file_id,
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
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (file_id.present) {
      map['file_id'] = Variable<String>(file_id.value);
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
          ..write('category: $category, ')
          ..write('hash: $hash, ')
          ..write('file_id: $file_id')
          ..write(')'))
        .toString();
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullnameMeta =
      const VerificationMeta('fullname');
  @override
  late final GeneratedColumn<String> fullname = GeneratedColumn<String>(
      'fullname', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastMeta = const VerificationMeta('last');
  @override
  late final GeneratedColumn<String> last = GeneratedColumn<String>(
      'last', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _seenMeta = const VerificationMeta('seen');
  @override
  late final GeneratedColumn<String> seen = GeneratedColumn<String>(
      'seen', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _verifiedMeta =
      const VerificationMeta('verified');
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
      'verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("verified" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>, String>
      data = GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<dynamic, dynamic>>($UserTableTable.$converterdata);
  @override
  List<GeneratedColumn> get $columns =>
      [id, status, avatar, fullname, last, seen, verified, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    if (data.containsKey('fullname')) {
      context.handle(_fullnameMeta,
          fullname.isAcceptableOrUnknown(data['fullname']!, _fullnameMeta));
    } else if (isInserting) {
      context.missing(_fullnameMeta);
    }
    if (data.containsKey('last')) {
      context.handle(
          _lastMeta, last.isAcceptableOrUnknown(data['last']!, _lastMeta));
    } else if (isInserting) {
      context.missing(_lastMeta);
    }
    if (data.containsKey('seen')) {
      context.handle(
          _seenMeta, seen.isAcceptableOrUnknown(data['seen']!, _seenMeta));
    } else if (isInserting) {
      context.missing(_seenMeta);
    }
    if (data.containsKey('verified')) {
      context.handle(_verifiedMeta,
          verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta));
    }
    context.handle(_dataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar'])!,
      fullname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fullname'])!,
      last: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last'])!,
      seen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}seen'])!,
      verified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}verified'])!,
      data: $UserTableTable.$converterdata.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<dynamic, dynamic>, String, String>
      $converterdata = JsonConverter();
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final String id;
  final String status;
  final String avatar;
  final String fullname;
  final String last;
  final String seen;
  final bool verified;
  final Map<dynamic, dynamic> data;
  const UserTableData(
      {required this.id,
      required this.status,
      required this.avatar,
      required this.fullname,
      required this.last,
      required this.seen,
      required this.verified,
      required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    map['avatar'] = Variable<String>(avatar);
    map['fullname'] = Variable<String>(fullname);
    map['last'] = Variable<String>(last);
    map['seen'] = Variable<String>(seen);
    map['verified'] = Variable<bool>(verified);
    {
      map['data'] =
          Variable<String>($UserTableTable.$converterdata.toSql(data));
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      status: Value(status),
      avatar: Value(avatar),
      fullname: Value(fullname),
      last: Value(last),
      seen: Value(seen),
      verified: Value(verified),
      data: Value(data),
    );
  }

  factory UserTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      avatar: serializer.fromJson<String>(json['avatar']),
      fullname: serializer.fromJson<String>(json['fullname']),
      last: serializer.fromJson<String>(json['last']),
      seen: serializer.fromJson<String>(json['seen']),
      verified: serializer.fromJson<bool>(json['verified']),
      data: $UserTableTable.$converterdata
          .fromJson(serializer.fromJson<String>(json['data'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
      'avatar': serializer.toJson<String>(avatar),
      'fullname': serializer.toJson<String>(fullname),
      'last': serializer.toJson<String>(last),
      'seen': serializer.toJson<String>(seen),
      'verified': serializer.toJson<bool>(verified),
      'data': serializer
          .toJson<String>($UserTableTable.$converterdata.toJson(data)),
    };
  }

  UserTableData copyWith(
          {String? id,
          String? status,
          String? avatar,
          String? fullname,
          String? last,
          String? seen,
          bool? verified,
          Map<dynamic, dynamic>? data}) =>
      UserTableData(
        id: id ?? this.id,
        status: status ?? this.status,
        avatar: avatar ?? this.avatar,
        fullname: fullname ?? this.fullname,
        last: last ?? this.last,
        seen: seen ?? this.seen,
        verified: verified ?? this.verified,
        data: data ?? this.data,
      );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      fullname: data.fullname.present ? data.fullname.value : this.fullname,
      last: data.last.present ? data.last.value : this.last,
      seen: data.seen.present ? data.seen.value : this.seen,
      verified: data.verified.present ? data.verified.value : this.verified,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('avatar: $avatar, ')
          ..write('fullname: $fullname, ')
          ..write('last: $last, ')
          ..write('seen: $seen, ')
          ..write('verified: $verified, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, status, avatar, fullname, last, seen, verified, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.status == this.status &&
          other.avatar == this.avatar &&
          other.fullname == this.fullname &&
          other.last == this.last &&
          other.seen == this.seen &&
          other.verified == this.verified &&
          other.data == this.data);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<String> id;
  final Value<String> status;
  final Value<String> avatar;
  final Value<String> fullname;
  final Value<String> last;
  final Value<String> seen;
  final Value<bool> verified;
  final Value<Map<dynamic, dynamic>> data;
  final Value<int> rowid;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.avatar = const Value.absent(),
    this.fullname = const Value.absent(),
    this.last = const Value.absent(),
    this.seen = const Value.absent(),
    this.verified = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String id,
    required String status,
    required String avatar,
    required String fullname,
    required String last,
    required String seen,
    this.verified = const Value.absent(),
    required Map<dynamic, dynamic> data,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        status = Value(status),
        avatar = Value(avatar),
        fullname = Value(fullname),
        last = Value(last),
        seen = Value(seen),
        data = Value(data);
  static Insertable<UserTableData> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<String>? avatar,
    Expression<String>? fullname,
    Expression<String>? last,
    Expression<String>? seen,
    Expression<bool>? verified,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (avatar != null) 'avatar': avatar,
      if (fullname != null) 'fullname': fullname,
      if (last != null) 'last': last,
      if (seen != null) 'seen': seen,
      if (verified != null) 'verified': verified,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? status,
      Value<String>? avatar,
      Value<String>? fullname,
      Value<String>? last,
      Value<String>? seen,
      Value<bool>? verified,
      Value<Map<dynamic, dynamic>>? data,
      Value<int>? rowid}) {
    return UserTableCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      fullname: fullname ?? this.fullname,
      last: last ?? this.last,
      seen: seen ?? this.seen,
      verified: verified ?? this.verified,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (fullname.present) {
      map['fullname'] = Variable<String>(fullname.value);
    }
    if (last.present) {
      map['last'] = Variable<String>(last.value);
    }
    if (seen.present) {
      map['seen'] = Variable<String>(seen.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (data.present) {
      map['data'] =
          Variable<String>($UserTableTable.$converterdata.toSql(data.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('avatar: $avatar, ')
          ..write('fullname: $fullname, ')
          ..write('last: $last, ')
          ..write('seen: $seen, ')
          ..write('verified: $verified, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatTableTable extends ChatTable
    with TableInfo<$ChatTableTable, ChatTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _chat_idMeta =
      const VerificationMeta('chat_id');
  @override
  late final GeneratedColumn<String> chat_id = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _user_idMeta =
      const VerificationMeta('user_id');
  @override
  late final GeneratedColumn<String> user_id = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>, String>
      message = GeneratedColumn<String>('message', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant("{}"))
          .withConverter<Map<dynamic, dynamic>>(
              $ChatTableTable.$convertermessage);
  static const VerificationMeta _permissionsMeta =
      const VerificationMeta('permissions');
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
      'permissions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant('normal'));
  static const VerificationMeta _unread_countMeta =
      const VerificationMeta('unread_count');
  @override
  late final GeneratedColumn<int> unread_count = GeneratedColumn<int>(
      'unread_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _updated_atMeta =
      const VerificationMeta('updated_at');
  @override
  late final GeneratedColumn<DateTime> updated_at = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        chat_id,
        user_id,
        message,
        permissions,
        status,
        unread_count,
        updated_at
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChatTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chat_idMeta,
          chat_id.isAcceptableOrUnknown(data['chat_id']!, _chat_idMeta));
    } else if (isInserting) {
      context.missing(_chat_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_user_idMeta,
          user_id.isAcceptableOrUnknown(data['user_id']!, _user_idMeta));
    } else if (isInserting) {
      context.missing(_user_idMeta);
    }
    context.handle(_messageMeta, const VerificationResult.success());
    if (data.containsKey('permissions')) {
      context.handle(
          _permissionsMeta,
          permissions.isAcceptableOrUnknown(
              data['permissions']!, _permissionsMeta));
    } else if (isInserting) {
      context.missing(_permissionsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('unread_count')) {
      context.handle(
          _unread_countMeta,
          unread_count.isAcceptableOrUnknown(
              data['unread_count']!, _unread_countMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(
          _updated_atMeta,
          updated_at.isAcceptableOrUnknown(
              data['updated_at']!, _updated_atMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      chat_id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      user_id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      message: $ChatTableTable.$convertermessage.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!),
      permissions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permissions'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      unread_count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unread_count'])!,
      updated_at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ChatTableTable createAlias(String alias) {
    return $ChatTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<dynamic, dynamic>, String, String>
      $convertermessage = JsonConverter();
}

class ChatTableData extends DataClass implements Insertable<ChatTableData> {
  final int id;
  final String chat_id;
  final String user_id;
  final Map<dynamic, dynamic> message;
  final String permissions;
  final String status;
  final int unread_count;
  final DateTime updated_at;
  const ChatTableData(
      {required this.id,
      required this.chat_id,
      required this.user_id,
      required this.message,
      required this.permissions,
      required this.status,
      required this.unread_count,
      required this.updated_at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<String>(chat_id);
    map['user_id'] = Variable<String>(user_id);
    {
      map['message'] =
          Variable<String>($ChatTableTable.$convertermessage.toSql(message));
    }
    map['permissions'] = Variable<String>(permissions);
    map['status'] = Variable<String>(status);
    map['unread_count'] = Variable<int>(unread_count);
    map['updated_at'] = Variable<DateTime>(updated_at);
    return map;
  }

  ChatTableCompanion toCompanion(bool nullToAbsent) {
    return ChatTableCompanion(
      id: Value(id),
      chat_id: Value(chat_id),
      user_id: Value(user_id),
      message: Value(message),
      permissions: Value(permissions),
      status: Value(status),
      unread_count: Value(unread_count),
      updated_at: Value(updated_at),
    );
  }

  factory ChatTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatTableData(
      id: serializer.fromJson<int>(json['id']),
      chat_id: serializer.fromJson<String>(json['chat_id']),
      user_id: serializer.fromJson<String>(json['user_id']),
      message: $ChatTableTable.$convertermessage
          .fromJson(serializer.fromJson<String>(json['message'])),
      permissions: serializer.fromJson<String>(json['permissions']),
      status: serializer.fromJson<String>(json['status']),
      unread_count: serializer.fromJson<int>(json['unread_count']),
      updated_at: serializer.fromJson<DateTime>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chat_id': serializer.toJson<String>(chat_id),
      'user_id': serializer.toJson<String>(user_id),
      'message': serializer
          .toJson<String>($ChatTableTable.$convertermessage.toJson(message)),
      'permissions': serializer.toJson<String>(permissions),
      'status': serializer.toJson<String>(status),
      'unread_count': serializer.toJson<int>(unread_count),
      'updated_at': serializer.toJson<DateTime>(updated_at),
    };
  }

  ChatTableData copyWith(
          {int? id,
          String? chat_id,
          String? user_id,
          Map<dynamic, dynamic>? message,
          String? permissions,
          String? status,
          int? unread_count,
          DateTime? updated_at}) =>
      ChatTableData(
        id: id ?? this.id,
        chat_id: chat_id ?? this.chat_id,
        user_id: user_id ?? this.user_id,
        message: message ?? this.message,
        permissions: permissions ?? this.permissions,
        status: status ?? this.status,
        unread_count: unread_count ?? this.unread_count,
        updated_at: updated_at ?? this.updated_at,
      );
  ChatTableData copyWithCompanion(ChatTableCompanion data) {
    return ChatTableData(
      id: data.id.present ? data.id.value : this.id,
      chat_id: data.chat_id.present ? data.chat_id.value : this.chat_id,
      user_id: data.user_id.present ? data.user_id.value : this.user_id,
      message: data.message.present ? data.message.value : this.message,
      permissions:
          data.permissions.present ? data.permissions.value : this.permissions,
      status: data.status.present ? data.status.value : this.status,
      unread_count: data.unread_count.present
          ? data.unread_count.value
          : this.unread_count,
      updated_at:
          data.updated_at.present ? data.updated_at.value : this.updated_at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatTableData(')
          ..write('id: $id, ')
          ..write('chat_id: $chat_id, ')
          ..write('user_id: $user_id, ')
          ..write('message: $message, ')
          ..write('permissions: $permissions, ')
          ..write('status: $status, ')
          ..write('unread_count: $unread_count, ')
          ..write('updated_at: $updated_at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chat_id, user_id, message, permissions,
      status, unread_count, updated_at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatTableData &&
          other.id == this.id &&
          other.chat_id == this.chat_id &&
          other.user_id == this.user_id &&
          other.message == this.message &&
          other.permissions == this.permissions &&
          other.status == this.status &&
          other.unread_count == this.unread_count &&
          other.updated_at == this.updated_at);
}

class ChatTableCompanion extends UpdateCompanion<ChatTableData> {
  final Value<int> id;
  final Value<String> chat_id;
  final Value<String> user_id;
  final Value<Map<dynamic, dynamic>> message;
  final Value<String> permissions;
  final Value<String> status;
  final Value<int> unread_count;
  final Value<DateTime> updated_at;
  const ChatTableCompanion({
    this.id = const Value.absent(),
    this.chat_id = const Value.absent(),
    this.user_id = const Value.absent(),
    this.message = const Value.absent(),
    this.permissions = const Value.absent(),
    this.status = const Value.absent(),
    this.unread_count = const Value.absent(),
    this.updated_at = const Value.absent(),
  });
  ChatTableCompanion.insert({
    this.id = const Value.absent(),
    required String chat_id,
    required String user_id,
    this.message = const Value.absent(),
    required String permissions,
    this.status = const Value.absent(),
    this.unread_count = const Value.absent(),
    this.updated_at = const Value.absent(),
  })  : chat_id = Value(chat_id),
        user_id = Value(user_id),
        permissions = Value(permissions);
  static Insertable<ChatTableData> custom({
    Expression<int>? id,
    Expression<String>? chat_id,
    Expression<String>? user_id,
    Expression<String>? message,
    Expression<String>? permissions,
    Expression<String>? status,
    Expression<int>? unread_count,
    Expression<DateTime>? updated_at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chat_id != null) 'chat_id': chat_id,
      if (user_id != null) 'user_id': user_id,
      if (message != null) 'message': message,
      if (permissions != null) 'permissions': permissions,
      if (status != null) 'status': status,
      if (unread_count != null) 'unread_count': unread_count,
      if (updated_at != null) 'updated_at': updated_at,
    });
  }

  ChatTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? chat_id,
      Value<String>? user_id,
      Value<Map<dynamic, dynamic>>? message,
      Value<String>? permissions,
      Value<String>? status,
      Value<int>? unread_count,
      Value<DateTime>? updated_at}) {
    return ChatTableCompanion(
      id: id ?? this.id,
      chat_id: chat_id ?? this.chat_id,
      user_id: user_id ?? this.user_id,
      message: message ?? this.message,
      permissions: permissions ?? this.permissions,
      status: status ?? this.status,
      unread_count: unread_count ?? this.unread_count,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chat_id.present) {
      map['chat_id'] = Variable<String>(chat_id.value);
    }
    if (user_id.present) {
      map['user_id'] = Variable<String>(user_id.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(
          $ChatTableTable.$convertermessage.toSql(message.value));
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (unread_count.present) {
      map['unread_count'] = Variable<int>(unread_count.value);
    }
    if (updated_at.present) {
      map['updated_at'] = Variable<DateTime>(updated_at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatTableCompanion(')
          ..write('id: $id, ')
          ..write('chat_id: $chat_id, ')
          ..write('user_id: $user_id, ')
          ..write('message: $message, ')
          ..write('permissions: $permissions, ')
          ..write('status: $status, ')
          ..write('unread_count: $unread_count, ')
          ..write('updated_at: $updated_at')
          ..write(')'))
        .toString();
  }
}

class $MessageTableTable extends MessageTable
    with TableInfo<$MessageTableTable, MessageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _message_idMeta =
      const VerificationMeta('message_id');
  @override
  late final GeneratedColumn<String> message_id = GeneratedColumn<String>(
      'message_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _local_idMeta =
      const VerificationMeta('local_id');
  @override
  late final GeneratedColumn<String> local_id = GeneratedColumn<String>(
      'local_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chat_idMeta =
      const VerificationMeta('chat_id');
  @override
  late final GeneratedColumn<String> chat_id = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant('unknown'));
  static const VerificationMeta _sender_idMeta =
      const VerificationMeta('sender_id');
  @override
  late final GeneratedColumn<String> sender_id = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sent_atMeta =
      const VerificationMeta('sent_at');
  @override
  late final GeneratedColumn<DateTime> sent_at = GeneratedColumn<DateTime>(
      'sent_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>, String>
      data = GeneratedColumn<String>('data', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<dynamic, dynamic>>(
              $MessageTableTable.$converterdata);
  static const VerificationMeta _metaMeta = const VerificationMeta('meta');
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>, String>
      meta = GeneratedColumn<String>('meta', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<dynamic, dynamic>>(
              $MessageTableTable.$convertermeta);
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumnWithTypeConverter<Map<dynamic, dynamic>, String>
      theme = GeneratedColumn<String>('theme', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<dynamic, dynamic>>(
              $MessageTableTable.$convertertheme);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
      'seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _reply_message_idMeta =
      const VerificationMeta('reply_message_id');
  @override
  late final GeneratedColumn<String> reply_message_id = GeneratedColumn<String>(
      'reply_message_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reactionMeta =
      const VerificationMeta('reaction');
  @override
  late final GeneratedColumn<String> reaction = GeneratedColumn<String>(
      'reaction', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        message_id,
        local_id,
        chat_id,
        status,
        sender_id,
        sent_at,
        type,
        data,
        meta,
        theme,
        seq,
        reply_message_id,
        reaction
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_table';
  @override
  VerificationContext validateIntegrity(Insertable<MessageTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(
          _message_idMeta,
          message_id.isAcceptableOrUnknown(
              data['message_id']!, _message_idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(_local_idMeta,
          local_id.isAcceptableOrUnknown(data['local_id']!, _local_idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chat_idMeta,
          chat_id.isAcceptableOrUnknown(data['chat_id']!, _chat_idMeta));
    } else if (isInserting) {
      context.missing(_chat_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('sender_id')) {
      context.handle(_sender_idMeta,
          sender_id.isAcceptableOrUnknown(data['sender_id']!, _sender_idMeta));
    } else if (isInserting) {
      context.missing(_sender_idMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sent_atMeta,
          sent_at.isAcceptableOrUnknown(data['sent_at']!, _sent_atMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    context.handle(_dataMeta, const VerificationResult.success());
    context.handle(_metaMeta, const VerificationResult.success());
    context.handle(_themeMeta, const VerificationResult.success());
    if (data.containsKey('seq')) {
      context.handle(
          _seqMeta, seq.isAcceptableOrUnknown(data['seq']!, _seqMeta));
    }
    if (data.containsKey('reply_message_id')) {
      context.handle(
          _reply_message_idMeta,
          reply_message_id.isAcceptableOrUnknown(
              data['reply_message_id']!, _reply_message_idMeta));
    }
    if (data.containsKey('reaction')) {
      context.handle(_reactionMeta,
          reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      message_id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id']),
      local_id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id']),
      chat_id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      sender_id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      sent_at: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      data: $MessageTableTable.$converterdata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!),
      meta: $MessageTableTable.$convertermeta.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meta'])!),
      theme: $MessageTableTable.$convertertheme.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!),
      seq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seq'])!,
      reply_message_id: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reply_message_id']),
      reaction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reaction']),
    );
  }

  @override
  $MessageTableTable createAlias(String alias) {
    return $MessageTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<dynamic, dynamic>, String, String>
      $converterdata = JsonConverter();
  static JsonTypeConverter2<Map<dynamic, dynamic>, String, String>
      $convertermeta = JsonConverter();
  static JsonTypeConverter2<Map<dynamic, dynamic>, String, String>
      $convertertheme = JsonConverter();
}

class MessageTableData extends DataClass
    implements Insertable<MessageTableData> {
  final int id;
  final String? message_id;
  final String? local_id;
  final String chat_id;
  final String status;
  final String sender_id;
  final DateTime sent_at;
  final String type;
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> meta;
  final Map<dynamic, dynamic> theme;
  final int seq;
  final String? reply_message_id;
  final String? reaction;
  const MessageTableData(
      {required this.id,
      this.message_id,
      this.local_id,
      required this.chat_id,
      required this.status,
      required this.sender_id,
      required this.sent_at,
      required this.type,
      required this.data,
      required this.meta,
      required this.theme,
      required this.seq,
      this.reply_message_id,
      this.reaction});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || message_id != null) {
      map['message_id'] = Variable<String>(message_id);
    }
    if (!nullToAbsent || local_id != null) {
      map['local_id'] = Variable<String>(local_id);
    }
    map['chat_id'] = Variable<String>(chat_id);
    map['status'] = Variable<String>(status);
    map['sender_id'] = Variable<String>(sender_id);
    map['sent_at'] = Variable<DateTime>(sent_at);
    map['type'] = Variable<String>(type);
    {
      map['data'] =
          Variable<String>($MessageTableTable.$converterdata.toSql(data));
    }
    {
      map['meta'] =
          Variable<String>($MessageTableTable.$convertermeta.toSql(meta));
    }
    {
      map['theme'] =
          Variable<String>($MessageTableTable.$convertertheme.toSql(theme));
    }
    map['seq'] = Variable<int>(seq);
    if (!nullToAbsent || reply_message_id != null) {
      map['reply_message_id'] = Variable<String>(reply_message_id);
    }
    if (!nullToAbsent || reaction != null) {
      map['reaction'] = Variable<String>(reaction);
    }
    return map;
  }

  MessageTableCompanion toCompanion(bool nullToAbsent) {
    return MessageTableCompanion(
      id: Value(id),
      message_id: message_id == null && nullToAbsent
          ? const Value.absent()
          : Value(message_id),
      local_id: local_id == null && nullToAbsent
          ? const Value.absent()
          : Value(local_id),
      chat_id: Value(chat_id),
      status: Value(status),
      sender_id: Value(sender_id),
      sent_at: Value(sent_at),
      type: Value(type),
      data: Value(data),
      meta: Value(meta),
      theme: Value(theme),
      seq: Value(seq),
      reply_message_id: reply_message_id == null && nullToAbsent
          ? const Value.absent()
          : Value(reply_message_id),
      reaction: reaction == null && nullToAbsent
          ? const Value.absent()
          : Value(reaction),
    );
  }

  factory MessageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageTableData(
      id: serializer.fromJson<int>(json['id']),
      message_id: serializer.fromJson<String?>(json['message_id']),
      local_id: serializer.fromJson<String?>(json['local_id']),
      chat_id: serializer.fromJson<String>(json['chat_id']),
      status: serializer.fromJson<String>(json['status']),
      sender_id: serializer.fromJson<String>(json['sender_id']),
      sent_at: serializer.fromJson<DateTime>(json['sent_at']),
      type: serializer.fromJson<String>(json['type']),
      data: $MessageTableTable.$converterdata
          .fromJson(serializer.fromJson<String>(json['data'])),
      meta: $MessageTableTable.$convertermeta
          .fromJson(serializer.fromJson<String>(json['meta'])),
      theme: $MessageTableTable.$convertertheme
          .fromJson(serializer.fromJson<String>(json['theme'])),
      seq: serializer.fromJson<int>(json['seq']),
      reply_message_id: serializer.fromJson<String?>(json['reply_message_id']),
      reaction: serializer.fromJson<String?>(json['reaction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'message_id': serializer.toJson<String?>(message_id),
      'local_id': serializer.toJson<String?>(local_id),
      'chat_id': serializer.toJson<String>(chat_id),
      'status': serializer.toJson<String>(status),
      'sender_id': serializer.toJson<String>(sender_id),
      'sent_at': serializer.toJson<DateTime>(sent_at),
      'type': serializer.toJson<String>(type),
      'data': serializer
          .toJson<String>($MessageTableTable.$converterdata.toJson(data)),
      'meta': serializer
          .toJson<String>($MessageTableTable.$convertermeta.toJson(meta)),
      'theme': serializer
          .toJson<String>($MessageTableTable.$convertertheme.toJson(theme)),
      'seq': serializer.toJson<int>(seq),
      'reply_message_id': serializer.toJson<String?>(reply_message_id),
      'reaction': serializer.toJson<String?>(reaction),
    };
  }

  MessageTableData copyWith(
          {int? id,
          Value<String?> message_id = const Value.absent(),
          Value<String?> local_id = const Value.absent(),
          String? chat_id,
          String? status,
          String? sender_id,
          DateTime? sent_at,
          String? type,
          Map<dynamic, dynamic>? data,
          Map<dynamic, dynamic>? meta,
          Map<dynamic, dynamic>? theme,
          int? seq,
          Value<String?> reply_message_id = const Value.absent(),
          Value<String?> reaction = const Value.absent()}) =>
      MessageTableData(
        id: id ?? this.id,
        message_id: message_id.present ? message_id.value : this.message_id,
        local_id: local_id.present ? local_id.value : this.local_id,
        chat_id: chat_id ?? this.chat_id,
        status: status ?? this.status,
        sender_id: sender_id ?? this.sender_id,
        sent_at: sent_at ?? this.sent_at,
        type: type ?? this.type,
        data: data ?? this.data,
        meta: meta ?? this.meta,
        theme: theme ?? this.theme,
        seq: seq ?? this.seq,
        reply_message_id: reply_message_id.present
            ? reply_message_id.value
            : this.reply_message_id,
        reaction: reaction.present ? reaction.value : this.reaction,
      );
  MessageTableData copyWithCompanion(MessageTableCompanion data) {
    return MessageTableData(
      id: data.id.present ? data.id.value : this.id,
      message_id:
          data.message_id.present ? data.message_id.value : this.message_id,
      local_id: data.local_id.present ? data.local_id.value : this.local_id,
      chat_id: data.chat_id.present ? data.chat_id.value : this.chat_id,
      status: data.status.present ? data.status.value : this.status,
      sender_id: data.sender_id.present ? data.sender_id.value : this.sender_id,
      sent_at: data.sent_at.present ? data.sent_at.value : this.sent_at,
      type: data.type.present ? data.type.value : this.type,
      data: data.data.present ? data.data.value : this.data,
      meta: data.meta.present ? data.meta.value : this.meta,
      theme: data.theme.present ? data.theme.value : this.theme,
      seq: data.seq.present ? data.seq.value : this.seq,
      reply_message_id: data.reply_message_id.present
          ? data.reply_message_id.value
          : this.reply_message_id,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageTableData(')
          ..write('id: $id, ')
          ..write('message_id: $message_id, ')
          ..write('local_id: $local_id, ')
          ..write('chat_id: $chat_id, ')
          ..write('status: $status, ')
          ..write('sender_id: $sender_id, ')
          ..write('sent_at: $sent_at, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('meta: $meta, ')
          ..write('theme: $theme, ')
          ..write('seq: $seq, ')
          ..write('reply_message_id: $reply_message_id, ')
          ..write('reaction: $reaction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      message_id,
      local_id,
      chat_id,
      status,
      sender_id,
      sent_at,
      type,
      data,
      meta,
      theme,
      seq,
      reply_message_id,
      reaction);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageTableData &&
          other.id == this.id &&
          other.message_id == this.message_id &&
          other.local_id == this.local_id &&
          other.chat_id == this.chat_id &&
          other.status == this.status &&
          other.sender_id == this.sender_id &&
          other.sent_at == this.sent_at &&
          other.type == this.type &&
          other.data == this.data &&
          other.meta == this.meta &&
          other.theme == this.theme &&
          other.seq == this.seq &&
          other.reply_message_id == this.reply_message_id &&
          other.reaction == this.reaction);
}

class MessageTableCompanion extends UpdateCompanion<MessageTableData> {
  final Value<int> id;
  final Value<String?> message_id;
  final Value<String?> local_id;
  final Value<String> chat_id;
  final Value<String> status;
  final Value<String> sender_id;
  final Value<DateTime> sent_at;
  final Value<String> type;
  final Value<Map<dynamic, dynamic>> data;
  final Value<Map<dynamic, dynamic>> meta;
  final Value<Map<dynamic, dynamic>> theme;
  final Value<int> seq;
  final Value<String?> reply_message_id;
  final Value<String?> reaction;
  const MessageTableCompanion({
    this.id = const Value.absent(),
    this.message_id = const Value.absent(),
    this.local_id = const Value.absent(),
    this.chat_id = const Value.absent(),
    this.status = const Value.absent(),
    this.sender_id = const Value.absent(),
    this.sent_at = const Value.absent(),
    this.type = const Value.absent(),
    this.data = const Value.absent(),
    this.meta = const Value.absent(),
    this.theme = const Value.absent(),
    this.seq = const Value.absent(),
    this.reply_message_id = const Value.absent(),
    this.reaction = const Value.absent(),
  });
  MessageTableCompanion.insert({
    this.id = const Value.absent(),
    this.message_id = const Value.absent(),
    this.local_id = const Value.absent(),
    required String chat_id,
    this.status = const Value.absent(),
    required String sender_id,
    this.sent_at = const Value.absent(),
    required String type,
    required Map<dynamic, dynamic> data,
    required Map<dynamic, dynamic> meta,
    required Map<dynamic, dynamic> theme,
    this.seq = const Value.absent(),
    this.reply_message_id = const Value.absent(),
    this.reaction = const Value.absent(),
  })  : chat_id = Value(chat_id),
        sender_id = Value(sender_id),
        type = Value(type),
        data = Value(data),
        meta = Value(meta),
        theme = Value(theme);
  static Insertable<MessageTableData> custom({
    Expression<int>? id,
    Expression<String>? message_id,
    Expression<String>? local_id,
    Expression<String>? chat_id,
    Expression<String>? status,
    Expression<String>? sender_id,
    Expression<DateTime>? sent_at,
    Expression<String>? type,
    Expression<String>? data,
    Expression<String>? meta,
    Expression<String>? theme,
    Expression<int>? seq,
    Expression<String>? reply_message_id,
    Expression<String>? reaction,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (message_id != null) 'message_id': message_id,
      if (local_id != null) 'local_id': local_id,
      if (chat_id != null) 'chat_id': chat_id,
      if (status != null) 'status': status,
      if (sender_id != null) 'sender_id': sender_id,
      if (sent_at != null) 'sent_at': sent_at,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
      if (meta != null) 'meta': meta,
      if (theme != null) 'theme': theme,
      if (seq != null) 'seq': seq,
      if (reply_message_id != null) 'reply_message_id': reply_message_id,
      if (reaction != null) 'reaction': reaction,
    });
  }

  MessageTableCompanion copyWith(
      {Value<int>? id,
      Value<String?>? message_id,
      Value<String?>? local_id,
      Value<String>? chat_id,
      Value<String>? status,
      Value<String>? sender_id,
      Value<DateTime>? sent_at,
      Value<String>? type,
      Value<Map<dynamic, dynamic>>? data,
      Value<Map<dynamic, dynamic>>? meta,
      Value<Map<dynamic, dynamic>>? theme,
      Value<int>? seq,
      Value<String?>? reply_message_id,
      Value<String?>? reaction}) {
    return MessageTableCompanion(
      id: id ?? this.id,
      message_id: message_id ?? this.message_id,
      local_id: local_id ?? this.local_id,
      chat_id: chat_id ?? this.chat_id,
      status: status ?? this.status,
      sender_id: sender_id ?? this.sender_id,
      sent_at: sent_at ?? this.sent_at,
      type: type ?? this.type,
      data: data ?? this.data,
      meta: meta ?? this.meta,
      theme: theme ?? this.theme,
      seq: seq ?? this.seq,
      reply_message_id: reply_message_id ?? this.reply_message_id,
      reaction: reaction ?? this.reaction,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (message_id.present) {
      map['message_id'] = Variable<String>(message_id.value);
    }
    if (local_id.present) {
      map['local_id'] = Variable<String>(local_id.value);
    }
    if (chat_id.present) {
      map['chat_id'] = Variable<String>(chat_id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sender_id.present) {
      map['sender_id'] = Variable<String>(sender_id.value);
    }
    if (sent_at.present) {
      map['sent_at'] = Variable<DateTime>(sent_at.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (data.present) {
      map['data'] =
          Variable<String>($MessageTableTable.$converterdata.toSql(data.value));
    }
    if (meta.present) {
      map['meta'] =
          Variable<String>($MessageTableTable.$convertermeta.toSql(meta.value));
    }
    if (theme.present) {
      map['theme'] = Variable<String>(
          $MessageTableTable.$convertertheme.toSql(theme.value));
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (reply_message_id.present) {
      map['reply_message_id'] = Variable<String>(reply_message_id.value);
    }
    if (reaction.present) {
      map['reaction'] = Variable<String>(reaction.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTableCompanion(')
          ..write('id: $id, ')
          ..write('message_id: $message_id, ')
          ..write('local_id: $local_id, ')
          ..write('chat_id: $chat_id, ')
          ..write('status: $status, ')
          ..write('sender_id: $sender_id, ')
          ..write('sent_at: $sent_at, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('meta: $meta, ')
          ..write('theme: $theme, ')
          ..write('seq: $seq, ')
          ..write('reply_message_id: $reply_message_id, ')
          ..write('reaction: $reaction')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DropdownTableTable dropdownTable = $DropdownTableTable(this);
  late final $CacheTableTable cacheTable = $CacheTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $ChatTableTable chatTable = $ChatTableTable(this);
  late final $MessageTableTable messageTable = $MessageTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dropdownTable, cacheTable, userTable, chatTable, messageTable];
}

typedef $$DropdownTableTableCreateCompanionBuilder = DropdownTableCompanion
    Function({
  required int id,
  required String name,
  required String value,
  required String groupKey,
  required int orderIndex,
  Value<String?> parentId,
  Value<int> rowid,
});
typedef $$DropdownTableTableUpdateCompanionBuilder = DropdownTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> value,
  Value<String> groupKey,
  Value<int> orderIndex,
  Value<String?> parentId,
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
            Value<String?> parentId = const Value.absent(),
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
            Value<String?> parentId = const Value.absent(),
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
  Value<String?> hash,
  Value<String?> file_id,
});
typedef $$CacheTableTableUpdateCompanionBuilder = CacheTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> file,
  Value<int> size,
  Value<String> category,
  Value<String?> hash,
  Value<String?> file_id,
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

  ColumnFilters<String> get hash => $state.composableBuilder(
      column: $state.table.hash,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get file_id => $state.composableBuilder(
      column: $state.table.file_id,
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

  ColumnOrderings<String> get hash => $state.composableBuilder(
      column: $state.table.hash,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get file_id => $state.composableBuilder(
      column: $state.table.file_id,
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
            Value<String?> hash = const Value.absent(),
            Value<String?> file_id = const Value.absent(),
          }) =>
              CacheTableCompanion(
            id: id,
            url: url,
            file: file,
            size: size,
            category: category,
            hash: hash,
            file_id: file_id,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String url,
            required String file,
            required int size,
            required String category,
            Value<String?> hash = const Value.absent(),
            Value<String?> file_id = const Value.absent(),
          }) =>
              CacheTableCompanion.insert(
            id: id,
            url: url,
            file: file,
            size: size,
            category: category,
            hash: hash,
            file_id: file_id,
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
typedef $$UserTableTableCreateCompanionBuilder = UserTableCompanion Function({
  required String id,
  required String status,
  required String avatar,
  required String fullname,
  required String last,
  required String seen,
  Value<bool> verified,
  required Map<dynamic, dynamic> data,
  Value<int> rowid,
});
typedef $$UserTableTableUpdateCompanionBuilder = UserTableCompanion Function({
  Value<String> id,
  Value<String> status,
  Value<String> avatar,
  Value<String> fullname,
  Value<String> last,
  Value<String> seen,
  Value<bool> verified,
  Value<Map<dynamic, dynamic>> data,
  Value<int> rowid,
});

final class $$UserTableTableReferences
    extends BaseReferences<_$AppDatabase, $UserTableTable, UserTableData> {
  $$UserTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChatTableTable, List<ChatTableData>>
      _chatTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chatTable,
              aliasName:
                  $_aliasNameGenerator(db.userTable.id, db.chatTable.user_id));

  $$ChatTableTableProcessedTableManager get chatTableRefs {
    final manager = $$ChatTableTableTableManager($_db, $_db.chatTable)
        .filter((f) => f.user_id.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_chatTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UserTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get avatar => $state.composableBuilder(
      column: $state.table.avatar,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fullname => $state.composableBuilder(
      column: $state.table.fullname,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get last => $state.composableBuilder(
      column: $state.table.last,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get seen => $state.composableBuilder(
      column: $state.table.seen,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get verified => $state.composableBuilder(
      column: $state.table.verified,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Map<dynamic, dynamic>, Map<dynamic, dynamic>,
          String>
      get data => $state.composableBuilder(
          column: $state.table.data,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ComposableFilter chatTableRefs(
      ComposableFilter Function($$ChatTableTableFilterComposer f) f) {
    final $$ChatTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.chatTable,
        getReferencedColumn: (t) => t.user_id,
        builder: (joinBuilder, parentComposers) =>
            $$ChatTableTableFilterComposer(ComposerState(
                $state.db, $state.db.chatTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$UserTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get avatar => $state.composableBuilder(
      column: $state.table.avatar,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fullname => $state.composableBuilder(
      column: $state.table.fullname,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get last => $state.composableBuilder(
      column: $state.table.last,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get seen => $state.composableBuilder(
      column: $state.table.seen,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get verified => $state.composableBuilder(
      column: $state.table.verified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$UserTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (UserTableData, $$UserTableTableReferences),
    UserTableData,
    PrefetchHooks Function({bool chatTableRefs})> {
  $$UserTableTableTableManager(_$AppDatabase db, $UserTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UserTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UserTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> avatar = const Value.absent(),
            Value<String> fullname = const Value.absent(),
            Value<String> last = const Value.absent(),
            Value<String> seen = const Value.absent(),
            Value<bool> verified = const Value.absent(),
            Value<Map<dynamic, dynamic>> data = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTableCompanion(
            id: id,
            status: status,
            avatar: avatar,
            fullname: fullname,
            last: last,
            seen: seen,
            verified: verified,
            data: data,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String status,
            required String avatar,
            required String fullname,
            required String last,
            required String seen,
            Value<bool> verified = const Value.absent(),
            required Map<dynamic, dynamic> data,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserTableCompanion.insert(
            id: id,
            status: status,
            avatar: avatar,
            fullname: fullname,
            last: last,
            seen: seen,
            verified: verified,
            data: data,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({chatTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chatTableRefs) db.chatTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UserTableTableReferences._chatTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UserTableTableReferences(db, table, p0)
                                .chatTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.user_id == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UserTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (UserTableData, $$UserTableTableReferences),
    UserTableData,
    PrefetchHooks Function({bool chatTableRefs})>;
typedef $$ChatTableTableCreateCompanionBuilder = ChatTableCompanion Function({
  Value<int> id,
  required String chat_id,
  required String user_id,
  Value<Map<dynamic, dynamic>> message,
  required String permissions,
  Value<String> status,
  Value<int> unread_count,
  Value<DateTime> updated_at,
});
typedef $$ChatTableTableUpdateCompanionBuilder = ChatTableCompanion Function({
  Value<int> id,
  Value<String> chat_id,
  Value<String> user_id,
  Value<Map<dynamic, dynamic>> message,
  Value<String> permissions,
  Value<String> status,
  Value<int> unread_count,
  Value<DateTime> updated_at,
});

final class $$ChatTableTableReferences
    extends BaseReferences<_$AppDatabase, $ChatTableTable, ChatTableData> {
  $$ChatTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserTableTable _user_idTable(_$AppDatabase db) => db.userTable
      .createAlias($_aliasNameGenerator(db.chatTable.user_id, db.userTable.id));

  $$UserTableTableProcessedTableManager? get user_id {
    if ($_item.user_id == null) return null;
    final manager = $$UserTableTableTableManager($_db, $_db.userTable)
        .filter((f) => f.id($_item.user_id!));
    final item = $_typedResult.readTableOrNull(_user_idTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChatTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ChatTableTable> {
  $$ChatTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get chat_id => $state.composableBuilder(
      column: $state.table.chat_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Map<dynamic, dynamic>, Map<dynamic, dynamic>,
          String>
      get message => $state.composableBuilder(
          column: $state.table.message,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get permissions => $state.composableBuilder(
      column: $state.table.permissions,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get unread_count => $state.composableBuilder(
      column: $state.table.unread_count,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updated_at => $state.composableBuilder(
      column: $state.table.updated_at,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$UserTableTableFilterComposer get user_id {
    final $$UserTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user_id,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableFilterComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ChatTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ChatTableTable> {
  $$ChatTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get chat_id => $state.composableBuilder(
      column: $state.table.chat_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get message => $state.composableBuilder(
      column: $state.table.message,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get permissions => $state.composableBuilder(
      column: $state.table.permissions,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get unread_count => $state.composableBuilder(
      column: $state.table.unread_count,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updated_at => $state.composableBuilder(
      column: $state.table.updated_at,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$UserTableTableOrderingComposer get user_id {
    final $$UserTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user_id,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ChatTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatTableTable,
    ChatTableData,
    $$ChatTableTableFilterComposer,
    $$ChatTableTableOrderingComposer,
    $$ChatTableTableCreateCompanionBuilder,
    $$ChatTableTableUpdateCompanionBuilder,
    (ChatTableData, $$ChatTableTableReferences),
    ChatTableData,
    PrefetchHooks Function({bool user_id})> {
  $$ChatTableTableTableManager(_$AppDatabase db, $ChatTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ChatTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ChatTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> chat_id = const Value.absent(),
            Value<String> user_id = const Value.absent(),
            Value<Map<dynamic, dynamic>> message = const Value.absent(),
            Value<String> permissions = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> unread_count = const Value.absent(),
            Value<DateTime> updated_at = const Value.absent(),
          }) =>
              ChatTableCompanion(
            id: id,
            chat_id: chat_id,
            user_id: user_id,
            message: message,
            permissions: permissions,
            status: status,
            unread_count: unread_count,
            updated_at: updated_at,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String chat_id,
            required String user_id,
            Value<Map<dynamic, dynamic>> message = const Value.absent(),
            required String permissions,
            Value<String> status = const Value.absent(),
            Value<int> unread_count = const Value.absent(),
            Value<DateTime> updated_at = const Value.absent(),
          }) =>
              ChatTableCompanion.insert(
            id: id,
            chat_id: chat_id,
            user_id: user_id,
            message: message,
            permissions: permissions,
            status: status,
            unread_count: unread_count,
            updated_at: updated_at,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({user_id = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (user_id) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.user_id,
                    referencedTable:
                        $$ChatTableTableReferences._user_idTable(db),
                    referencedColumn:
                        $$ChatTableTableReferences._user_idTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChatTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatTableTable,
    ChatTableData,
    $$ChatTableTableFilterComposer,
    $$ChatTableTableOrderingComposer,
    $$ChatTableTableCreateCompanionBuilder,
    $$ChatTableTableUpdateCompanionBuilder,
    (ChatTableData, $$ChatTableTableReferences),
    ChatTableData,
    PrefetchHooks Function({bool user_id})>;
typedef $$MessageTableTableCreateCompanionBuilder = MessageTableCompanion
    Function({
  Value<int> id,
  Value<String?> message_id,
  Value<String?> local_id,
  required String chat_id,
  Value<String> status,
  required String sender_id,
  Value<DateTime> sent_at,
  required String type,
  required Map<dynamic, dynamic> data,
  required Map<dynamic, dynamic> meta,
  required Map<dynamic, dynamic> theme,
  Value<int> seq,
  Value<String?> reply_message_id,
  Value<String?> reaction,
});
typedef $$MessageTableTableUpdateCompanionBuilder = MessageTableCompanion
    Function({
  Value<int> id,
  Value<String?> message_id,
  Value<String?> local_id,
  Value<String> chat_id,
  Value<String> status,
  Value<String> sender_id,
  Value<DateTime> sent_at,
  Value<String> type,
  Value<Map<dynamic, dynamic>> data,
  Value<Map<dynamic, dynamic>> meta,
  Value<Map<dynamic, dynamic>> theme,
  Value<int> seq,
  Value<String?> reply_message_id,
  Value<String?> reaction,
});

class $$MessageTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MessageTableTable> {
  $$MessageTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get message_id => $state.composableBuilder(
      column: $state.table.message_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get local_id => $state.composableBuilder(
      column: $state.table.local_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get chat_id => $state.composableBuilder(
      column: $state.table.chat_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sender_id => $state.composableBuilder(
      column: $state.table.sender_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get sent_at => $state.composableBuilder(
      column: $state.table.sent_at,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Map<dynamic, dynamic>, Map<dynamic, dynamic>,
          String>
      get data => $state.composableBuilder(
          column: $state.table.data,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Map<dynamic, dynamic>, Map<dynamic, dynamic>,
          String>
      get meta => $state.composableBuilder(
          column: $state.table.meta,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Map<dynamic, dynamic>, Map<dynamic, dynamic>,
          String>
      get theme => $state.composableBuilder(
          column: $state.table.theme,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<int> get seq => $state.composableBuilder(
      column: $state.table.seq,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reply_message_id => $state.composableBuilder(
      column: $state.table.reply_message_id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reaction => $state.composableBuilder(
      column: $state.table.reaction,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$MessageTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MessageTableTable> {
  $$MessageTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get message_id => $state.composableBuilder(
      column: $state.table.message_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get local_id => $state.composableBuilder(
      column: $state.table.local_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get chat_id => $state.composableBuilder(
      column: $state.table.chat_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sender_id => $state.composableBuilder(
      column: $state.table.sender_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get sent_at => $state.composableBuilder(
      column: $state.table.sent_at,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get meta => $state.composableBuilder(
      column: $state.table.meta,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get theme => $state.composableBuilder(
      column: $state.table.theme,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get seq => $state.composableBuilder(
      column: $state.table.seq,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reply_message_id => $state.composableBuilder(
      column: $state.table.reply_message_id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reaction => $state.composableBuilder(
      column: $state.table.reaction,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$MessageTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessageTableTable,
    MessageTableData,
    $$MessageTableTableFilterComposer,
    $$MessageTableTableOrderingComposer,
    $$MessageTableTableCreateCompanionBuilder,
    $$MessageTableTableUpdateCompanionBuilder,
    (
      MessageTableData,
      BaseReferences<_$AppDatabase, $MessageTableTable, MessageTableData>
    ),
    MessageTableData,
    PrefetchHooks Function()> {
  $$MessageTableTableTableManager(_$AppDatabase db, $MessageTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MessageTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MessageTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> message_id = const Value.absent(),
            Value<String?> local_id = const Value.absent(),
            Value<String> chat_id = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> sender_id = const Value.absent(),
            Value<DateTime> sent_at = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<Map<dynamic, dynamic>> data = const Value.absent(),
            Value<Map<dynamic, dynamic>> meta = const Value.absent(),
            Value<Map<dynamic, dynamic>> theme = const Value.absent(),
            Value<int> seq = const Value.absent(),
            Value<String?> reply_message_id = const Value.absent(),
            Value<String?> reaction = const Value.absent(),
          }) =>
              MessageTableCompanion(
            id: id,
            message_id: message_id,
            local_id: local_id,
            chat_id: chat_id,
            status: status,
            sender_id: sender_id,
            sent_at: sent_at,
            type: type,
            data: data,
            meta: meta,
            theme: theme,
            seq: seq,
            reply_message_id: reply_message_id,
            reaction: reaction,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> message_id = const Value.absent(),
            Value<String?> local_id = const Value.absent(),
            required String chat_id,
            Value<String> status = const Value.absent(),
            required String sender_id,
            Value<DateTime> sent_at = const Value.absent(),
            required String type,
            required Map<dynamic, dynamic> data,
            required Map<dynamic, dynamic> meta,
            required Map<dynamic, dynamic> theme,
            Value<int> seq = const Value.absent(),
            Value<String?> reply_message_id = const Value.absent(),
            Value<String?> reaction = const Value.absent(),
          }) =>
              MessageTableCompanion.insert(
            id: id,
            message_id: message_id,
            local_id: local_id,
            chat_id: chat_id,
            status: status,
            sender_id: sender_id,
            sent_at: sent_at,
            type: type,
            data: data,
            meta: meta,
            theme: theme,
            seq: seq,
            reply_message_id: reply_message_id,
            reaction: reaction,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MessageTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessageTableTable,
    MessageTableData,
    $$MessageTableTableFilterComposer,
    $$MessageTableTableOrderingComposer,
    $$MessageTableTableCreateCompanionBuilder,
    $$MessageTableTableUpdateCompanionBuilder,
    (
      MessageTableData,
      BaseReferences<_$AppDatabase, $MessageTableTable, MessageTableData>
    ),
    MessageTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DropdownTableTableTableManager get dropdownTable =>
      $$DropdownTableTableTableManager(_db, _db.dropdownTable);
  $$CacheTableTableTableManager get cacheTable =>
      $$CacheTableTableTableManager(_db, _db.cacheTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$ChatTableTableTableManager get chatTable =>
      $$ChatTableTableTableManager(_db, _db.chatTable);
  $$MessageTableTableTableManager get messageTable =>
      $$MessageTableTableTableManager(_db, _db.messageTable);
}
