import 'package:chkm8_app/enum/lastest_accept_enum.dart';
import 'package:equatable/equatable.dart';

abstract class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object> get props => [];
}

class GlobalGetLastestAccpetEvent extends GlobalEvent {
  final LastestAcceptEnum type;

  GlobalGetLastestAccpetEvent({this.type});

  @override
  List<Object> get props => [type];
}