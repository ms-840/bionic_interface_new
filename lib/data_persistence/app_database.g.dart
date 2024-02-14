// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserDataEntityTable extends UserDataEntity
    with TableInfo<$UserDataEntityTable, UserDataEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserDataEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userNameMeta =
      const VerificationMeta('userName');
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
      'user_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accessTypeMeta =
      const VerificationMeta('accessType');
  @override
  late final GeneratedColumn<String> accessType = GeneratedColumn<String>(
      'accessType', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _combinedActionsMeta =
      const VerificationMeta('combinedActions');
  @override
  late final GeneratedColumn<String> combinedActions = GeneratedColumn<String>(
      'combined_actions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _opposedActionsMeta =
      const VerificationMeta('opposedActions');
  @override
  late final GeneratedColumn<String> opposedActions = GeneratedColumn<String>(
      'opposed_actions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unopposedActionsMeta =
      const VerificationMeta('unopposedActions');
  @override
  late final GeneratedColumn<String> unopposedActions = GeneratedColumn<String>(
      'unopposed_actions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _directActionsMeta =
      const VerificationMeta('directActions');
  @override
  late final GeneratedColumn<String> directActions = GeneratedColumn<String>(
      'direct_actions', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _switchInputsMeta =
      const VerificationMeta('switchInputs');
  @override
  late final GeneratedColumn<bool> switchInputs = GeneratedColumn<bool>(
      'switch_inputs', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("switch_inputs" IN (0, 1))'));
  static const VerificationMeta _useTwoSignalsMeta =
      const VerificationMeta('useTwoSignals');
  @override
  late final GeneratedColumn<bool> useTwoSignals = GeneratedColumn<bool>(
      'use_two_signals', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("use_two_signals" IN (0, 1))'));
  static const VerificationMeta _inputGainAMeta =
      const VerificationMeta('inputGainA');
  @override
  late final GeneratedColumn<double> inputGainA = GeneratedColumn<double>(
      'input_gain_a', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _inputGainBMeta =
      const VerificationMeta('inputGainB');
  @override
  late final GeneratedColumn<double> inputGainB = GeneratedColumn<double>(
      'input_gain_b', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _useThumbTriggerMeta =
      const VerificationMeta('useThumbTrigger');
  @override
  late final GeneratedColumn<bool> useThumbTrigger = GeneratedColumn<bool>(
      'use_thumb_trigger', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("use_thumb_trigger" IN (0, 1))'));
  static const VerificationMeta _timeOpenOpenMeta =
      const VerificationMeta('timeOpenOpen');
  @override
  late final GeneratedColumn<double> timeOpenOpen = GeneratedColumn<double>(
      'time_open_open', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timeHoldOpenMeta =
      const VerificationMeta('timeHoldOpen');
  @override
  late final GeneratedColumn<double> timeHoldOpen = GeneratedColumn<double>(
      'time_hold_open', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timeCoConMeta =
      const VerificationMeta('timeCoCon');
  @override
  late final GeneratedColumn<double> timeCoCon = GeneratedColumn<double>(
      'time_co_con', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _alternateMeta =
      const VerificationMeta('alternate');
  @override
  late final GeneratedColumn<bool> alternate = GeneratedColumn<bool>(
      'alternate', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("alternate" IN (0, 1))'));
  static const VerificationMeta _timeAltSwitchMeta =
      const VerificationMeta('timeAltSwitch');
  @override
  late final GeneratedColumn<double> timeAltSwitch = GeneratedColumn<double>(
      'time_alt_switch', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timeFastCloseMeta =
      const VerificationMeta('timeFastClose');
  @override
  late final GeneratedColumn<double> timeFastClose = GeneratedColumn<double>(
      'time_fast_close', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _levelFastCloseMeta =
      const VerificationMeta('levelFastClose');
  @override
  late final GeneratedColumn<double> levelFastClose = GeneratedColumn<double>(
      'level_fast_close', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _vibrateMeta =
      const VerificationMeta('vibrate');
  @override
  late final GeneratedColumn<bool> vibrate = GeneratedColumn<bool>(
      'vibrate', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("vibrate" IN (0, 1))'));
  static const VerificationMeta _buzzerMeta = const VerificationMeta('buzzer');
  @override
  late final GeneratedColumn<bool> buzzer = GeneratedColumn<bool>(
      'buzzer', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("buzzer" IN (0, 1))'));
  static const VerificationMeta _signalAonMeta =
      const VerificationMeta('signalAon');
  @override
  late final GeneratedColumn<double> signalAon = GeneratedColumn<double>(
      'signal_a_on', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _signalAmaxMeta =
      const VerificationMeta('signalAmax');
  @override
  late final GeneratedColumn<double> signalAmax = GeneratedColumn<double>(
      'signal_a_max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _signalBonMeta =
      const VerificationMeta('signalBon');
  @override
  late final GeneratedColumn<double> signalBon = GeneratedColumn<double>(
      'signal_b_on', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _signalBmaxMeta =
      const VerificationMeta('signalBmax');
  @override
  late final GeneratedColumn<double> signalBmax = GeneratedColumn<double>(
      'signal_b_max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _signalAgainMeta =
      const VerificationMeta('signalAgain');
  @override
  late final GeneratedColumn<double> signalAgain = GeneratedColumn<double>(
      'signal_a_gain', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _signalBgainMeta =
      const VerificationMeta('signalBgain');
  @override
  late final GeneratedColumn<double> signalBgain = GeneratedColumn<double>(
      'signal_b_gain', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userName,
        name,
        password,
        email,
        accessType,
        combinedActions,
        opposedActions,
        unopposedActions,
        directActions,
        switchInputs,
        useTwoSignals,
        inputGainA,
        inputGainB,
        useThumbTrigger,
        timeOpenOpen,
        timeHoldOpen,
        timeCoCon,
        alternate,
        timeAltSwitch,
        timeFastClose,
        levelFastClose,
        vibrate,
        buzzer,
        signalAon,
        signalAmax,
        signalBon,
        signalBmax,
        signalAgain,
        signalBgain
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_data_entity';
  @override
  VerificationContext validateIntegrity(Insertable<UserDataEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('accessType')) {
      context.handle(
          _accessTypeMeta,
          accessType.isAcceptableOrUnknown(
              data['accessType']!, _accessTypeMeta));
    } else if (isInserting) {
      context.missing(_accessTypeMeta);
    }
    if (data.containsKey('combined_actions')) {
      context.handle(
          _combinedActionsMeta,
          combinedActions.isAcceptableOrUnknown(
              data['combined_actions']!, _combinedActionsMeta));
    } else if (isInserting) {
      context.missing(_combinedActionsMeta);
    }
    if (data.containsKey('opposed_actions')) {
      context.handle(
          _opposedActionsMeta,
          opposedActions.isAcceptableOrUnknown(
              data['opposed_actions']!, _opposedActionsMeta));
    } else if (isInserting) {
      context.missing(_opposedActionsMeta);
    }
    if (data.containsKey('unopposed_actions')) {
      context.handle(
          _unopposedActionsMeta,
          unopposedActions.isAcceptableOrUnknown(
              data['unopposed_actions']!, _unopposedActionsMeta));
    } else if (isInserting) {
      context.missing(_unopposedActionsMeta);
    }
    if (data.containsKey('direct_actions')) {
      context.handle(
          _directActionsMeta,
          directActions.isAcceptableOrUnknown(
              data['direct_actions']!, _directActionsMeta));
    } else if (isInserting) {
      context.missing(_directActionsMeta);
    }
    if (data.containsKey('switch_inputs')) {
      context.handle(
          _switchInputsMeta,
          switchInputs.isAcceptableOrUnknown(
              data['switch_inputs']!, _switchInputsMeta));
    } else if (isInserting) {
      context.missing(_switchInputsMeta);
    }
    if (data.containsKey('use_two_signals')) {
      context.handle(
          _useTwoSignalsMeta,
          useTwoSignals.isAcceptableOrUnknown(
              data['use_two_signals']!, _useTwoSignalsMeta));
    } else if (isInserting) {
      context.missing(_useTwoSignalsMeta);
    }
    if (data.containsKey('input_gain_a')) {
      context.handle(
          _inputGainAMeta,
          inputGainA.isAcceptableOrUnknown(
              data['input_gain_a']!, _inputGainAMeta));
    } else if (isInserting) {
      context.missing(_inputGainAMeta);
    }
    if (data.containsKey('input_gain_b')) {
      context.handle(
          _inputGainBMeta,
          inputGainB.isAcceptableOrUnknown(
              data['input_gain_b']!, _inputGainBMeta));
    } else if (isInserting) {
      context.missing(_inputGainBMeta);
    }
    if (data.containsKey('use_thumb_trigger')) {
      context.handle(
          _useThumbTriggerMeta,
          useThumbTrigger.isAcceptableOrUnknown(
              data['use_thumb_trigger']!, _useThumbTriggerMeta));
    } else if (isInserting) {
      context.missing(_useThumbTriggerMeta);
    }
    if (data.containsKey('time_open_open')) {
      context.handle(
          _timeOpenOpenMeta,
          timeOpenOpen.isAcceptableOrUnknown(
              data['time_open_open']!, _timeOpenOpenMeta));
    } else if (isInserting) {
      context.missing(_timeOpenOpenMeta);
    }
    if (data.containsKey('time_hold_open')) {
      context.handle(
          _timeHoldOpenMeta,
          timeHoldOpen.isAcceptableOrUnknown(
              data['time_hold_open']!, _timeHoldOpenMeta));
    } else if (isInserting) {
      context.missing(_timeHoldOpenMeta);
    }
    if (data.containsKey('time_co_con')) {
      context.handle(
          _timeCoConMeta,
          timeCoCon.isAcceptableOrUnknown(
              data['time_co_con']!, _timeCoConMeta));
    } else if (isInserting) {
      context.missing(_timeCoConMeta);
    }
    if (data.containsKey('alternate')) {
      context.handle(_alternateMeta,
          alternate.isAcceptableOrUnknown(data['alternate']!, _alternateMeta));
    } else if (isInserting) {
      context.missing(_alternateMeta);
    }
    if (data.containsKey('time_alt_switch')) {
      context.handle(
          _timeAltSwitchMeta,
          timeAltSwitch.isAcceptableOrUnknown(
              data['time_alt_switch']!, _timeAltSwitchMeta));
    } else if (isInserting) {
      context.missing(_timeAltSwitchMeta);
    }
    if (data.containsKey('time_fast_close')) {
      context.handle(
          _timeFastCloseMeta,
          timeFastClose.isAcceptableOrUnknown(
              data['time_fast_close']!, _timeFastCloseMeta));
    } else if (isInserting) {
      context.missing(_timeFastCloseMeta);
    }
    if (data.containsKey('level_fast_close')) {
      context.handle(
          _levelFastCloseMeta,
          levelFastClose.isAcceptableOrUnknown(
              data['level_fast_close']!, _levelFastCloseMeta));
    } else if (isInserting) {
      context.missing(_levelFastCloseMeta);
    }
    if (data.containsKey('vibrate')) {
      context.handle(_vibrateMeta,
          vibrate.isAcceptableOrUnknown(data['vibrate']!, _vibrateMeta));
    } else if (isInserting) {
      context.missing(_vibrateMeta);
    }
    if (data.containsKey('buzzer')) {
      context.handle(_buzzerMeta,
          buzzer.isAcceptableOrUnknown(data['buzzer']!, _buzzerMeta));
    } else if (isInserting) {
      context.missing(_buzzerMeta);
    }
    if (data.containsKey('signal_a_on')) {
      context.handle(
          _signalAonMeta,
          signalAon.isAcceptableOrUnknown(
              data['signal_a_on']!, _signalAonMeta));
    } else if (isInserting) {
      context.missing(_signalAonMeta);
    }
    if (data.containsKey('signal_a_max')) {
      context.handle(
          _signalAmaxMeta,
          signalAmax.isAcceptableOrUnknown(
              data['signal_a_max']!, _signalAmaxMeta));
    } else if (isInserting) {
      context.missing(_signalAmaxMeta);
    }
    if (data.containsKey('signal_b_on')) {
      context.handle(
          _signalBonMeta,
          signalBon.isAcceptableOrUnknown(
              data['signal_b_on']!, _signalBonMeta));
    } else if (isInserting) {
      context.missing(_signalBonMeta);
    }
    if (data.containsKey('signal_b_max')) {
      context.handle(
          _signalBmaxMeta,
          signalBmax.isAcceptableOrUnknown(
              data['signal_b_max']!, _signalBmaxMeta));
    } else if (isInserting) {
      context.missing(_signalBmaxMeta);
    }
    if (data.containsKey('signal_a_gain')) {
      context.handle(
          _signalAgainMeta,
          signalAgain.isAcceptableOrUnknown(
              data['signal_a_gain']!, _signalAgainMeta));
    } else if (isInserting) {
      context.missing(_signalAgainMeta);
    }
    if (data.containsKey('signal_b_gain')) {
      context.handle(
          _signalBgainMeta,
          signalBgain.isAcceptableOrUnknown(
              data['signal_b_gain']!, _signalBgainMeta));
    } else if (isInserting) {
      context.missing(_signalBgainMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserDataEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserDataEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      accessType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}accessType'])!,
      combinedActions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}combined_actions'])!,
      opposedActions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}opposed_actions'])!,
      unopposedActions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unopposed_actions'])!,
      directActions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direct_actions'])!,
      switchInputs: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}switch_inputs'])!,
      useTwoSignals: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}use_two_signals'])!,
      inputGainA: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}input_gain_a'])!,
      inputGainB: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}input_gain_b'])!,
      useThumbTrigger: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}use_thumb_trigger'])!,
      timeOpenOpen: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}time_open_open'])!,
      timeHoldOpen: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}time_hold_open'])!,
      timeCoCon: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}time_co_con'])!,
      alternate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}alternate'])!,
      timeAltSwitch: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}time_alt_switch'])!,
      timeFastClose: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}time_fast_close'])!,
      levelFastClose: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}level_fast_close'])!,
      vibrate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}vibrate'])!,
      buzzer: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}buzzer'])!,
      signalAon: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}signal_a_on'])!,
      signalAmax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}signal_a_max'])!,
      signalBon: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}signal_b_on'])!,
      signalBmax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}signal_b_max'])!,
      signalAgain: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}signal_a_gain'])!,
      signalBgain: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}signal_b_gain'])!,
    );
  }

  @override
  $UserDataEntityTable createAlias(String alias) {
    return $UserDataEntityTable(attachedDatabase, alias);
  }
}

class UserDataEntityData extends DataClass
    implements Insertable<UserDataEntityData> {
  final int id;
  final String userName;
  final String name;
  final String password;
  final String email;
  final String accessType;
  final String combinedActions;
  final String opposedActions;
  final String unopposedActions;
  final String directActions;
  final bool switchInputs;
  final bool useTwoSignals;
  final double inputGainA;
  final double inputGainB;
  final bool useThumbTrigger;
  final double timeOpenOpen;
  final double timeHoldOpen;
  final double timeCoCon;
  final bool alternate;
  final double timeAltSwitch;
  final double timeFastClose;
  final double levelFastClose;
  final bool vibrate;
  final bool buzzer;
  final double signalAon;
  final double signalAmax;
  final double signalBon;
  final double signalBmax;
  final double signalAgain;
  final double signalBgain;
  const UserDataEntityData(
      {required this.id,
      required this.userName,
      required this.name,
      required this.password,
      required this.email,
      required this.accessType,
      required this.combinedActions,
      required this.opposedActions,
      required this.unopposedActions,
      required this.directActions,
      required this.switchInputs,
      required this.useTwoSignals,
      required this.inputGainA,
      required this.inputGainB,
      required this.useThumbTrigger,
      required this.timeOpenOpen,
      required this.timeHoldOpen,
      required this.timeCoCon,
      required this.alternate,
      required this.timeAltSwitch,
      required this.timeFastClose,
      required this.levelFastClose,
      required this.vibrate,
      required this.buzzer,
      required this.signalAon,
      required this.signalAmax,
      required this.signalBon,
      required this.signalBmax,
      required this.signalAgain,
      required this.signalBgain});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    map['name'] = Variable<String>(name);
    map['password'] = Variable<String>(password);
    map['email'] = Variable<String>(email);
    map['accessType'] = Variable<String>(accessType);
    map['combined_actions'] = Variable<String>(combinedActions);
    map['opposed_actions'] = Variable<String>(opposedActions);
    map['unopposed_actions'] = Variable<String>(unopposedActions);
    map['direct_actions'] = Variable<String>(directActions);
    map['switch_inputs'] = Variable<bool>(switchInputs);
    map['use_two_signals'] = Variable<bool>(useTwoSignals);
    map['input_gain_a'] = Variable<double>(inputGainA);
    map['input_gain_b'] = Variable<double>(inputGainB);
    map['use_thumb_trigger'] = Variable<bool>(useThumbTrigger);
    map['time_open_open'] = Variable<double>(timeOpenOpen);
    map['time_hold_open'] = Variable<double>(timeHoldOpen);
    map['time_co_con'] = Variable<double>(timeCoCon);
    map['alternate'] = Variable<bool>(alternate);
    map['time_alt_switch'] = Variable<double>(timeAltSwitch);
    map['time_fast_close'] = Variable<double>(timeFastClose);
    map['level_fast_close'] = Variable<double>(levelFastClose);
    map['vibrate'] = Variable<bool>(vibrate);
    map['buzzer'] = Variable<bool>(buzzer);
    map['signal_a_on'] = Variable<double>(signalAon);
    map['signal_a_max'] = Variable<double>(signalAmax);
    map['signal_b_on'] = Variable<double>(signalBon);
    map['signal_b_max'] = Variable<double>(signalBmax);
    map['signal_a_gain'] = Variable<double>(signalAgain);
    map['signal_b_gain'] = Variable<double>(signalBgain);
    return map;
  }

  UserDataEntityCompanion toCompanion(bool nullToAbsent) {
    return UserDataEntityCompanion(
      id: Value(id),
      userName: Value(userName),
      name: Value(name),
      password: Value(password),
      email: Value(email),
      accessType: Value(accessType),
      combinedActions: Value(combinedActions),
      opposedActions: Value(opposedActions),
      unopposedActions: Value(unopposedActions),
      directActions: Value(directActions),
      switchInputs: Value(switchInputs),
      useTwoSignals: Value(useTwoSignals),
      inputGainA: Value(inputGainA),
      inputGainB: Value(inputGainB),
      useThumbTrigger: Value(useThumbTrigger),
      timeOpenOpen: Value(timeOpenOpen),
      timeHoldOpen: Value(timeHoldOpen),
      timeCoCon: Value(timeCoCon),
      alternate: Value(alternate),
      timeAltSwitch: Value(timeAltSwitch),
      timeFastClose: Value(timeFastClose),
      levelFastClose: Value(levelFastClose),
      vibrate: Value(vibrate),
      buzzer: Value(buzzer),
      signalAon: Value(signalAon),
      signalAmax: Value(signalAmax),
      signalBon: Value(signalBon),
      signalBmax: Value(signalBmax),
      signalAgain: Value(signalAgain),
      signalBgain: Value(signalBgain),
    );
  }

  factory UserDataEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserDataEntityData(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      name: serializer.fromJson<String>(json['name']),
      password: serializer.fromJson<String>(json['password']),
      email: serializer.fromJson<String>(json['email']),
      accessType: serializer.fromJson<String>(json['accessType']),
      combinedActions: serializer.fromJson<String>(json['combinedActions']),
      opposedActions: serializer.fromJson<String>(json['opposedActions']),
      unopposedActions: serializer.fromJson<String>(json['unopposedActions']),
      directActions: serializer.fromJson<String>(json['directActions']),
      switchInputs: serializer.fromJson<bool>(json['switchInputs']),
      useTwoSignals: serializer.fromJson<bool>(json['useTwoSignals']),
      inputGainA: serializer.fromJson<double>(json['inputGainA']),
      inputGainB: serializer.fromJson<double>(json['inputGainB']),
      useThumbTrigger: serializer.fromJson<bool>(json['useThumbTrigger']),
      timeOpenOpen: serializer.fromJson<double>(json['timeOpenOpen']),
      timeHoldOpen: serializer.fromJson<double>(json['timeHoldOpen']),
      timeCoCon: serializer.fromJson<double>(json['timeCoCon']),
      alternate: serializer.fromJson<bool>(json['alternate']),
      timeAltSwitch: serializer.fromJson<double>(json['timeAltSwitch']),
      timeFastClose: serializer.fromJson<double>(json['timeFastClose']),
      levelFastClose: serializer.fromJson<double>(json['levelFastClose']),
      vibrate: serializer.fromJson<bool>(json['vibrate']),
      buzzer: serializer.fromJson<bool>(json['buzzer']),
      signalAon: serializer.fromJson<double>(json['signalAon']),
      signalAmax: serializer.fromJson<double>(json['signalAmax']),
      signalBon: serializer.fromJson<double>(json['signalBon']),
      signalBmax: serializer.fromJson<double>(json['signalBmax']),
      signalAgain: serializer.fromJson<double>(json['signalAgain']),
      signalBgain: serializer.fromJson<double>(json['signalBgain']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'name': serializer.toJson<String>(name),
      'password': serializer.toJson<String>(password),
      'email': serializer.toJson<String>(email),
      'accessType': serializer.toJson<String>(accessType),
      'combinedActions': serializer.toJson<String>(combinedActions),
      'opposedActions': serializer.toJson<String>(opposedActions),
      'unopposedActions': serializer.toJson<String>(unopposedActions),
      'directActions': serializer.toJson<String>(directActions),
      'switchInputs': serializer.toJson<bool>(switchInputs),
      'useTwoSignals': serializer.toJson<bool>(useTwoSignals),
      'inputGainA': serializer.toJson<double>(inputGainA),
      'inputGainB': serializer.toJson<double>(inputGainB),
      'useThumbTrigger': serializer.toJson<bool>(useThumbTrigger),
      'timeOpenOpen': serializer.toJson<double>(timeOpenOpen),
      'timeHoldOpen': serializer.toJson<double>(timeHoldOpen),
      'timeCoCon': serializer.toJson<double>(timeCoCon),
      'alternate': serializer.toJson<bool>(alternate),
      'timeAltSwitch': serializer.toJson<double>(timeAltSwitch),
      'timeFastClose': serializer.toJson<double>(timeFastClose),
      'levelFastClose': serializer.toJson<double>(levelFastClose),
      'vibrate': serializer.toJson<bool>(vibrate),
      'buzzer': serializer.toJson<bool>(buzzer),
      'signalAon': serializer.toJson<double>(signalAon),
      'signalAmax': serializer.toJson<double>(signalAmax),
      'signalBon': serializer.toJson<double>(signalBon),
      'signalBmax': serializer.toJson<double>(signalBmax),
      'signalAgain': serializer.toJson<double>(signalAgain),
      'signalBgain': serializer.toJson<double>(signalBgain),
    };
  }

  UserDataEntityData copyWith(
          {int? id,
          String? userName,
          String? name,
          String? password,
          String? email,
          String? accessType,
          String? combinedActions,
          String? opposedActions,
          String? unopposedActions,
          String? directActions,
          bool? switchInputs,
          bool? useTwoSignals,
          double? inputGainA,
          double? inputGainB,
          bool? useThumbTrigger,
          double? timeOpenOpen,
          double? timeHoldOpen,
          double? timeCoCon,
          bool? alternate,
          double? timeAltSwitch,
          double? timeFastClose,
          double? levelFastClose,
          bool? vibrate,
          bool? buzzer,
          double? signalAon,
          double? signalAmax,
          double? signalBon,
          double? signalBmax,
          double? signalAgain,
          double? signalBgain}) =>
      UserDataEntityData(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        name: name ?? this.name,
        password: password ?? this.password,
        email: email ?? this.email,
        accessType: accessType ?? this.accessType,
        combinedActions: combinedActions ?? this.combinedActions,
        opposedActions: opposedActions ?? this.opposedActions,
        unopposedActions: unopposedActions ?? this.unopposedActions,
        directActions: directActions ?? this.directActions,
        switchInputs: switchInputs ?? this.switchInputs,
        useTwoSignals: useTwoSignals ?? this.useTwoSignals,
        inputGainA: inputGainA ?? this.inputGainA,
        inputGainB: inputGainB ?? this.inputGainB,
        useThumbTrigger: useThumbTrigger ?? this.useThumbTrigger,
        timeOpenOpen: timeOpenOpen ?? this.timeOpenOpen,
        timeHoldOpen: timeHoldOpen ?? this.timeHoldOpen,
        timeCoCon: timeCoCon ?? this.timeCoCon,
        alternate: alternate ?? this.alternate,
        timeAltSwitch: timeAltSwitch ?? this.timeAltSwitch,
        timeFastClose: timeFastClose ?? this.timeFastClose,
        levelFastClose: levelFastClose ?? this.levelFastClose,
        vibrate: vibrate ?? this.vibrate,
        buzzer: buzzer ?? this.buzzer,
        signalAon: signalAon ?? this.signalAon,
        signalAmax: signalAmax ?? this.signalAmax,
        signalBon: signalBon ?? this.signalBon,
        signalBmax: signalBmax ?? this.signalBmax,
        signalAgain: signalAgain ?? this.signalAgain,
        signalBgain: signalBgain ?? this.signalBgain,
      );
  @override
  String toString() {
    return (StringBuffer('UserDataEntityData(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('email: $email, ')
          ..write('accessType: $accessType, ')
          ..write('combinedActions: $combinedActions, ')
          ..write('opposedActions: $opposedActions, ')
          ..write('unopposedActions: $unopposedActions, ')
          ..write('directActions: $directActions, ')
          ..write('switchInputs: $switchInputs, ')
          ..write('useTwoSignals: $useTwoSignals, ')
          ..write('inputGainA: $inputGainA, ')
          ..write('inputGainB: $inputGainB, ')
          ..write('useThumbTrigger: $useThumbTrigger, ')
          ..write('timeOpenOpen: $timeOpenOpen, ')
          ..write('timeHoldOpen: $timeHoldOpen, ')
          ..write('timeCoCon: $timeCoCon, ')
          ..write('alternate: $alternate, ')
          ..write('timeAltSwitch: $timeAltSwitch, ')
          ..write('timeFastClose: $timeFastClose, ')
          ..write('levelFastClose: $levelFastClose, ')
          ..write('vibrate: $vibrate, ')
          ..write('buzzer: $buzzer, ')
          ..write('signalAon: $signalAon, ')
          ..write('signalAmax: $signalAmax, ')
          ..write('signalBon: $signalBon, ')
          ..write('signalBmax: $signalBmax, ')
          ..write('signalAgain: $signalAgain, ')
          ..write('signalBgain: $signalBgain')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userName,
        name,
        password,
        email,
        accessType,
        combinedActions,
        opposedActions,
        unopposedActions,
        directActions,
        switchInputs,
        useTwoSignals,
        inputGainA,
        inputGainB,
        useThumbTrigger,
        timeOpenOpen,
        timeHoldOpen,
        timeCoCon,
        alternate,
        timeAltSwitch,
        timeFastClose,
        levelFastClose,
        vibrate,
        buzzer,
        signalAon,
        signalAmax,
        signalBon,
        signalBmax,
        signalAgain,
        signalBgain
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserDataEntityData &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.name == this.name &&
          other.password == this.password &&
          other.email == this.email &&
          other.accessType == this.accessType &&
          other.combinedActions == this.combinedActions &&
          other.opposedActions == this.opposedActions &&
          other.unopposedActions == this.unopposedActions &&
          other.directActions == this.directActions &&
          other.switchInputs == this.switchInputs &&
          other.useTwoSignals == this.useTwoSignals &&
          other.inputGainA == this.inputGainA &&
          other.inputGainB == this.inputGainB &&
          other.useThumbTrigger == this.useThumbTrigger &&
          other.timeOpenOpen == this.timeOpenOpen &&
          other.timeHoldOpen == this.timeHoldOpen &&
          other.timeCoCon == this.timeCoCon &&
          other.alternate == this.alternate &&
          other.timeAltSwitch == this.timeAltSwitch &&
          other.timeFastClose == this.timeFastClose &&
          other.levelFastClose == this.levelFastClose &&
          other.vibrate == this.vibrate &&
          other.buzzer == this.buzzer &&
          other.signalAon == this.signalAon &&
          other.signalAmax == this.signalAmax &&
          other.signalBon == this.signalBon &&
          other.signalBmax == this.signalBmax &&
          other.signalAgain == this.signalAgain &&
          other.signalBgain == this.signalBgain);
}

class UserDataEntityCompanion extends UpdateCompanion<UserDataEntityData> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> name;
  final Value<String> password;
  final Value<String> email;
  final Value<String> accessType;
  final Value<String> combinedActions;
  final Value<String> opposedActions;
  final Value<String> unopposedActions;
  final Value<String> directActions;
  final Value<bool> switchInputs;
  final Value<bool> useTwoSignals;
  final Value<double> inputGainA;
  final Value<double> inputGainB;
  final Value<bool> useThumbTrigger;
  final Value<double> timeOpenOpen;
  final Value<double> timeHoldOpen;
  final Value<double> timeCoCon;
  final Value<bool> alternate;
  final Value<double> timeAltSwitch;
  final Value<double> timeFastClose;
  final Value<double> levelFastClose;
  final Value<bool> vibrate;
  final Value<bool> buzzer;
  final Value<double> signalAon;
  final Value<double> signalAmax;
  final Value<double> signalBon;
  final Value<double> signalBmax;
  final Value<double> signalAgain;
  final Value<double> signalBgain;
  const UserDataEntityCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.name = const Value.absent(),
    this.password = const Value.absent(),
    this.email = const Value.absent(),
    this.accessType = const Value.absent(),
    this.combinedActions = const Value.absent(),
    this.opposedActions = const Value.absent(),
    this.unopposedActions = const Value.absent(),
    this.directActions = const Value.absent(),
    this.switchInputs = const Value.absent(),
    this.useTwoSignals = const Value.absent(),
    this.inputGainA = const Value.absent(),
    this.inputGainB = const Value.absent(),
    this.useThumbTrigger = const Value.absent(),
    this.timeOpenOpen = const Value.absent(),
    this.timeHoldOpen = const Value.absent(),
    this.timeCoCon = const Value.absent(),
    this.alternate = const Value.absent(),
    this.timeAltSwitch = const Value.absent(),
    this.timeFastClose = const Value.absent(),
    this.levelFastClose = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.buzzer = const Value.absent(),
    this.signalAon = const Value.absent(),
    this.signalAmax = const Value.absent(),
    this.signalBon = const Value.absent(),
    this.signalBmax = const Value.absent(),
    this.signalAgain = const Value.absent(),
    this.signalBgain = const Value.absent(),
  });
  UserDataEntityCompanion.insert({
    this.id = const Value.absent(),
    required String userName,
    required String name,
    required String password,
    required String email,
    required String accessType,
    required String combinedActions,
    required String opposedActions,
    required String unopposedActions,
    required String directActions,
    required bool switchInputs,
    required bool useTwoSignals,
    required double inputGainA,
    required double inputGainB,
    required bool useThumbTrigger,
    required double timeOpenOpen,
    required double timeHoldOpen,
    required double timeCoCon,
    required bool alternate,
    required double timeAltSwitch,
    required double timeFastClose,
    required double levelFastClose,
    required bool vibrate,
    required bool buzzer,
    required double signalAon,
    required double signalAmax,
    required double signalBon,
    required double signalBmax,
    required double signalAgain,
    required double signalBgain,
  })  : userName = Value(userName),
        name = Value(name),
        password = Value(password),
        email = Value(email),
        accessType = Value(accessType),
        combinedActions = Value(combinedActions),
        opposedActions = Value(opposedActions),
        unopposedActions = Value(unopposedActions),
        directActions = Value(directActions),
        switchInputs = Value(switchInputs),
        useTwoSignals = Value(useTwoSignals),
        inputGainA = Value(inputGainA),
        inputGainB = Value(inputGainB),
        useThumbTrigger = Value(useThumbTrigger),
        timeOpenOpen = Value(timeOpenOpen),
        timeHoldOpen = Value(timeHoldOpen),
        timeCoCon = Value(timeCoCon),
        alternate = Value(alternate),
        timeAltSwitch = Value(timeAltSwitch),
        timeFastClose = Value(timeFastClose),
        levelFastClose = Value(levelFastClose),
        vibrate = Value(vibrate),
        buzzer = Value(buzzer),
        signalAon = Value(signalAon),
        signalAmax = Value(signalAmax),
        signalBon = Value(signalBon),
        signalBmax = Value(signalBmax),
        signalAgain = Value(signalAgain),
        signalBgain = Value(signalBgain);
  static Insertable<UserDataEntityData> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? name,
    Expression<String>? password,
    Expression<String>? email,
    Expression<String>? accessType,
    Expression<String>? combinedActions,
    Expression<String>? opposedActions,
    Expression<String>? unopposedActions,
    Expression<String>? directActions,
    Expression<bool>? switchInputs,
    Expression<bool>? useTwoSignals,
    Expression<double>? inputGainA,
    Expression<double>? inputGainB,
    Expression<bool>? useThumbTrigger,
    Expression<double>? timeOpenOpen,
    Expression<double>? timeHoldOpen,
    Expression<double>? timeCoCon,
    Expression<bool>? alternate,
    Expression<double>? timeAltSwitch,
    Expression<double>? timeFastClose,
    Expression<double>? levelFastClose,
    Expression<bool>? vibrate,
    Expression<bool>? buzzer,
    Expression<double>? signalAon,
    Expression<double>? signalAmax,
    Expression<double>? signalBon,
    Expression<double>? signalBmax,
    Expression<double>? signalAgain,
    Expression<double>? signalBgain,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (name != null) 'name': name,
      if (password != null) 'password': password,
      if (email != null) 'email': email,
      if (accessType != null) 'accessType': accessType,
      if (combinedActions != null) 'combined_actions': combinedActions,
      if (opposedActions != null) 'opposed_actions': opposedActions,
      if (unopposedActions != null) 'unopposed_actions': unopposedActions,
      if (directActions != null) 'direct_actions': directActions,
      if (switchInputs != null) 'switch_inputs': switchInputs,
      if (useTwoSignals != null) 'use_two_signals': useTwoSignals,
      if (inputGainA != null) 'input_gain_a': inputGainA,
      if (inputGainB != null) 'input_gain_b': inputGainB,
      if (useThumbTrigger != null) 'use_thumb_trigger': useThumbTrigger,
      if (timeOpenOpen != null) 'time_open_open': timeOpenOpen,
      if (timeHoldOpen != null) 'time_hold_open': timeHoldOpen,
      if (timeCoCon != null) 'time_co_con': timeCoCon,
      if (alternate != null) 'alternate': alternate,
      if (timeAltSwitch != null) 'time_alt_switch': timeAltSwitch,
      if (timeFastClose != null) 'time_fast_close': timeFastClose,
      if (levelFastClose != null) 'level_fast_close': levelFastClose,
      if (vibrate != null) 'vibrate': vibrate,
      if (buzzer != null) 'buzzer': buzzer,
      if (signalAon != null) 'signal_a_on': signalAon,
      if (signalAmax != null) 'signal_a_max': signalAmax,
      if (signalBon != null) 'signal_b_on': signalBon,
      if (signalBmax != null) 'signal_b_max': signalBmax,
      if (signalAgain != null) 'signal_a_gain': signalAgain,
      if (signalBgain != null) 'signal_b_gain': signalBgain,
    });
  }

  UserDataEntityCompanion copyWith(
      {Value<int>? id,
      Value<String>? userName,
      Value<String>? name,
      Value<String>? password,
      Value<String>? email,
      Value<String>? accessType,
      Value<String>? combinedActions,
      Value<String>? opposedActions,
      Value<String>? unopposedActions,
      Value<String>? directActions,
      Value<bool>? switchInputs,
      Value<bool>? useTwoSignals,
      Value<double>? inputGainA,
      Value<double>? inputGainB,
      Value<bool>? useThumbTrigger,
      Value<double>? timeOpenOpen,
      Value<double>? timeHoldOpen,
      Value<double>? timeCoCon,
      Value<bool>? alternate,
      Value<double>? timeAltSwitch,
      Value<double>? timeFastClose,
      Value<double>? levelFastClose,
      Value<bool>? vibrate,
      Value<bool>? buzzer,
      Value<double>? signalAon,
      Value<double>? signalAmax,
      Value<double>? signalBon,
      Value<double>? signalBmax,
      Value<double>? signalAgain,
      Value<double>? signalBgain}) {
    return UserDataEntityCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      accessType: accessType ?? this.accessType,
      combinedActions: combinedActions ?? this.combinedActions,
      opposedActions: opposedActions ?? this.opposedActions,
      unopposedActions: unopposedActions ?? this.unopposedActions,
      directActions: directActions ?? this.directActions,
      switchInputs: switchInputs ?? this.switchInputs,
      useTwoSignals: useTwoSignals ?? this.useTwoSignals,
      inputGainA: inputGainA ?? this.inputGainA,
      inputGainB: inputGainB ?? this.inputGainB,
      useThumbTrigger: useThumbTrigger ?? this.useThumbTrigger,
      timeOpenOpen: timeOpenOpen ?? this.timeOpenOpen,
      timeHoldOpen: timeHoldOpen ?? this.timeHoldOpen,
      timeCoCon: timeCoCon ?? this.timeCoCon,
      alternate: alternate ?? this.alternate,
      timeAltSwitch: timeAltSwitch ?? this.timeAltSwitch,
      timeFastClose: timeFastClose ?? this.timeFastClose,
      levelFastClose: levelFastClose ?? this.levelFastClose,
      vibrate: vibrate ?? this.vibrate,
      buzzer: buzzer ?? this.buzzer,
      signalAon: signalAon ?? this.signalAon,
      signalAmax: signalAmax ?? this.signalAmax,
      signalBon: signalBon ?? this.signalBon,
      signalBmax: signalBmax ?? this.signalBmax,
      signalAgain: signalAgain ?? this.signalAgain,
      signalBgain: signalBgain ?? this.signalBgain,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (accessType.present) {
      map['accessType'] = Variable<String>(accessType.value);
    }
    if (combinedActions.present) {
      map['combined_actions'] = Variable<String>(combinedActions.value);
    }
    if (opposedActions.present) {
      map['opposed_actions'] = Variable<String>(opposedActions.value);
    }
    if (unopposedActions.present) {
      map['unopposed_actions'] = Variable<String>(unopposedActions.value);
    }
    if (directActions.present) {
      map['direct_actions'] = Variable<String>(directActions.value);
    }
    if (switchInputs.present) {
      map['switch_inputs'] = Variable<bool>(switchInputs.value);
    }
    if (useTwoSignals.present) {
      map['use_two_signals'] = Variable<bool>(useTwoSignals.value);
    }
    if (inputGainA.present) {
      map['input_gain_a'] = Variable<double>(inputGainA.value);
    }
    if (inputGainB.present) {
      map['input_gain_b'] = Variable<double>(inputGainB.value);
    }
    if (useThumbTrigger.present) {
      map['use_thumb_trigger'] = Variable<bool>(useThumbTrigger.value);
    }
    if (timeOpenOpen.present) {
      map['time_open_open'] = Variable<double>(timeOpenOpen.value);
    }
    if (timeHoldOpen.present) {
      map['time_hold_open'] = Variable<double>(timeHoldOpen.value);
    }
    if (timeCoCon.present) {
      map['time_co_con'] = Variable<double>(timeCoCon.value);
    }
    if (alternate.present) {
      map['alternate'] = Variable<bool>(alternate.value);
    }
    if (timeAltSwitch.present) {
      map['time_alt_switch'] = Variable<double>(timeAltSwitch.value);
    }
    if (timeFastClose.present) {
      map['time_fast_close'] = Variable<double>(timeFastClose.value);
    }
    if (levelFastClose.present) {
      map['level_fast_close'] = Variable<double>(levelFastClose.value);
    }
    if (vibrate.present) {
      map['vibrate'] = Variable<bool>(vibrate.value);
    }
    if (buzzer.present) {
      map['buzzer'] = Variable<bool>(buzzer.value);
    }
    if (signalAon.present) {
      map['signal_a_on'] = Variable<double>(signalAon.value);
    }
    if (signalAmax.present) {
      map['signal_a_max'] = Variable<double>(signalAmax.value);
    }
    if (signalBon.present) {
      map['signal_b_on'] = Variable<double>(signalBon.value);
    }
    if (signalBmax.present) {
      map['signal_b_max'] = Variable<double>(signalBmax.value);
    }
    if (signalAgain.present) {
      map['signal_a_gain'] = Variable<double>(signalAgain.value);
    }
    if (signalBgain.present) {
      map['signal_b_gain'] = Variable<double>(signalBgain.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserDataEntityCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('email: $email, ')
          ..write('accessType: $accessType, ')
          ..write('combinedActions: $combinedActions, ')
          ..write('opposedActions: $opposedActions, ')
          ..write('unopposedActions: $unopposedActions, ')
          ..write('directActions: $directActions, ')
          ..write('switchInputs: $switchInputs, ')
          ..write('useTwoSignals: $useTwoSignals, ')
          ..write('inputGainA: $inputGainA, ')
          ..write('inputGainB: $inputGainB, ')
          ..write('useThumbTrigger: $useThumbTrigger, ')
          ..write('timeOpenOpen: $timeOpenOpen, ')
          ..write('timeHoldOpen: $timeHoldOpen, ')
          ..write('timeCoCon: $timeCoCon, ')
          ..write('alternate: $alternate, ')
          ..write('timeAltSwitch: $timeAltSwitch, ')
          ..write('timeFastClose: $timeFastClose, ')
          ..write('levelFastClose: $levelFastClose, ')
          ..write('vibrate: $vibrate, ')
          ..write('buzzer: $buzzer, ')
          ..write('signalAon: $signalAon, ')
          ..write('signalAmax: $signalAmax, ')
          ..write('signalBon: $signalBon, ')
          ..write('signalBmax: $signalBmax, ')
          ..write('signalAgain: $signalAgain, ')
          ..write('signalBgain: $signalBgain')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  late final $UserDataEntityTable userDataEntity = $UserDataEntityTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userDataEntity];
}
