import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tractian_challenge/app/controllers/assets_controller.dart';
import 'package:tractian_challenge/app/models/companies.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsController = GetIt.I.get<AssetsController>();
  List<Companies> get companiesList => assetsController.companiesList;

  _HomePageState() {
    assetsController.addListener(() async {
      if (mounted) {
        setState(() {});
      }
    });

    assetsController.setCompaniesList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double horizontalPadding = changePadding(size.width);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Image.asset('assets/LOGO_TRACTIAN.png'),
          centerTitle: true,
        ),
        body: companiesList.isEmpty
            ? Center(
                child: Column(
                  children: const [
                    Icon(Icons.warning_rounded),
                    Text('Não há companias disponíveis')
                  ],
                ),
              )
            : SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: companiesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: horizontalPadding),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        onPressed: () async {
                          bool selected = assetsController
                              .selectCompany(companiesList[index]);

                          if (selected) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '${companiesList[index].name} Unit foi selecionada, aguarde a organização dos dados.')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('A seleção de compania falhou.')),
                            );
                          }

                          assetsController.clearExibitionList();
                          assetsController.filterOff();
                          await Future.delayed(const Duration(seconds: 1));

                          Navigator.of(context).pushNamed('/assets');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          height: size.height * .1,
                          child: Row(
                            children: [
                              Image.asset('assets/list_icon.png'),
                              const SizedBox(
                                width: 15,
                              ),
                              Text('${companiesList[index].name} Unit'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  double changePadding(double _width) {
    return (_width <= 500)
        ? 25
        : (_width > 500 && _width <= 1100)
            ? _width * .15
            : (_width > 1100 && _width <= 2500)
                ? _width * .25
                : (_width < 2500)
                    ? _width * .33
                    : _width * 4;
  }
}
