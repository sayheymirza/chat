class ProfileSearchModel {
  late int? id;
  late String? seen;
  late String? avatar;
  late String? fullname;
  late String? city;
  late bool? ad;
  late bool? special;
  late bool? verified;
  late int? age;

  ProfileSearchModel({
    this.id,
    this.seen,
    this.avatar,
    this.fullname,
    this.city,
    this.ad,
    this.special,
    this.verified,
    this.age,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seen'] = seen;
    data['avatar'] = avatar;
    data['fullname'] = fullname;
    data['city'] = city;
    data['ad'] = ad;
    data['special'] = special;
    data['verified'] = verified;
    data['age'] = age;
    return data;
  }
}

class ProfileModel {
  late int? id;
  late String? status;
  late String? avatar;
  late bool? defaultAvatar;
  late String? fullname;
  late String? last;
  late String? seen;
  late String? ago;
  late int? age;
  late String? phone;
  late bool? verified;
  late String? birthDate;
  late String? registerDate;
  late String? education;
  late String? religion;
  late String? marriageType;
  late String? gender;
  late String? marital;
  late String? color;
  late String? beauty;
  late String? shape;
  late String? health;
  late String? salary;
  late String? car;
  late String? house;
  late String? living;
  late String? province;
  late String? city;
  late String? children;
  late String? childMaxAge;
  late String? height;
  late String? weight;
  late String? job;
  late String? about;
  late Plan? plan;
  late Permission? permission;
  late Relation? relation;
  late Map<String, dynamic>? dropdowns;

  ProfileModel({
    this.id,
    this.status,
    this.avatar,
    this.defaultAvatar,
    this.fullname,
    this.last,
    this.seen,
    this.ago,
    this.age,
    this.phone,
    this.verified,
    this.birthDate,
    this.registerDate,
    this.education,
    this.religion,
    this.marriageType,
    this.gender,
    this.marital,
    this.color,
    this.beauty,
    this.shape,
    this.health,
    this.salary,
    this.car,
    this.house,
    this.living,
    this.province,
    this.city,
    this.children,
    this.childMaxAge,
    this.height,
    this.weight,
    this.job,
    this.about,
    this.plan,
    this.permission,
    this.relation,
    this.dropdowns,
  });

  copyWith(Map<String, dynamic> value) {
    return ProfileModel(
      id: value['id'] ?? id,
      status: value['status'] ?? status,
      avatar: value['avatar'] ?? avatar,
      defaultAvatar: value['defaultAvatar'] ?? defaultAvatar,
      fullname: value['fullname'] ?? fullname,
      last: value['last'] ?? last,
      seen: value['seen'] ?? seen,
      ago: value['ago'] ?? ago,
      age: value['age'] ?? age,
      phone: value['phone'] ?? phone,
      verified: value['verified'] ?? verified,
      birthDate: value['birthDate'] ?? birthDate,
      registerDate: value['registerDate'] ?? registerDate,
      education: value['education'] ?? education,
      religion: value['religion'] ?? religion,
      marriageType: value['marriageType'] ?? marriageType,
      gender: value['gender'] ?? gender,
      marital: value['marital'] ?? marital,
      color: value['color'] ?? color,
      beauty: value['beauty'] ?? beauty,
      shape: value['shape'] ?? shape,
      health: value['health'] ?? health,
      salary: value['salary'] ?? salary,
      car: value['car'] ?? car,
      house: value['house'] ?? house,
      living: value['living'] ?? living,
      province: value['province'] ?? province,
      city: value['city'] ?? city,
      children: value['children'] ?? children,
      childMaxAge: value['childMaxAge'] ?? childMaxAge,
      height: value['height'] ?? height,
      weight: value['weight'] ?? weight,
      job: value['job'] ?? job,
      about: value['about'] ?? about,
      plan: value['plan'] != null ? Plan.fromJson(value['plan']) : plan,
      permission: value['permission'] != null
          ? Permission.fromJson(value['permission'])
          : permission,
      relation: value['relation'] != null
          ? Relation.fromJson(value['relation'])
          : relation,
      dropdowns: value['dropdowns'] ?? dropdowns,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['avatar'] = avatar;
    data['fullname'] = fullname;
    data['last'] = last;
    data['seen'] = seen;
    data['ago'] = ago;
    data['age'] = age;
    data['phone'] = phone;
    data['verified'] = verified;
    data['birthDate'] = birthDate;
    data['registerDate'] = registerDate;
    data['education'] = education;
    data['religion'] = religion;
    data['marriageType'] = marriageType;
    data['gender'] = gender;
    data['marital'] = marital;
    data['color'] = color;
    data['beauty'] = beauty;
    data['shape'] = shape;
    data['health'] = health;
    data['salary'] = salary;
    data['car'] = car;
    data['house'] = house;
    data['living'] = living;
    data['province'] = province;
    data['city'] = city;
    data['children'] = children;
    data['childMaxAge'] = childMaxAge;
    data['height'] = height;
    data['weight'] = weight;
    data['job'] = job;
    data['about'] = about;
    data['plan'] = plan?.toJson();
    data['permission'] = permission?.toJson();
    data['relation'] = relation?.toJson();
    return data;
  }
}

class Plan {
  bool? free;
  bool? special;
  bool? ad;
  int? sms;
  int? specialDays;
  int? adDays;
  int? freeHours;
  int? freeMinutes;

  Plan({
    this.free = false,
    this.special = false,
    this.ad = false,
    this.sms = 0,
    this.specialDays = 0,
    this.adDays = 0,
    this.freeHours = 0,
    this.freeMinutes = 0,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      free: json['free'],
      special: json['special'],
      ad: json['ad'],
      sms: json['sms'],
      specialDays: json['specialDays'],
      adDays: json['adDays'],
      freeHours: json['freeHours'],
      freeMinutes: json['freeMinutes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['free'] = free;
    data['special'] = special;
    data['ad'] = ad;
    data['sms'] = sms;
    data['specialDays'] = specialDays;
    data['adDays'] = adDays;
    data['freeHours'] = freeHours;
    data['freeMinutes'] = freeMinutes;
    return data;
  }
}

class Permission {
  bool? voiceCall;
  bool? videoCall;
  bool? notificationReaction;
  bool? notificationChat;
  bool? notificationVoiceCall;
  bool? notificationVideoCall;

  Permission({
    required this.voiceCall,
    required this.videoCall,
    required this.notificationReaction,
    required this.notificationChat,
    required this.notificationVoiceCall,
    required this.notificationVideoCall,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      voiceCall: json['voiceCall'],
      videoCall: json['videoCall'],
      notificationReaction: json['notificationReaction'],
      notificationChat: json['notificationChat'],
      notificationVoiceCall: json['notificationVoiceCall'],
      notificationVideoCall: json['notificationVideoCall'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voiceCall'] = voiceCall;
    data['videoCall'] = videoCall;
    data['notificationReaction'] = notificationReaction;
    data['notificationChat'] = notificationChat;
    data['notificationVoiceCall'] = notificationVoiceCall;
    data['notificationVideoCall'] = notificationVideoCall;
    return data;
  }
}

class Relation {
  bool? blocked;
  bool? blockedMe;
  bool? favorited;

  Relation({
    required this.blocked,
    required this.blockedMe,
    required this.favorited,
  });

  factory Relation.fromJson(Map<String, dynamic> json) {
    return Relation(
      blocked: json['blocked'],
      blockedMe: json['blockedMe'],
      favorited: json['favorited'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blocked'] = blocked;
    data['blockedMe'] = blockedMe;
    data['favorited'] = favorited;
    return data;
  }
}

enum ProfileReactions { BLOCK, UNBLOCK, FAVORITE, DISFAVORITE }
