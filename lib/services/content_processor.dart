import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:markdown/markdown.dart' as md;
import 'package:yaml/yaml.dart';

class MarkdownProcessResult {
  final Map<String, dynamic> metadata;
  final String content;

  MarkdownProcessResult({
    required this.metadata,
    required this.content,
  });
}

class ContentProcessor {
  static final ContentProcessor instance = ContentProcessor._();
  ContentProcessor._();

  static const int _chunkSize = 1024 * 64; // 64KB chunks

  Future<MarkdownProcessResult> processMarkdownStream(
      Stream<Uint8List> inputStream) async {
    final frontMatterBuffer = StringBuffer();
    final contentBuffer = StringBuffer();
    var inFrontMatter = false;
    var frontMatterComplete = false;
    var separatorCount = 0;

    final decoder = StreamTransformer<Uint8List, String>.fromHandlers(
      handleData: (data, sink) {
        sink.add(utf8.decode(data));
      },
    );

    await for (final chunk in inputStream.transform(decoder)) {
      final lines = chunk.split('\n');

      for (final line in lines) {
        if (line.trim() == '---') {
          separatorCount++;
          if (separatorCount == 1) {
            inFrontMatter = true;
            continue;
          } else if (separatorCount == 2) {
            inFrontMatter = false;
            frontMatterComplete = true;
            continue;
          }
        }

        if (inFrontMatter) {
          frontMatterBuffer.writeln(line);
        } else if (frontMatterComplete) {
          contentBuffer.writeln(line);
        }
      }
    }

    final metadata = loadYaml(frontMatterBuffer.toString()) as Map;
    final content = contentBuffer.toString().trim();

    return MarkdownProcessResult(
      metadata: Map<String, dynamic>.from(metadata),
      content: content,
    );
  }

  Stream<String> processHtmlStream(String markdown) async* {
    // Process markdown in chunks
    var currentChunk = StringBuffer();
    var currentSize = 0;

    final lines = markdown.split('\n');
    var inCodeBlock = false;

    for (final line in lines) {
      if (line.contains('```')) {
        inCodeBlock = !inCodeBlock;
      }

      currentChunk.writeln(line);
      currentSize += line.length;

      // If we've reached the chunk size and we're not in a code block,
      // process the chunk and yield the result
      if (currentSize >= _chunkSize && !inCodeBlock) {
        // Pre-render markdown to HTML with all necessary extensions
        final html = md.markdownToHtml(
          currentChunk.toString(),
          extensionSet: md.ExtensionSet.gitHubWeb,
          blockSyntaxes: [
            md.TableSyntax(),
            md.FencedCodeBlockSyntax(),
            md.HeaderSyntax(),
            md.BlockquoteSyntax(),
            md.HorizontalRuleSyntax(),
            md.ParagraphSyntax(),
            md.SetextHeaderSyntax(),
            md.HeaderWithIdSyntax(),
            md.OrderedListSyntax(),
            md.UnorderedListSyntax(),
          ],
          inlineSyntaxes: [
            md.InlineHtmlSyntax(),
            md.StrikethroughSyntax(),
            md.AutolinkSyntax(),
            md.LineBreakSyntax(),
            md.EmojiSyntax(),
            md.CodeSyntax(),
            md.LinkSyntax(),
            md.ImageSyntax(),
          ],
        );

        yield html;

        currentChunk.clear();
        currentSize = 0;
      }
    }

    // Process any remaining content
    if (currentChunk.isNotEmpty) {
      final html = md.markdownToHtml(
        currentChunk.toString(),
        extensionSet: md.ExtensionSet.gitHubWeb,
        blockSyntaxes: [
          md.TableSyntax(),
          md.FencedCodeBlockSyntax(),
          md.HeaderSyntax(),
          md.BlockquoteSyntax(),
          md.HorizontalRuleSyntax(),
          md.ParagraphSyntax(),
          md.SetextHeaderSyntax(),
          md.HeaderWithIdSyntax(),
          md.OrderedListSyntax(),
          md.UnorderedListSyntax(),
        ],
        inlineSyntaxes: [
          md.InlineHtmlSyntax(),
          md.StrikethroughSyntax(),
          md.AutolinkSyntax(),
          md.LineBreakSyntax(),
          md.EmojiSyntax(),
          md.CodeSyntax(),
          md.LinkSyntax(),
          md.ImageSyntax(),
        ],
      );
      yield html;
    }
  }

  Stream<String> optimizeHtmlStream(Stream<String> htmlStream) async* {
    await for (final chunk in htmlStream) {
      yield _optimizeHtml(chunk);
    }
  }

  String _optimizeHtml(String html) {
    // Process HTML content to preserve newlines in code blocks
    var inCodeBlock = false;
    final processedLines = <String>[];

    for (final line in html.split('\n')) {
      if (line.trim().startsWith('<pre><code')) {
        inCodeBlock = true;
        processedLines.add(line.replaceAll(r'\', r'\\').replaceAll("'", r"\'"));
      } else if (line.trim().endsWith('</code></pre>')) {
        inCodeBlock = false;
        processedLines.add(line.replaceAll(r'\', r'\\').replaceAll("'", r"\'"));
      } else if (inCodeBlock) {
        processedLines.add(line.replaceAll(r'\', r'\\').replaceAll("'", r"\'"));
      } else {
        // For non-code block content, apply additional optimizations
        var processedLine = line
            .replaceAll(r'\', r'\\')
            .replaceAll("'", r"\'")
            .replaceAll('\n', r'\n');

        // Remove excessive whitespace between elements
        processedLine = processedLine.replaceAll(RegExp(r'>\s+<'), '><');

        // Remove empty paragraphs
        if (processedLine != '<p></p>' && processedLine != '<p> </p>') {
          // Normalize spaces in class attributes
          processedLine = processedLine.replaceAll('  class="', ' class="');
          processedLines.add(processedLine);
        }
      }
    }

    return processedLines.join('\n').trim();
  }

  Future<String> processCodeBlock(String content, String? language) async {
    final buffer = StringBuffer();

    // Process the code block content
    buffer.writeln(
        '<pre><code${language != null ? ' class="language-$language"' : ''}>');

    // Process content line by line to preserve formatting
    for (final line in content.split('\n')) {
      buffer.writeln(_escapeHtml(line));
    }

    buffer.writeln('</code></pre>');

    return buffer.toString();
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }
}
