import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dados extends StatelessWidget {
  final List data;
  final int tipo;
  const Dados({super.key, required this.data, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: ((context, index) {
        return Card(
          elevation: 1,
          // padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 10),
          // decoration: const BoxDecoration(
          //   color: Color.fromARGB(255, 235, 233, 233),
          // ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 10, bottom: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    tipo == 1
                        ? const Icon(
                            Icons.add,
                            color: Color.fromARGB(255, 4, 132, 9),
                          )
                        : const Icon(
                            Icons.remove,
                            color: Color.fromARGB(255, 219, 42, 11),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      data[index]['nome'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  NumberFormat.decimalPattern().format(data[index]['valor']),
                  style: TextStyle(
                    fontSize: 20,
                    color: tipo == 1
                        ? Color.fromARGB(255, 4, 118, 7)
                        : const Color.fromARGB(255, 212, 100, 100),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
