// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:fake_shop_app/data/data_sources/local/hive_services.dart';
import 'package:fake_shop_app/data/models/transaction_model.dart';
import 'package:fake_shop_app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfCreator {
  late final Box _userData;

  PdfCreator() {
    _userData = HiveServices.user_data;
  }

  PdfGrid _formatPriceDetails(PriceDetails priceDetails) {
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);
    grid.rows.add();
    grid.rows[0].cells[0].value = "SUBTOTAL";
    grid.rows[0].cells[1].value = "${priceDetails.subTotal}\$";
    grid.rows.add();
    grid.rows[1].cells[0].value = "TAX";
    grid.rows[1].cells[1].value = "${priceDetails.tax}\$";
    grid.rows.add();
    grid.rows[2].cells[0].value = "DISCOUNT";
    grid.rows[2].cells[1].value = "${priceDetails.discount}\$";
    grid.rows.add();
    grid.rows[3].cells[0].value = "TOTAL";
    grid.rows[3].cells[1].value = "${priceDetails.totalPrice}\$";

    for (int index = 0; index < grid.rows.count; index++) {
      grid.rows[index].cells[0].style = PdfGridCellStyle(
          font: PdfStandardFont(
            PdfFontFamily.timesRoman,
            25.0,
            style: PdfFontStyle.bold,
          ),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
          ));
      grid.rows[index].cells[1].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(left: 50.0),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
          ));
    }

    grid.rows.applyStyle(PdfGridRowStyle());
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(top: 2.5, bottom: 2.5, right: 2.5, left: 2.5),
    );

    grid.rows.applyStyle(
      PdfGridCellStyle(
        borders: PdfBorders(
          left: PdfPens.transparent,
          right: PdfPens.transparent,
        ),
        format: PdfStringFormat(),
      ),
    );
    return grid;
  }

  PdfGrid _productsGrid(
      TransactionModel transaction, Map<String, Map<int, int>> products) {
    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);

    var header = grid.headers.add(1)[0];
    header.cells[0].value = 'Items';
    header.cells[1].value = 'Quantity';
    header.cells[2].value = 'Price';

    header.style.font = PdfStandardFont(
      PdfFontFamily.timesRoman,
      20.0,
      style: PdfFontStyle.bold,
    );
    header.style.backgroundBrush = PdfBrushes.black;
    header.style.textBrush = PdfBrushes.white;

    for (int index = 0; index < products.length + 1; index++) {
      var rowCollection = grid.rows;
      rowCollection.add();
      if (index == products.length) {
        rowCollection[index].cells[0].value = "Total";
        rowCollection[index].cells[2].value =
            transaction.priceDetails.subTotal.toString();
      } else {
        MapEntry<String, Map<int, int>> entry =
            products.entries.toList()[index];
        rowCollection[index].cells[0].value = entry.key;
        rowCollection[index].cells[1].value = entry.value.keys.first.toString();
        rowCollection[index].cells[2].value = '${entry.value.values.first}\$';
      }
      if (index.isOdd) {
        rowCollection[index].style.backgroundBrush = PdfBrushes.lightGray;
      } else {
        rowCollection[index].style.backgroundBrush = PdfBrushes.white;
      }
    }

    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(bottom: 5.0, top: 5.0, right: 5.0, left: 5.0),
    );

    grid.rows.applyStyle(PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPens.transparent,
        right: PdfPens.transparent,
        top: PdfPens.transparent,
        bottom: PdfPens.transparent,
      ),
      format: PdfStringFormat(),
    ));

    return grid;
  }

  Future<void> _saveAndLaunchFile(List<int> bytes, String file_name) async {
    await Permission.storage.request();
    String path = Platform.isAndroid
        ? ('/storage/emulated/0/Download')
        : (await path_provider.getDownloadsDirectory())!.path;
    String file_path = '$path/$file_name';
    File file = File(file_path);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<bool> createInvoice(
      TransactionModel transaction, Map<String, Map<int, int>> products) async {
    try {
      PdfDocument document = PdfDocument();
      PdfPage page = document.pages.add();
      var graphics = page.graphics;
      Size pageSize = page.getClientSize();

      graphics.drawString(
          'INVOICE',
          PdfStandardFont(
            PdfFontFamily.timesRoman,
            30.0,
            style: PdfFontStyle.bold,
          ),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
          ),
          bounds: Rect.fromLTWH(0, 10.0, pageSize.width, 100.0));

      var currentUser = UserModel.fromJson(_userData.toMap());
      graphics.drawString(
          ('''
Invoice No : ${transaction.id}
Client Email: ${currentUser.email}
    '''),
          PdfStandardFont(PdfFontFamily.timesRoman, 15.0),
          format: PdfStringFormat(
              wordWrap: PdfWordWrapType.wordOnly,
              alignment: PdfTextAlignment.left),
          bounds: Rect.fromLTWH(10.0, 75, pageSize.width, 150.0));

      graphics.drawString(
          ('''
Date : ${transaction.purchaseDate} 
Payment Type : ${transaction.paymentType.name} \n
    '''),
          PdfStandardFont(PdfFontFamily.timesRoman, 15.0),
          format: PdfStringFormat(
              wordWrap: PdfWordWrapType.wordOnly,
              alignment: PdfTextAlignment.left),
          bounds: Rect.fromLTWH(10.0, 120.0, pageSize.width, 150.0));

      PdfGrid grid = _productsGrid(transaction, products);
      var gridResult = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(10.0, 175.0, pageSize.width, pageSize.height));

      var priceDetails = _formatPriceDetails(transaction.priceDetails);
      priceDetails.draw(
          page: page,
          bounds: Rect.fromLTWH(10.0, gridResult!.bounds.bottom + 15.0,
              pageSize.width, pageSize.height));

      List<int> bytes = await document.save();

      document.dispose();
      await _saveAndLaunchFile(bytes, 'transaction-No(${transaction.id}).pdf');
      return true;
    } catch (exception) {
      return false;
    }
  }
}
