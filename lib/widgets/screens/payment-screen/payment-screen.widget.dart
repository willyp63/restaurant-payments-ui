import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimos/utils/currency.utils.dart';

import 'package:mimos/constants/index.dart';
import 'package:mimos/models/index.dart';
import 'package:mimos/widgets/shared/index.dart';

class MMSPaymentScreenArguments {
  final TableModel table;
  final List<TableItemModel> items;

  MMSPaymentScreenArguments({this.table, this.items});
}

class MMSPaymentScreen extends StatefulWidget {
  final TableModel table;
  final List<TableItemModel> items;

  MMSPaymentScreen({this.table, this.items});

  @override
  _MMSPaymentScreenState createState() => _MMSPaymentScreenState();
}

class _MMSPaymentScreenState extends State<MMSPaymentScreen> {
  num _tipPercent = 0.2;

  @override
  Widget build(BuildContext context) {
    final numItems = widget.items.length;
    final itemsSubtotal = widget.items
        .map((item) => item.price)
        .reduce((sum, itemPrice) => sum + itemPrice);
    final tip = itemsSubtotal * _tipPercent;
    final totalAmount = itemsSubtotal + tip;

    return Scaffold(
        backgroundColor: MMSColors.babyPowder,
        appBar: MMSAppBar(
          title: Text(
            widget.table.name,
            style: Theme.of(context)
                .textTheme
                .display1
                .merge(TextStyle(color: MMSColors.white)),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Your items ($numItems):',
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Text(
                      formatCurrency(itemsSubtotal),
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .merge(TextStyle(fontWeight: FontWeight.normal)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tip Amount:',
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: MMSTextField(
                        type: TextInputType.number,
                        onChanged: (String value) {
                          // TODO
                        },
                        onBlur: () {
                          // TODO
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Slider(
                  activeColor: Theme.of(context).primaryColor,
                  min: 0,
                  max: .4,
                  onChanged: (newTipPercent) {
                    setState(() => _tipPercent = newTipPercent);
                  },
                  value: _tipPercent,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Total Amount:',
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Text(
                      formatCurrency(totalAmount),
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    MMSButton(
                      text: 'Pay Now',
                      onPressed: _goToPaymentConfirmationScreen,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _goToPaymentConfirmationScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.paymentConfirmation, (_) => false);
  }
}
