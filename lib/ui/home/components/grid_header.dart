import 'package:flutter/material.dart';

class GridHeader extends StatelessWidget {
  const GridHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(15),
        topLeft: Radius.circular(15),
      ),
      child: Container(
        height: 50,
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Text(
                'Nome',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
            Container(
              width: 35,
              alignment: Alignment.center,
              child: Text(
                'Gols',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
            Container(
              width: 35,
              alignment: Alignment.center,
              child: Text(
                'M/D',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
            Container(
              width: 90,
              alignment: Alignment.center,
              child: Text(
                'Último Pgto',
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
