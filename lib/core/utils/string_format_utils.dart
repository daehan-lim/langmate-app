class StringFormatUtils {
  static String cleanHtml(String input) {
    final withoutTags = input.replaceAll(RegExp(r'<[^>]+>'), '');
    return withoutTags
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ');
  }
}
