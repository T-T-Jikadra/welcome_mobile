import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomGridDetailsList extends StatelessWidget {
  final List<dynamic> gridDetails;
  final bool isReadOnly;
  final ScrollController? gridListController;
  final Function(int index) onDelete;
  final Function(int index, Map<String, dynamic> item) onItemTap;
  final Future<List<dynamic>?> Function(
          BuildContext context, int index, Map<String, dynamic> item)?
      navigateToEdit;

  const CustomGridDetailsList({
    super.key,
    required this.gridDetails,
    this.isReadOnly = false,
    this.gridListController,
    required this.onDelete,
    required this.onItemTap,
    this.navigateToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: gridListController,
      itemCount: gridDetails.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = gridDetails[index];
        var totGSTPer = double.parse(item['cgstrate'].toString()) +
            double.parse(item['sgstrate'].toString());
        var totGSTAmt = double.parse(item['sgstamt'].toString()) +
            double.parse(item['sgstamt'].toString());

        return InkWell(
          onTap: () async {
            if (navigateToEdit != null) {
              var result = await navigateToEdit!(context, index, item);
              if (result != null && result.isNotEmpty) {
                onItemTap.call(index, result[0]);
              }
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black12.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        Text(
                                          '#${index + 1}\t\t',
                                          style: TextStyle(
                                            fontFamily: 'muli',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: screenWidth < 600
                                                ? (screenWidth * 39) / 100
                                                : (screenWidth * 47) / 100,
                                          ),
                                          child: Text(
                                            "${item['itemname'].toString()}"
                                            "   Design :  ${item['design'].toString()}"
                                            "   HSN Code :  ${item['hsncode'].toString()}",
                                            style: TextStyle(
                                              fontFamily: 'muli',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: (screenWidth * 48) / 100),
                                      child: Row(
                                        children: [
                                          Text(' Subtotal : \t ',
                                              style: TextStyle(
                                                  fontFamily: 'muli',
                                                  fontWeight: FontWeight.w700)),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: screenWidth < 600
                                                    ? 80
                                                    : 100),
                                            child: Text(
                                              item['per'].toString() == "P"
                                                  ? "Mtr : ${item['meters']}"
                                                  : "Pcs : ${item['pcs']}",
                                              style: TextStyle(
                                                fontFamily: 'muli',
                                                fontWeight: FontWeight.w700,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Text(' Discount (%) : \t',
                                        style: TextStyle(
                                            fontFamily: 'muli',
                                            color: Color.fromARGB(
                                                255, 233, 152, 30),
                                            fontWeight: FontWeight.w400)),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              screenWidth < 600 ? 130 : 150),
                                      child: Text(
                                        item['discper'].toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 233, 152, 30),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Text(' Discount 2 (%) : \t',
                                        style: TextStyle(
                                            fontFamily: 'muli',
                                            color: Color.fromARGB(
                                                255, 233, 152, 30),
                                            fontWeight: FontWeight.w400)),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              screenWidth < 600 ? 130 : 150),
                                      child: Text(
                                        item['discper2'].toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 233, 152, 30),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Text(' Tax GST @ (%)  : \t',
                                        style: TextStyle(
                                            fontFamily: 'muli',
                                            fontWeight: FontWeight.w700)),
                                    Text(double.parse(
                                                item['igstrate'].toString()) ==
                                            0.0
                                        ? totGSTPer.toString()
                                        : item['igstrate'].toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black12.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isReadOnly
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Icon(Icons.delete_forever,
                                                color: Colors.blueGrey,
                                                size: 20),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: InkWell(
                                              onTap: () {
                                                // showDetDeleteDialog(
                                                //   id: index + 1,
                                                //   context,
                                                //   onCancel: () {},
                                                //   onConfirm: () {
                                                //     onDelete(index);
                                                //   },
                                                // );
                                              },
                                              child: Icon(Icons.delete_forever,
                                                  size: 20,
                                                  color: const Color.fromARGB(
                                                      255, 209, 47, 35)),
                                            ),
                                          ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth < 600
                                              ? (screenWidth * 20) / 100
                                              : (screenWidth * 25) / 100,
                                        ),
                                        child: Text(
                                          NumberFormat.currency(
                                                  locale: 'en_IN', symbol: '₹')
                                              .format(double.tryParse(
                                                      item['finalamt']
                                                          .toString()) ??
                                                  0.0),
                                          style: TextStyle(
                                              fontFamily: 'muli',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: Color.fromARGB(
                                                  255, 74, 161, 231)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: screenWidth < 600
                                          ? (screenWidth * 30) / 100
                                          : (screenWidth * 32.5) / 100,
                                    ),
                                    child: Text(
                                      item['per'].toString() == "P"
                                          ? "[ Pcs ] - ${item['pcs'].toString()} × ${item['rate'].toString()} = ₹ ${item['amount'].toString()}"
                                          : item['per'].toString() == "M"
                                              ? "[ Mtrs ] - ${item['meters'].toString()}× ${item['rate'].toString()} = ₹ ${item['amount'].toString()}"
                                              : "[ Wt ] - ${item['weight'].toString()}× ${item['rate'].toString()} = ₹ ${item['amount'].toString()}",
                                      style: TextStyle(
                                          fontFamily: 'muli', fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹  ${item['discamt'].toString()}",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 233, 152, 30),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹  ${item['discamt2'].toString()}",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 233, 152, 30),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(double.parse(
                                              item['igstrate'].toString()) ==
                                          0.0
                                      ? "₹  ${totGSTAmt.toString()}"
                                      : "₹  ${item['igstamt'].toString()}"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
