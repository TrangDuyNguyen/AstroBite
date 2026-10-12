/// Scan mode representation for AstroBite camera pipeline.
enum ScanMode {
  /// Regular plated food, broth, Asian dishes, regional topping decomposition.
  dish,

  /// Packaged snacks, drinks, cans, nutrition facts table, and barcode OCR.
  packaged;

  bool get isDish => this == ScanMode.dish;
  bool get isPackaged => this == ScanMode.packaged;
}
