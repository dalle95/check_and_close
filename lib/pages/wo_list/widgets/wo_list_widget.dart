import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/common/entities/wo.dart';
import '/common/widgets/container_base.dart';

import '/common/routes/names.dart';
import '/common/utils/date_util.dart';
import '/common/widgets/empty_list.dart';

Widget woList(List<WO>? lista) {
  return BaseContainer(
    height: 600.h,
    width: 325.w,
    margin: EdgeInsets.only(top: 15.h),
    color: Colors.white,
    child: lista!.isEmpty
        ? buildEmptyListView("Non sono presenti manutenzioni.")
        : ListView.builder(
            shrinkWrap: true,
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return woItem(
                context: context,
                wo: lista[index],
              );
            },
          ),
  );
}

Widget woItem({
  required BuildContext context,
  WO? wo,
}) {
  // Definisco i dati da passare alla prossima pagina
  final arguments = wo!.toJson();
  return Card(
    elevation: 1,
    margin: EdgeInsets.symmetric(
      horizontal: 10.w,
      vertical: 5.h,
    ),
    child: Padding(
      padding: EdgeInsets.all(5.0.dg),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.WO_DETAIL,
            arguments: arguments,
          );
        },
        leading: SizedBox(
          height: 25.h,
          width: 25.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset("assets/icons/work.png"),
          ),
        ),
        title: Text(
          wo.descrizione!,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('[${wo.code}]'),
            Text(
              'Data inizio: ${dataFormattata(wo.dataInizio!)}\nData fine: ${dataFormattata(wo.dataFine!)}',
            ),
          ],
        ),
      ),
    ),
  );
}
