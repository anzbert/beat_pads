/// midi note data of XPP layouts
enum XPP {
  standard,
  latinJazz,
  xo,
  xtreme;

  List<int> get list {
    switch (this) {
      case XPP.standard:
        return XppConstants.standardGrid;
      case XPP.latinJazz:
        return XppConstants.latinJazzGrid;
      case XPP.xo:
        return XppConstants.standardGridXO;
      case XPP.xtreme:
        return XppConstants.xtremeGrid;
    }
  }
}

abstract class XppConstants {
  static const List<int> standardGrid = [
    36,
    42,
    42,
    36,
    38,
    46,
    46,
    38,
    43,
    50,
    50,
    43,
    49,
    51,
    51,
    49,
  ];
  static const List<int> standardGridXO = [
    36,
    40,
    40,
    36,
    38,
    41,
    41,
    38,
    39,
    42,
    42,
    39,
    43,
    37,
    37,
    43,
  ];
  static const List<int> latinJazzGrid = [
    36,
    44,
    44,
    36,
    43,
    49,
    49,
    43,
    50,
    38,
    38,
    50,
    51,
    37,
    37,
    51,
  ];
  static const List<int> xtremeGrid = [
    37,
    36,
    42,
    51,
    51,
    42,
    36,
    37,
    40,
    38,
    46,
    53,
    53,
    46,
    38,
    40,
    41,
    43,
    47,
    50,
    50,
    47,
    43,
    41,
    55,
    49,
    56,
    57,
    57,
    56,
    49,
    55,
  ];
}
