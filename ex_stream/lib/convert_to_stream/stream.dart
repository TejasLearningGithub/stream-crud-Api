import 'dart:async';

import 'model/person.dart';

final StreamController<List<Person>> streamPerson =
      StreamController<List<Person>>.broadcast();