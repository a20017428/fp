import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


buildProgress(BuildContext context){
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WillPopScope(
              child: AlertDialog(
                title: Text('Waiting', style: TextStyle(fontSize: 24),),
                content: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              onWillPop: () async => false,
            ),
          ],
        );
      }
  );
}