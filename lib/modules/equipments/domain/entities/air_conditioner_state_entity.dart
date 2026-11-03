import '../value_objects/equipment_enums.dart';

class AirConditionerState {
  const AirConditionerState({
    this.power = false,
    this.mode = AirConditionerMode.cool,
    this.degrees = 23,
    this.fanSpeed = AirConditionerFanSpeed.auto,
    this.swingVertical = AirConditionerSwingVertical.auto,
    this.swingHorizontal = AirConditionerSwingHorizontal.off,
    this.turbo = false,
    this.econo = false,
    this.quiet = false,
    this.light = true,
    this.clean = false,
    this.filter = false,
    this.beep = true,
    this.sleep = -1,
  });

  final bool power;
  final AirConditionerMode mode;
  final double degrees;
  final AirConditionerFanSpeed fanSpeed;
  final AirConditionerSwingVertical swingVertical;
  final AirConditionerSwingHorizontal swingHorizontal;
  final bool turbo;
  final bool econo;
  final bool quiet;
  final bool light;
  final bool clean;
  final bool filter;
  final bool beep;
  final int sleep;

  AirConditionerState copyWith({
    bool? power,
    AirConditionerMode? mode,
    double? degrees,
    AirConditionerFanSpeed? fanSpeed,
    AirConditionerSwingVertical? swingVertical,
    AirConditionerSwingHorizontal? swingHorizontal,
    bool? turbo,
    bool? econo,
    bool? quiet,
    bool? light,
  }) {
    return AirConditionerState(
      power: power ?? this.power,
      mode: mode ?? this.mode,
      degrees: degrees ?? this.degrees,
      fanSpeed: fanSpeed ?? this.fanSpeed,
      swingVertical: swingVertical ?? this.swingVertical,
      swingHorizontal: swingHorizontal ?? this.swingHorizontal,
      turbo: turbo ?? this.turbo,
      econo: econo ?? this.econo,
      quiet: quiet ?? this.quiet,
      light: light ?? this.light,
      clean: clean,
      filter: filter,
      beep: beep,
      sleep: sleep,
    );
  }
}
