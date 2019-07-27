import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mimos/constants/index.dart';
import 'package:mimos/widgets/shared/index.dart';

class MMSWelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MMSColors.babyPowder,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: 0.0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Image.asset(MMSImagePaths.silverwareGraphic),
                ),
              ),
              Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 12,
                      horizontal: MediaQuery.of(context).size.width / 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Image.asset(MMSImagePaths.logo),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 40),
                          child: Text('Lorem ipsum dolar amet consect',
                              style: Theme.of(context).textTheme.headline),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 24),
                                child: MMSButton(
                                  text: 'Join',
                                  onPressed: () {
                                  Navigator.of(context).pushNamed(AppRoutes.signUp);
                                },
                                ),
                              ),
                              MMSButton(
                                type: MMSButtonType.Secondary,
                                text: 'Login',
                                onPressed: () {
                                  Navigator.of(context).pushNamed(AppRoutes.login);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
      ),
    );
  }
}
