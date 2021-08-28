import 'package:flutter/material.dart';
import 'package:glitter/utils/db.util.dart';
import 'package:in_app_review/in_app_review.dart';

class RatingBox extends StatefulWidget {
  final void Function() onLater;
  const RatingBox({Key? key, required this.onLater}) : super(key: key);

  @override
  _RatingBoxState createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bgFade;
  late final Animation<double> _fade;

  int _activeStars = 0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );

    _bgFade = Tween<double>(begin: 0, end: 0.65).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _fade = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.00, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How would you like to rate this app?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.filled(5, null)
                        .asMap()
                        .keys
                        .map(
                          (index) => IconButton(
                            onPressed: () {
                              print(index);
                              setState(() {
                                _activeStars = index + 1;
                              });
                            },
                            icon: Icon(
                              _activeStars >= index + 1
                                  ? Icons.star_rate_rounded
                                  : Icons.star_outline_rounded,
                              size: 35,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          try {
                            await dbService.setIsLater(true);

                            await _controller.reverse();
                            widget.onLater();
                          } catch (e) {
                            print(
                                'Error occured while setting the show review box to true: $e');
                          }
                        },
                        child: Text('Later'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await dbService.setIsReviewed(true);

                            final InAppReview _review = InAppReview.instance;
                            _review.openStoreListing(
                              appStoreId: 'com.dev404.glitter',
                            );
                            widget.onLater();
                          } catch (e) {
                            print(
                                'Error occured while setting the reviewed to true: $e');
                          }
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black87.withOpacity(_bgFade.value),
            child: Center(
              child: Opacity(
                opacity: _fade.value,
                child: child,
              ),
            ),
          );
        });
  }
}
