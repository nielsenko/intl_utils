import 'package:intl_utils/src/parser/icu_parser.dart';
import 'package:intl_utils/src/parser/message_format.dart';
import 'package:test/test.dart';

void main() {
  group('Literal messages', () {
    test('Test literal message with empty string', () {
      var response = IcuParser().parse('');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals(''));
    });

    test('Test literal message with plain text', () {
      var response = IcuParser().parse('This is some content.');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('This is some content.'));
    });

    test('Test literal message with special characters', () {
      var response =
          IcuParser().parse('Special characters: ,./?\\[]!@#\$%^&*()_+-=');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('Special characters: ,./?\\[]!@#\$%^&*()_+-='));
    });
  });

  group('Argument messages', () {
    test('Test argument message with placeholder only', () {
      var response = IcuParser().parse('{firstName}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(0).type, equals(ElementType.argument));
      expect(response?.elementAt(0).value, equals('firstName'));
    });

    test('Test argument message with placeholder and plain text', () {
      var response = IcuParser().parse('Hi my name is {firstName}!');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Hi my name is '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('firstName'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('!'));
    });

    test(
        'Test argument message with placeholder and plain text when there are no space around placeholder',
        () {
      var response = IcuParser()
          .parse('Link: https://example.com?user={username}&test=yes');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('Link: https://example.com?user='));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('username'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('&test=yes'));
    });

    test('Test argument message with few placeholders and plain text', () {
      var response =
          IcuParser().parse('My name is {lastName}, {firstName} {lastName}!');

      expect(response, isNotNull);
      expect(response?.length, equals(7));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('My name is '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('lastName'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(', '));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('firstName'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals(' '));

      expect(response?.elementAt(5).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(5).type, equals(ElementType.argument));
      expect(response?.elementAt(5).value, equals('lastName'));

      expect(response?.elementAt(6).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(6).type, equals(ElementType.literal));
      expect(response?.elementAt(6).value, equals('!'));
    });
  });

  group('Plural messages', () {
    test(
        'Test plural message with all plural forms when plural forms have plain text',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {zero message} one {one message} two {two message} few {few message} many {many message} other {other message}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('zero message'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('one message'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('two message'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message'));
    });

    test(
        'Test plural message with all plural forms when plural forms are empty',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {} one {} two {} few {} many {} other {}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals(''));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals(''));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals(''));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals(''));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals(''));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals(''));
    });

    test(
        'Test plural message with all plural forms when there are no whitespace around plural forms',
        () {
      var response = IcuParser().parse(
          '{count,plural,zero{zero message}one{one message}two{two message}few{few message}many{many message}other{other message}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('zero message'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('one message'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('two message'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message'));
    });

    test(
        'Test plural message with all plural forms where zero, one and two plural forms are expressed in the "equal-number" way',
        () {
      var response = IcuParser().parse(
          '{count, plural, =0 {=0 message} =1 {=1 message} =2 {=2 message} few {few message} many {many message} other {other message}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('=0'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('=0 message'));

      expect(options[1].name, equals('=1'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('=1 message'));

      expect(options[2].name, equals('=2'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('=2 message'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message'));
    });

    test(
        'Test plural message with all plural forms when plural forms have placeholder',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {zero message with {name} placeholder.} one {one message with {name} placeholder.} two {two message with {name} placeholder.} few {few message with {name} placeholder.} many {many message with {name} placeholder.} other {other message with {name} placeholder.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('zero message with '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals(' placeholder.'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('one message with '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals(' placeholder.'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('two message with '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals(' placeholder.'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(3));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message with '));
      expect(options[3].value[1].runtimeType, equals(ArgumentElement));
      expect(options[3].value[1].type, equals(ElementType.argument));
      expect(options[3].value[1].value, equals('name'));
      expect(options[3].value[2].runtimeType, equals(LiteralElement));
      expect(options[3].value[2].type, equals(ElementType.literal));
      expect(options[3].value[2].value, equals(' placeholder.'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(3));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message with '));
      expect(options[4].value[1].runtimeType, equals(ArgumentElement));
      expect(options[4].value[1].type, equals(ElementType.argument));
      expect(options[4].value[1].value, equals('name'));
      expect(options[4].value[2].runtimeType, equals(LiteralElement));
      expect(options[4].value[2].type, equals(ElementType.literal));
      expect(options[4].value[2].value, equals(' placeholder.'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(3));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message with '));
      expect(options[5].value[1].runtimeType, equals(ArgumentElement));
      expect(options[5].value[1].type, equals(ElementType.argument));
      expect(options[5].value[1].value, equals('name'));
      expect(options[5].value[2].runtimeType, equals(LiteralElement));
      expect(options[5].value[2].type, equals(ElementType.literal));
      expect(options[5].value[2].value, equals(' placeholder.'));
    });

    test(
        'Test plural message with all plural forms when plural forms have few placeholders',
        () {
      var response = IcuParser().parse(
          '{count, plural, =0 {{firstName} {lastName}: zero message} =1 {{firstName} {lastName}: one message} =2 {{firstName} {lastName}: two message} few {{firstName} {lastName}: few message} many {{firstName} {lastName}: many message} other {{firstName} {lastName}: other message}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('=0'));
      expect(options[0].value.length, equals(4));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('firstName'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' '));
      expect(options[0].value[2].runtimeType, equals(ArgumentElement));
      expect(options[0].value[2].type, equals(ElementType.argument));
      expect(options[0].value[2].value, equals('lastName'));
      expect(options[0].value[3].runtimeType, equals(LiteralElement));
      expect(options[0].value[3].type, equals(ElementType.literal));
      expect(options[0].value[3].value, equals(': zero message'));

      expect(options[1].name, equals('=1'));
      expect(options[1].value.length, equals(4));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('firstName'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' '));
      expect(options[1].value[2].runtimeType, equals(ArgumentElement));
      expect(options[1].value[2].type, equals(ElementType.argument));
      expect(options[1].value[2].value, equals('lastName'));
      expect(options[1].value[3].runtimeType, equals(LiteralElement));
      expect(options[1].value[3].type, equals(ElementType.literal));
      expect(options[1].value[3].value, equals(': one message'));

      expect(options[2].name, equals('=2'));
      expect(options[2].value.length, equals(4));
      expect(options[2].value[0].runtimeType, equals(ArgumentElement));
      expect(options[2].value[0].type, equals(ElementType.argument));
      expect(options[2].value[0].value, equals('firstName'));
      expect(options[2].value[1].runtimeType, equals(LiteralElement));
      expect(options[2].value[1].type, equals(ElementType.literal));
      expect(options[2].value[1].value, equals(' '));
      expect(options[2].value[2].runtimeType, equals(ArgumentElement));
      expect(options[2].value[2].type, equals(ElementType.argument));
      expect(options[2].value[2].value, equals('lastName'));
      expect(options[2].value[3].runtimeType, equals(LiteralElement));
      expect(options[2].value[3].type, equals(ElementType.literal));
      expect(options[2].value[3].value, equals(': two message'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(4));
      expect(options[3].value[0].runtimeType, equals(ArgumentElement));
      expect(options[3].value[0].type, equals(ElementType.argument));
      expect(options[3].value[0].value, equals('firstName'));
      expect(options[3].value[1].runtimeType, equals(LiteralElement));
      expect(options[3].value[1].type, equals(ElementType.literal));
      expect(options[3].value[1].value, equals(' '));
      expect(options[3].value[2].runtimeType, equals(ArgumentElement));
      expect(options[3].value[2].type, equals(ElementType.argument));
      expect(options[3].value[2].value, equals('lastName'));
      expect(options[3].value[3].runtimeType, equals(LiteralElement));
      expect(options[3].value[3].type, equals(ElementType.literal));
      expect(options[3].value[3].value, equals(': few message'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(4));
      expect(options[4].value[0].runtimeType, equals(ArgumentElement));
      expect(options[4].value[0].type, equals(ElementType.argument));
      expect(options[4].value[0].value, equals('firstName'));
      expect(options[4].value[1].runtimeType, equals(LiteralElement));
      expect(options[4].value[1].type, equals(ElementType.literal));
      expect(options[4].value[1].value, equals(' '));
      expect(options[4].value[2].runtimeType, equals(ArgumentElement));
      expect(options[4].value[2].type, equals(ElementType.argument));
      expect(options[4].value[2].value, equals('lastName'));
      expect(options[4].value[3].runtimeType, equals(LiteralElement));
      expect(options[4].value[3].type, equals(ElementType.literal));
      expect(options[4].value[3].value, equals(': many message'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(4));
      expect(options[5].value[0].runtimeType, equals(ArgumentElement));
      expect(options[5].value[0].type, equals(ElementType.argument));
      expect(options[5].value[0].value, equals('firstName'));
      expect(options[5].value[1].runtimeType, equals(LiteralElement));
      expect(options[5].value[1].type, equals(ElementType.literal));
      expect(options[5].value[1].value, equals(' '));
      expect(options[5].value[2].runtimeType, equals(ArgumentElement));
      expect(options[5].value[2].type, equals(ElementType.argument));
      expect(options[5].value[2].value, equals('lastName'));
      expect(options[5].value[3].runtimeType, equals(LiteralElement));
      expect(options[5].value[3].type, equals(ElementType.literal));
      expect(options[5].value[3].value, equals(': other message'));
    });

    test(
        'Test plural message with one and other plural forms when plural forms have gender message',
        () {
      var response = IcuParser().parse(
          '{count, plural, one {{gender, select, female {Girl has} male {Boy has} other {Person has}} one item} other {{gender, select, female {Girl has} male {Boy has} other {Person has}} {count} items}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(GenderElement));
      expect(options[0].value[0].type, equals(ElementType.gender));
      expect(options[0].value[0].value, equals('gender'));

      var pluOneGenOpt = (options[0].value[0] as GenderElement).options;

      expect(pluOneGenOpt.length, equals(3));
      expect(pluOneGenOpt[0].name, equals('female'));
      expect(pluOneGenOpt[0].value.length, equals(1));
      expect(pluOneGenOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(pluOneGenOpt[0].value[0].type, equals(ElementType.literal));
      expect(pluOneGenOpt[0].value[0].value, equals('Girl has'));
      expect(pluOneGenOpt[1].name, equals('male'));
      expect(pluOneGenOpt[1].value.length, equals(1));
      expect(pluOneGenOpt[1].value[0].runtimeType, equals(LiteralElement));
      expect(pluOneGenOpt[1].value[0].type, equals(ElementType.literal));
      expect(pluOneGenOpt[1].value[0].value, equals('Boy has'));
      expect(pluOneGenOpt[2].name, equals('other'));
      expect(pluOneGenOpt[2].value.length, equals(1));
      expect(pluOneGenOpt[2].value[0].runtimeType, equals(LiteralElement));
      expect(pluOneGenOpt[2].value[0].type, equals(ElementType.literal));
      expect(pluOneGenOpt[2].value[0].value, equals('Person has'));

      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' one item'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(4));
      expect(options[1].value[0].runtimeType, equals(GenderElement));
      expect(options[1].value[0].type, equals(ElementType.gender));
      expect(options[1].value[0].value, equals('gender'));

      var pluOtherGenOpt = (options[1].value[0] as GenderElement).options;

      expect(pluOtherGenOpt.length, equals(3));
      expect(pluOtherGenOpt[0].name, equals('female'));
      expect(pluOtherGenOpt[0].value.length, equals(1));
      expect(pluOtherGenOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(pluOtherGenOpt[0].value[0].type, equals(ElementType.literal));
      expect(pluOtherGenOpt[0].value[0].value, equals('Girl has'));
      expect(pluOtherGenOpt[1].name, equals('male'));
      expect(pluOtherGenOpt[1].value.length, equals(1));
      expect(pluOtherGenOpt[1].value[0].runtimeType, equals(LiteralElement));
      expect(pluOtherGenOpt[1].value[0].type, equals(ElementType.literal));
      expect(pluOtherGenOpt[1].value[0].value, equals('Boy has'));
      expect(pluOtherGenOpt[2].name, equals('other'));
      expect(pluOtherGenOpt[2].value.length, equals(1));
      expect(pluOtherGenOpt[2].value[0].runtimeType, equals(LiteralElement));
      expect(pluOtherGenOpt[2].value[0].type, equals(ElementType.literal));
      expect(pluOtherGenOpt[2].value[0].value, equals('Person has'));

      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' '));
      expect(options[1].value[2].runtimeType, equals(ArgumentElement));
      expect(options[1].value[2].type, equals(ElementType.argument));
      expect(options[1].value[2].value, equals('count'));
      expect(options[1].value[3].runtimeType, equals(LiteralElement));
      expect(options[1].value[3].type, equals(ElementType.literal));
      expect(options[1].value[3].value, equals(' items'));
    });
  });

  group('Gender messages', () {
    test(
        'Test gender message with all gender forms when gender forms have plain text',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {Hi woman!} male {Hi man!} other {Hi there!}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Hi woman!'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Hi man!'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('Hi there!'));
    });

    test(
        'Test gender message with all gender forms when gender forms are empty',
        () {
      var response =
          IcuParser().parse('{gender, select, female {} male {} other {}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals(''));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals(''));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals(''));
    });

    test(
        'Test gender message with all gender forms when there are no whitespace around gender forms',
        () {
      var response = IcuParser().parse(
          '{gender,select,female{Hi woman!}male{Hi man!}other{Hi there!}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Hi woman!'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Hi man!'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('Hi there!'));
    });

    test(
        'Test gender message with all gender forms when gender forms have placeholder',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {Miss {firstName}.} male {Mister {firstName}.} other {User {firstName}.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Miss '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('firstName'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals('.'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mister '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('firstName'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals('.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('User '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('firstName'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals('.'));
    });

    test(
        'Test gender message with all gender forms when gender forms have few placeholders',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {Miss {firstName} {lastName} from {address}.} male {Mister {firstName} {lastName} from {address}.} other {User {firstName} {lastName} from {address}.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(7));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Miss '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('firstName'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals(' '));
      expect(options[0].value[3].runtimeType, equals(ArgumentElement));
      expect(options[0].value[3].type, equals(ElementType.argument));
      expect(options[0].value[3].value, equals('lastName'));
      expect(options[0].value[4].runtimeType, equals(LiteralElement));
      expect(options[0].value[4].type, equals(ElementType.literal));
      expect(options[0].value[4].value, equals(' from '));
      expect(options[0].value[5].runtimeType, equals(ArgumentElement));
      expect(options[0].value[5].type, equals(ElementType.argument));
      expect(options[0].value[5].value, equals('address'));
      expect(options[0].value[6].runtimeType, equals(LiteralElement));
      expect(options[0].value[6].type, equals(ElementType.literal));
      expect(options[0].value[6].value, equals('.'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(7));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mister '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('firstName'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals(' '));
      expect(options[1].value[3].runtimeType, equals(ArgumentElement));
      expect(options[1].value[3].type, equals(ElementType.argument));
      expect(options[1].value[3].value, equals('lastName'));
      expect(options[1].value[4].runtimeType, equals(LiteralElement));
      expect(options[1].value[4].type, equals(ElementType.literal));
      expect(options[1].value[4].value, equals(' from '));
      expect(options[1].value[5].runtimeType, equals(ArgumentElement));
      expect(options[1].value[5].type, equals(ElementType.argument));
      expect(options[1].value[5].value, equals('address'));
      expect(options[1].value[6].runtimeType, equals(LiteralElement));
      expect(options[1].value[6].type, equals(ElementType.literal));
      expect(options[1].value[6].value, equals('.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(7));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('User '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('firstName'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals(' '));
      expect(options[2].value[3].runtimeType, equals(ArgumentElement));
      expect(options[2].value[3].type, equals(ElementType.argument));
      expect(options[2].value[3].value, equals('lastName'));
      expect(options[2].value[4].runtimeType, equals(LiteralElement));
      expect(options[2].value[4].type, equals(ElementType.literal));
      expect(options[2].value[4].value, equals(' from '));
      expect(options[2].value[5].runtimeType, equals(ArgumentElement));
      expect(options[2].value[5].type, equals(ElementType.argument));
      expect(options[2].value[5].value, equals('address'));
      expect(options[2].value[6].runtimeType, equals(LiteralElement));
      expect(options[2].value[6].type, equals(ElementType.literal));
      expect(options[2].value[6].value, equals('.'));
    });

    test(
        'Test gender message with all gender forms when gender forms have plural message',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {She has {count, plural, one {one apple} other {{count} apples}}} male {He has {count, plural, one {one apple} other {{count} apples}}} other {Person has {count, plural, one {one apple} other {{count} apples}}}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('She has '));
      expect(options[0].value[1].runtimeType, equals(PluralElement));
      expect(options[0].value[1].type, equals(ElementType.plural));
      expect(options[0].value[1].value, equals('count'));

      var genFemalePluOpt = (options[0].value[1] as PluralElement).options;

      expect(genFemalePluOpt.length, equals(2));
      expect(genFemalePluOpt[0].name, equals('one'));
      expect(genFemalePluOpt[0].value.length, equals(1));
      expect(genFemalePluOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(genFemalePluOpt[0].value[0].type, equals(ElementType.literal));
      expect(genFemalePluOpt[0].value[0].value, equals('one apple'));
      expect(genFemalePluOpt[1].name, equals('other'));
      expect(genFemalePluOpt[1].value.length, equals(2));
      expect(genFemalePluOpt[1].value[0].runtimeType, equals(ArgumentElement));
      expect(genFemalePluOpt[1].value[0].type, equals(ElementType.argument));
      expect(genFemalePluOpt[1].value[0].value, equals('count'));
      expect(genFemalePluOpt[1].value[1].runtimeType, equals(LiteralElement));
      expect(genFemalePluOpt[1].value[1].type, equals(ElementType.literal));
      expect(genFemalePluOpt[1].value[1].value, equals(' apples'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('He has '));
      expect(options[1].value[1].runtimeType, equals(PluralElement));
      expect(options[1].value[1].type, equals(ElementType.plural));
      expect(options[1].value[1].value, equals('count'));

      var genMalePluOpt = (options[1].value[1] as PluralElement).options;

      expect(genMalePluOpt.length, equals(2));
      expect(genMalePluOpt[0].name, equals('one'));
      expect(genMalePluOpt[0].value.length, equals(1));
      expect(genMalePluOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(genMalePluOpt[0].value[0].type, equals(ElementType.literal));
      expect(genMalePluOpt[0].value[0].value, equals('one apple'));
      expect(genMalePluOpt[1].name, equals('other'));
      expect(genMalePluOpt[1].value.length, equals(2));
      expect(genMalePluOpt[1].value[0].runtimeType, equals(ArgumentElement));
      expect(genMalePluOpt[1].value[0].type, equals(ElementType.argument));
      expect(genMalePluOpt[1].value[0].value, equals('count'));
      expect(genMalePluOpt[1].value[1].runtimeType, equals(LiteralElement));
      expect(genMalePluOpt[1].value[1].type, equals(ElementType.literal));
      expect(genMalePluOpt[1].value[1].value, equals(' apples'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('Person has '));
      expect(options[2].value[1].runtimeType, equals(PluralElement));
      expect(options[2].value[1].type, equals(ElementType.plural));
      expect(options[2].value[1].value, equals('count'));

      var genOtherPluOpt = (options[2].value[1] as PluralElement).options;

      expect(genOtherPluOpt.length, equals(2));
      expect(genOtherPluOpt[0].name, equals('one'));
      expect(genOtherPluOpt[0].value.length, equals(1));
      expect(genOtherPluOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(genOtherPluOpt[0].value[0].type, equals(ElementType.literal));
      expect(genOtherPluOpt[0].value[0].value, equals('one apple'));
      expect(genOtherPluOpt[1].name, equals('other'));
      expect(genOtherPluOpt[1].value.length, equals(2));
      expect(genOtherPluOpt[1].value[0].runtimeType, equals(ArgumentElement));
      expect(genOtherPluOpt[1].value[0].type, equals(ElementType.argument));
      expect(genOtherPluOpt[1].value[0].value, equals('count'));
      expect(genOtherPluOpt[1].value[1].runtimeType, equals(LiteralElement));
      expect(genOtherPluOpt[1].value[1].type, equals(ElementType.literal));
      expect(genOtherPluOpt[1].value[1].value, equals(' apples'));
    });
  });

  group('Select messages', () {
    test('Test select message when select forms have plain text', () {
      var response = IcuParser().parse(
          '{choice, select, foo {This is foo option} bar {This is bar option} baz {This is baz option}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('This is foo option'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('This is bar option'));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('This is baz option'));
    });

    test('Test select message when select forms are empty', () {
      var response =
          IcuParser().parse('{choice, select, foo {} bar {} baz {}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals(''));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals(''));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals(''));
    });

    test('Test select message when there are no whitespace around select forms',
        () {
      var response = IcuParser().parse(
          '{choice,select,foo{This is foo option}bar{This is bar option}baz{This is baz option}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('This is foo option'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('This is bar option'));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('This is baz option'));
    });

    test('Test select message when select forms have placeholder', () {
      var response = IcuParser().parse(
          '{choice, select, foo {This is foo option with {name} placeholder} bar {This is bar option with {name} placeholder} baz {This is baz option with {name} placeholder}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('This is foo option with '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals(' placeholder'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('This is bar option with '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals(' placeholder'));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('This is baz option with '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals(' placeholder'));
    });

    test('Test select message when select forms have few placeholders', () {
      var response = IcuParser().parse(
          '{choice, select, foo {Foo: {firstName} {lastName}} bar {Bar: {firstName} {lastName}} baz {Baz: {firstName} {lastName}}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(4));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Foo: '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('firstName'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals(' '));
      expect(options[0].value[3].runtimeType, equals(ArgumentElement));
      expect(options[0].value[3].type, equals(ElementType.argument));
      expect(options[0].value[3].value, equals('lastName'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(4));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Bar: '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('firstName'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals(' '));
      expect(options[1].value[3].runtimeType, equals(ArgumentElement));
      expect(options[1].value[3].type, equals(ElementType.argument));
      expect(options[1].value[3].value, equals('lastName'));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(4));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('Baz: '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('firstName'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals(' '));
      expect(options[2].value[3].runtimeType, equals(ArgumentElement));
      expect(options[2].value[3].type, equals(ElementType.argument));
      expect(options[2].value[3].value, equals('lastName'));
    });
  });

  group('Compound messages', () {
    test('Test compound message of literal and plural', () {
      var response = IcuParser().parse(
          'John has {count, plural, one {{count} apple} other {{count} apples}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('John has '));

      expect(response?.elementAt(1).runtimeType, equals(PluralElement));
      expect(response?.elementAt(1).type, equals(ElementType.plural));
      expect(response?.elementAt(1).value, equals('count'));

      var options = (response?.elementAt(1) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('count'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' apple'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('count'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of literal and gender', () {
      var response = IcuParser().parse(
          'Welcome {gender, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Welcome '));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender'));

      var options = (response?.elementAt(1) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('male'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Mr '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('female'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mrs '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('dear '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of literal and select', () {
      var response = IcuParser().parse(
          'The {choice, select, admin {admin {name}} owner {owner {name}} other {user {name}}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The '));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice'));

      var options = (response?.elementAt(1) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('admin'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('admin '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('owner'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('owner '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('user '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of argument and plural', () {
      var response = IcuParser().parse(
          '{name} has {count, plural, one {{count} apple} other {{count} apples}} in the bag.');

      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(0).type, equals(ElementType.argument));
      expect(response?.elementAt(0).value, equals('name'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' has '));

      expect(response?.elementAt(2).runtimeType, equals(PluralElement));
      expect(response?.elementAt(2).type, equals(ElementType.plural));
      expect(response?.elementAt(2).value, equals('count'));

      var options = (response?.elementAt(2) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('count'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' apple'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('count'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' in the bag.'));
    });

    test('Test compound message of argument and gender', () {
      var response = IcuParser().parse(
          'The {gender, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}} has the {device}.');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The '));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender'));

      var options = (response?.elementAt(1) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('male'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Mr '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('female'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mrs '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('dear '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' has the '));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('device'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('.'));
    });

    test('Test compound message of argument and select', () {
      var response = IcuParser().parse(
          'The one {choice, select, coffee {{name} coffee} tea {{name} tea} other {{name} drink}} please for the {client}.');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The one '));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice'));

      var options = (response?.elementAt(1) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('coffee'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('name'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' coffee'));

      expect(options[1].name, equals('tea'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('name'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' tea'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(ArgumentElement));
      expect(options[2].value[0].type, equals(ElementType.argument));
      expect(options[2].value[0].value, equals('name'));
      expect(options[2].value[1].runtimeType, equals(LiteralElement));
      expect(options[2].value[1].type, equals(ElementType.literal));
      expect(options[2].value[1].value, equals(' drink'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' please for the '));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('client'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('.'));
    });

    test('Test compound message of two plurals', () {
      var response = IcuParser().parse(
          '{count1, plural, one {{count1} apple} other {{count1} apples}} and {count2, plural, one {{count2} orange} other {{count2} oranges}}');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count1'));

      var options1 = (response?.elementAt(0) as PluralElement).options;

      expect(options1.length, equals(2));

      expect(options1[0].name, equals('one'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[0].type, equals(ElementType.argument));
      expect(options1[0].value[0].value, equals('count1'));
      expect(options1[0].value[1].runtimeType, equals(LiteralElement));
      expect(options1[0].value[1].type, equals(ElementType.literal));
      expect(options1[0].value[1].value, equals(' apple'));

      expect(options1[1].name, equals('other'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[0].type, equals(ElementType.argument));
      expect(options1[1].value[0].value, equals('count1'));
      expect(options1[1].value[1].runtimeType, equals(LiteralElement));
      expect(options1[1].value[1].type, equals(ElementType.literal));
      expect(options1[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' and '));

      expect(response?.elementAt(2).runtimeType, equals(PluralElement));
      expect(response?.elementAt(2).type, equals(ElementType.plural));
      expect(response?.elementAt(2).value, equals('count2'));

      var options2 = (response?.elementAt(2) as PluralElement).options;

      expect(options2.length, equals(2));

      expect(options2[0].name, equals('one'));
      expect(options2[0].value.length, equals(2));
      expect(options2[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[0].value[0].type, equals(ElementType.argument));
      expect(options2[0].value[0].value, equals('count2'));
      expect(options2[0].value[1].runtimeType, equals(LiteralElement));
      expect(options2[0].value[1].type, equals(ElementType.literal));
      expect(options2[0].value[1].value, equals(' orange'));

      expect(options2[1].name, equals('other'));
      expect(options2[1].value.length, equals(2));
      expect(options2[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[1].value[0].type, equals(ElementType.argument));
      expect(options2[1].value[0].value, equals('count2'));
      expect(options2[1].value[1].runtimeType, equals(LiteralElement));
      expect(options2[1].value[1].type, equals(ElementType.literal));
      expect(options2[1].value[1].value, equals(' oranges'));
    });

    test('Test compound message of two genders', () {
      var response = IcuParser().parse(
          '{gender1, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}} and {gender2, select, male {his} female {her} other {its}} cat');

      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender1'));

      var options1 = (response?.elementAt(0) as GenderElement).options;

      expect(options1.length, equals(3));

      expect(options1[0].name, equals('male'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(LiteralElement));
      expect(options1[0].value[0].type, equals(ElementType.literal));
      expect(options1[0].value[0].value, equals('Mr '));
      expect(options1[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[1].type, equals(ElementType.argument));
      expect(options1[0].value[1].value, equals('name'));

      expect(options1[1].name, equals('female'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(LiteralElement));
      expect(options1[1].value[0].type, equals(ElementType.literal));
      expect(options1[1].value[0].value, equals('Mrs '));
      expect(options1[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[1].type, equals(ElementType.argument));
      expect(options1[1].value[1].value, equals('name'));

      expect(options1[2].name, equals('other'));
      expect(options1[2].value.length, equals(2));
      expect(options1[2].value[0].runtimeType, equals(LiteralElement));
      expect(options1[2].value[0].type, equals(ElementType.literal));
      expect(options1[2].value[0].value, equals('dear '));
      expect(options1[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[2].value[1].type, equals(ElementType.argument));
      expect(options1[2].value[1].value, equals('name'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' and '));

      expect(response?.elementAt(2).runtimeType, equals(GenderElement));
      expect(response?.elementAt(2).type, equals(ElementType.gender));
      expect(response?.elementAt(2).value, equals('gender2'));

      var options2 = (response?.elementAt(2) as GenderElement).options;

      expect(options2.length, equals(3));

      expect(options2[0].name, equals('male'));
      expect(options2[0].value.length, equals(1));
      expect(options2[0].value[0].runtimeType, equals(LiteralElement));
      expect(options2[0].value[0].type, equals(ElementType.literal));
      expect(options2[0].value[0].value, equals('his'));

      expect(options2[1].name, equals('female'));
      expect(options2[1].value.length, equals(1));
      expect(options2[1].value[0].runtimeType, equals(LiteralElement));
      expect(options2[1].value[0].type, equals(ElementType.literal));
      expect(options2[1].value[0].value, equals('her'));

      expect(options2[2].name, equals('other'));
      expect(options2[2].value.length, equals(1));
      expect(options2[2].value[0].runtimeType, equals(LiteralElement));
      expect(options2[2].value[0].type, equals(ElementType.literal));
      expect(options2[2].value[0].value, equals('its'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' cat'));
    });

    test('Test compound message of two selects', () {
      var response = IcuParser().parse(
          '{choice1, select, admin {admin {name}} owner {owner {name}} other {user {name}}} with {choice2, select, IELTS {IELTS level} TOEFL {TOEFL level} other {Academic level}} of English');

      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice1'));

      var options1 = (response?.elementAt(0) as SelectElement).options;

      expect(options1.length, equals(3));

      expect(options1[0].name, equals('admin'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(LiteralElement));
      expect(options1[0].value[0].type, equals(ElementType.literal));
      expect(options1[0].value[0].value, equals('admin '));
      expect(options1[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[1].type, equals(ElementType.argument));
      expect(options1[0].value[1].value, equals('name'));

      expect(options1[1].name, equals('owner'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(LiteralElement));
      expect(options1[1].value[0].type, equals(ElementType.literal));
      expect(options1[1].value[0].value, equals('owner '));
      expect(options1[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[1].type, equals(ElementType.argument));
      expect(options1[1].value[1].value, equals('name'));

      expect(options1[2].name, equals('other'));
      expect(options1[2].value.length, equals(2));
      expect(options1[2].value[0].runtimeType, equals(LiteralElement));
      expect(options1[2].value[0].type, equals(ElementType.literal));
      expect(options1[2].value[0].value, equals('user '));
      expect(options1[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[2].value[1].type, equals(ElementType.argument));
      expect(options1[2].value[1].value, equals('name'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' with '));

      expect(response?.elementAt(2).runtimeType, equals(SelectElement));
      expect(response?.elementAt(2).type, equals(ElementType.select));
      expect(response?.elementAt(2).value, equals('choice2'));

      var options2 = (response?.elementAt(2) as SelectElement).options;

      expect(options2.length, equals(3));

      expect(options2[0].name, equals('IELTS'));
      expect(options2[0].value.length, equals(1));
      expect(options2[0].value[0].runtimeType, equals(LiteralElement));
      expect(options2[0].value[0].type, equals(ElementType.literal));
      expect(options2[0].value[0].value, equals('IELTS level'));

      expect(options2[1].name, equals('TOEFL'));
      expect(options2[1].value.length, equals(1));
      expect(options2[1].value[0].runtimeType, equals(LiteralElement));
      expect(options2[1].value[0].type, equals(ElementType.literal));
      expect(options2[1].value[0].value, equals('TOEFL level'));

      expect(options2[2].name, equals('other'));
      expect(options2[2].value.length, equals(1));
      expect(options2[2].value[0].runtimeType, equals(LiteralElement));
      expect(options2[2].value[0].type, equals(ElementType.literal));
      expect(options2[2].value[0].value, equals('Academic level'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' of English'));
    });
  });
}
