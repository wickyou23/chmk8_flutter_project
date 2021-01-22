import 'dart:async';
import 'package:chkm8_app/bloc/rating/given_rating_bloc.dart';
import 'package:chkm8_app/bloc/rating/given_rating_event.dart';
import 'package:chkm8_app/bloc/rating/given_rating_state.dart';
import 'package:chkm8_app/bloc/rating/pending_rating_bloc.dart';
import 'package:chkm8_app/bloc/rating/pending_rating_event.dart';
import 'package:chkm8_app/bloc/rating/pending_rating_state.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/screens/rate_your_date/start_rating_intro_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/custom_segment_widget.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RateDashboardScreen extends StatefulWidget {
  static final routeName = '/RateDashboardScreen';

  @override
  _RateDashboardScreenState createState() => _RateDashboardScreenState();
}

class _RateDashboardScreenState extends State<RateDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  int _segmentSelected = 0;
  bool _isPendingProcessing = false;
  bool _isGivenProcessing = false;
  PendingRatingState _crPendingState = PendingRatingListInitializeState();
  GivenRatingState _crGivenState = GivenRatingListInitializeState();
  List<HistoryRatingObject> _pendingList = [];
  List<HistoryRatingObject> _givenList = [];
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var crState = context.bloc<PendingRatingBloc>().state;
      if (crState is PendingRatingListInitializeState) {
        context.bloc<PendingRatingBloc>().add(PendingRatingGetListEvent());
      }
    });

    super.initState();
  }

  void reloadData() {
    if (_segmentSelected == 0) {
      context.bloc<PendingRatingBloc>().add(PendingRatingGetListEvent());
    } else {
      context.bloc<GivenRatingBloc>().add(GivenRatingGetListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldState,
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Rate Your Date',
            navTitleColor: Constaint.rateYourDateColor,
          ),
          Container(
            margin: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomSegmentWidget(
                    segmentChanged: (index) {
                      _segmentSelected = index;
                      if (!_refreshCompleter.isCompleted) {
                        _refreshCompleter.complete();
                      }

                      if ((_segmentSelected == 0 && _pendingList.isEmpty) ||
                          (_segmentSelected == 1 && _givenList.isEmpty)) {
                        this.reloadData();
                      } else {
                        setState(() {});
                      }
                    },
                  ),
                ),
                Expanded(
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<PendingRatingBloc, PendingRatingState>(
                        listener: (ctx, state) {
                          _crPendingState = state;
                          if (state is PendingRatingListReadyState) {
                            _isPendingProcessing = false;
                            _pendingList = state.pendingList;
                          } else if (state
                              is PendingRatingListProcessingState) {
                            _isPendingProcessing = _pendingList.isEmpty;
                          } else if (state
                              is PendingRatingGetListSuccessState) {
                            if (!_refreshCompleter.isCompleted &&
                                _segmentSelected == 0) {
                              _refreshCompleter.complete();
                            }
                          } else if (state is PendingRatingGetListFailedState) {
                            if (!_refreshCompleter.isCompleted &&
                                _segmentSelected == 0) {
                              _refreshCompleter.complete();
                            }
                            
                            if (state.failedState.statusCode == 101) {
                              _scaffoldState.currentState.showCSSnackBar(
                                  state.failedState.errorMessage);
                            } else {
                              _scaffoldState.currentState
                                  .showCSSnackBar('Get pending list failed.');
                            }
                          }
                          setState(() {});
                        },
                      ),
                      BlocListener<GivenRatingBloc, GivenRatingState>(
                        listener: (ctx, state) {
                          _crGivenState = state;
                          if (state is GivenRatingListReadyState) {
                            _isGivenProcessing = false;
                            _givenList = state.givenList;
                          } else if (state is GivenRatingListProcessingState) {
                            _isGivenProcessing = _givenList.isEmpty;
                          } else if (state is GivenRatingGetListSuccessState) {
                            if (!_refreshCompleter.isCompleted &&
                                _segmentSelected == 1) {
                              _refreshCompleter.complete();
                            }
                          } else if (state is GivenRatingGetListFailedState) {
                            if (!_refreshCompleter.isCompleted &&
                                _segmentSelected == 1) {
                              _refreshCompleter.complete();
                            }

                            if (state.failedState.statusCode == 101) {
                              _scaffoldState.currentState.showCSSnackBar(
                                  state.failedState.errorMessage);
                            } else {
                              _scaffoldState.currentState
                                  .showCSSnackBar('Get given list failed.');
                            }
                          }
                          setState(() {});
                        },
                      ),
                    ],
                    child: _buildList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRateCell(HistoryRatingObject obj) {
    return Container(
      key: ValueKey(obj.id),
      constraints: BoxConstraints(minHeight: 57),
      child: InkWell(
        onTap: () {
          context.navigator.pushNamed(
            StartRatingIntroScreen.routeName,
            arguments: obj,
          );
        },
        highlightColor: Constaint.rateYourDateColor.withPercentAlpha(0.2),
        splashColor: Constaint.rateYourDateColor.withPercentAlpha(0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Row(
            children: <Widget>[
              Text(
                'Rate ${obj.nickName}',
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Constaint.defaultTextColor,
                ),
              ),
              Expanded(child: Container()),
              ImageIcon(
                AssetImage('assets/images/ic_arrow_right.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatedCell(HistoryRatingObject obj) {
    return Container(
      key: ValueKey(obj.id),
      constraints: BoxConstraints(minHeight: 57),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: RichText(
          text: TextSpan(
            text: 'You rated ',
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: Constaint.defaultTextColor,
            ),
            children: [
              TextSpan(
                text: '${obj.nickName} ${obj.displayStar}',
                style: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Constaint.defaultTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    String emptyString = '';
    if (_segmentSelected == 0 &&
        _pendingList.isEmpty &&
        _crPendingState is PendingRatingListReadyState) {
      emptyString = 'No pending ratings.';
    }

    if (_segmentSelected == 1 &&
        _givenList.isEmpty &&
        _crGivenState is GivenRatingListReadyState) {
      emptyString = 'No ratings given.';
    }

    return ((_segmentSelected == 0 && _isPendingProcessing) ||
            (_segmentSelected == 1 && _isGivenProcessing))
        ? Center(
            child: Utils.getLoadingWidget(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: emptyString.isNotEmpty
                ? Center(
                    child: Text(
                      emptyString,
                      style: context.theme.textTheme.headline5.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[300],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (ctx, idx) {
                      if (_segmentSelected == 0) {
                        if (_pendingList.length == idx) {
                          return Container();
                        }

                        return _buildPendingRateCell(_pendingList[idx]);
                      } else {
                        if (_givenList.length == idx) {
                          return Container();
                        }

                        return _buildRatedCell(_givenList[idx]);
                      }
                    },
                    separatorBuilder: (ctx, idx) {
                      return Divider(
                        height: 0.5,
                        color: ColorExt.colorWithHex(0xE0E0E0),
                        indent: 20,
                        endIndent: 20,
                      );
                    },
                    itemCount: (_segmentSelected == 0)
                        ? _pendingList.length + 1
                        : _givenList.length + 1,
                  ),
            onRefresh: () async {
              this.reloadData();
              return _refreshCompleter.future;
            },
          );
  }
}
