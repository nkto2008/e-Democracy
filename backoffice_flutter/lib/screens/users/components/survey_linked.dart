import 'package:backoffice_flutter/constants/clients/http.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../models/survey.dart';
import '../../../models/user.dart';
import '../../../requests/polls.dart';
import '../../../widgets/survey_data_row.dart';

class SurveyLinked extends StatefulWidget {
  const SurveyLinked({
    Key? key,
    required User? userSelected,
  })  : _userSelected = userSelected,
        super(key: key);

  final User? _userSelected;

  @override
  State<SurveyLinked> createState() => _SurveyLinkedState();
}

class _SurveyLinkedState extends State<SurveyLinked> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultPadding / 4),
      ),
      child: widget._userSelected != null
          ? Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sondages :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica',
                      fontSize: 25,
                      color: pitaya,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FutureBuilder(
                      future: Polls.getPollsByUser(widget._userSelected?.id),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(color: pitaya),
                            );
                            break;
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Error: ${snapshot.error}"),
                              );
                            }
                            if (snapshot.hasData) {
                              final List<Survey> surveys = snapshot.data;
                              print(surveys);
                              if (surveys.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "Aucun Sondage",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Helvetica',
                                      fontSize: 40,
                                      color: Colors.black12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }
                              return DataTable(
                                horizontalMargin: 0,
                                columnSpacing: defaultPadding,
                                columns: const [
                                  DataColumn(
                                    label: Text("ID"),
                                  ),
                                  DataColumn(
                                    label: Text("Nom"),
                                  ),
                                  DataColumn(
                                    label: Text("Type"),
                                  ),
                                  DataColumn(
                                    label: Text("Anonyme"),
                                  ),
                                  DataColumn(
                                    label: Text("Date création"),
                                  ),
                                  DataColumn(
                                    label: Text("Status"),
                                  ),
                                ],
                                rows: List.generate(
                                  surveys.length,
                                  (index) => surveyDataRow(surveys[index]),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "Aucun Sondage",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Helvetica',
                                    fontSize: 40,
                                    color: Colors.black12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            break;
                          default:
                            return Container();
                            break;
                        }
                      },
                    ),
                  ),
                ],
              ),
          )
          : const Center(
              child: Text(
                "Selectionnez un utilisateur",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Helvetica',
                  fontSize: 40,
                  color: Colors.black12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
