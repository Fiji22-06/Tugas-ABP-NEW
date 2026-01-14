class FormatUtil {
  static String formatCurrency(int amount) {
    if (amount == 0) return 'Gratis';
    
    String str = amount.toString();
    String result = '';
    int count = 0;
    
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.' + result;
        count = 0;
      }
    }
    
    return 'Rp $result';
  }
}
