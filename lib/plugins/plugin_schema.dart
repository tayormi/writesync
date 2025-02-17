/// Defines the type and validation rules for a plugin configuration option
class PluginOptionSchema {
  final String name;
  final Type type;
  final bool required;
  final dynamic defaultValue;
  final List<PluginValidator> validators;
  final String description;

  const PluginOptionSchema({
    required this.name,
    required this.type,
    this.required = false,
    this.defaultValue,
    this.validators = const [],
    this.description = '',
  });

  bool validate(dynamic value, List<String> errors) {
    if (value == null) {
      if (required) {
        errors.add('Option $name is required');
        return false;
      }
      return true;
    }

    if (value.runtimeType != type) {
      errors.add('Option $name must be of type $type');
      return false;
    }

    for (final validator in validators) {
      if (!validator.validate(value, errors)) {
        return false;
      }
    }

    return true;
  }
}

/// Base class for plugin configuration validators
abstract class PluginValidator {
  const PluginValidator();
  bool validate(dynamic value, List<String> errors);
}

/// Validates that a number is within a range
class RangeValidator extends PluginValidator {
  final num min;
  final num max;

  const RangeValidator({required this.min, required this.max});

  @override
  bool validate(dynamic value, List<String> errors) {
    if (value is! num) {
      errors.add('Value must be a number');
      return false;
    }
    if (value < min || value > max) {
      errors.add('Value must be between $min and $max');
      return false;
    }
    return true;
  }
}

/// Validates that a string matches a pattern
class PatternValidator extends PluginValidator {
  final RegExp pattern;
  final String message;

  const PatternValidator({required this.pattern, required this.message});

  @override
  bool validate(dynamic value, List<String> errors) {
    if (value is! String) {
      errors.add('Value must be a string');
      return false;
    }
    if (!pattern.hasMatch(value)) {
      errors.add(message);
      return false;
    }
    return true;
  }
}

/// Validates that a list contains valid items
class ListValidator extends PluginValidator {
  final Type itemType;
  final PluginValidator? itemValidator;

  const ListValidator({required this.itemType, this.itemValidator});

  @override
  bool validate(dynamic value, List<String> errors) {
    if (value is! List) {
      errors.add('Value must be a list');
      return false;
    }

    for (var i = 0; i < value.length; i++) {
      final item = value[i];
      if (item.runtimeType != itemType) {
        errors.add('Item at index $i must be of type $itemType');
        return false;
      }
      if (itemValidator != null && !itemValidator!.validate(item, errors)) {
        return false;
      }
    }
    return true;
  }
}

/// Base class for plugin schemas
abstract class PluginSchema {
  /// Plugin metadata
  String get name;
  String get version;
  String get description;
  String get author;
  String get homepage;
  List<String> get dependencies;

  /// Configuration schema
  List<PluginOptionSchema> get options;

  /// Validate plugin configuration
  List<String> validate(Map<String, dynamic> config) {
    final errors = <String>[];

    for (final option in options) {
      final value = config[option.name] ?? option.defaultValue;
      option.validate(value, errors);
    }

    return errors;
  }

  /// Generate default configuration
  Map<String, dynamic> defaultConfig() {
    return {
      for (final option in options)
        if (option.defaultValue != null) option.name: option.defaultValue,
    };
  }

  /// Generate documentation
  String generateDocs() {
    final buffer = StringBuffer();

    // Plugin info
    buffer.writeln('# $name v$version');
    buffer.writeln(description);
    buffer.writeln();
    buffer.writeln('Author: $author');
    buffer.writeln('Homepage: $homepage');
    buffer.writeln();

    if (dependencies.isNotEmpty) {
      buffer.writeln('## Dependencies');
      for (final dep in dependencies) {
        buffer.writeln('- $dep');
      }
      buffer.writeln();
    }

    // Configuration options
    buffer.writeln('## Configuration Options');
    for (final option in options) {
      buffer.writeln('### ${option.name}');
      buffer.writeln('Type: ${option.type}');
      buffer.writeln('Required: ${option.required}');
      if (option.defaultValue != null) {
        buffer.writeln('Default: ${option.defaultValue}');
      }
      if (option.description.isNotEmpty) {
        buffer.writeln(option.description);
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}

/// Example usage:
/// ```dart
/// class LukehogAnalyticsSchema extends PluginSchema {
///   @override
///   String get name => 'lukehog_analytics';
///   
///   @override
///   String get version => '1.0.0';
///   
///   @override
///   List<PluginOptionSchema> get options => [
///     PluginOptionSchema(
///       name: 'projectId',
///       type: String,
///       required: true,
///       description: 'Your Lukehog project ID',
///     ),
///     PluginOptionSchema(
///       name: 'debug',
///       type: bool,
///       defaultValue: false,
///       description: 'Enable debug mode',
///     ),
///     PluginOptionSchema(
///       name: 'sessionExpiration',
///       type: int,
///       defaultValue: 1800,
///       validators: [
///         RangeValidator(min: 300, max: 7200),
///       ],
///       description: 'Session expiration in seconds (5-120 minutes)',
///     ),
///   ];
/// }
/// ``` 