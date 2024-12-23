// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:welcome_mob/common/constant.dart';

class eqGridCard extends StatefulWidget {
  const eqGridCard(
      {super.key,
      this.add,
      required this.listData,
      this.icon = Icons.verified_user,
      required this.iconName});

  final List listData;
  final IconData icon;
  final String iconName;
  final bool? add;

  @override
  State<eqGridCard> createState() => _eqGridCardState();
}

class _eqGridCardState extends State<eqGridCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              double iconScaleFactor = screenWidth < 600 ? 0.8 : 1.5;
              double textScaleFactor = screenWidth < 600 ? 0.7 : 0.9;
              return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(widget.listData.length, (index) {
                    return Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              // color: Colors.indigo.shade200,
                              color: Colors.grey.shade400,
                              width: 3,
                            )),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () => {
                                Function.apply(
                                    widget.listData[index]['callback'],
                                    [context])
                              },
                              child: Center(
                                child: Column(
                                  // mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.asset(
                                        'assets/icon/${widget.iconName}.png',
                                        // "assets/svg/verified.png",
                                        height: 40 * iconScaleFactor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, left: 4, right: 4),
                                      child: Text(
                                          widget.listData[index]['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'muli',
                                              fontSize: 20 * textScaleFactor),
                                          textAlign: TextAlign.center),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (widget.add == true)
                              Positioned(
                                top: -8,
                                right: -8,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_circle_outline_sharp,
                                    // color: Colors.indigo.shade400,
                                    color: eqPrimaryColor,
                                  ),
                                  onPressed: () => Function.apply(
                                      widget.listData[index]['addcallback'],
                                      [context]),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }));
            }),
          ],
        ),
      ),
    );
  }
}
