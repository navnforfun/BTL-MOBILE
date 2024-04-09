List<Map<int, double>> data(List e) {
  List<Map<int, double>> dataMap = [];
  for (int i = 0; i < e.length; i++) {
    dataMap.add( {1: i.toDouble(), 2: e[i]});
  }
  return dataMap;
}
