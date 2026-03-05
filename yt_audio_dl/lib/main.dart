import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(const YtAudioDownloaderApp());
}

class YtAudioDownloaderApp extends StatelessWidget {
  const YtAudioDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Audio Downloader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const DownloaderPage(title: 'YouTube Audio Downloader'),
    );
  }
}

class DownloaderPage extends StatefulWidget {
  const DownloaderPage({super.key, required this.title});

  final String title;

  @override
  State<DownloaderPage> createState() => _DownloaderPageState();
}

class _DownloaderPageState extends State<DownloaderPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _dirController = TextEditingController();
  
  String _selectedFormat = 'mp3';
  final List<String> _formats = ['mp3', 'wav', 'flac', 'm4a', 'aac'];

  String _selectedQuality = '320K';
  final List<String> _qualities = ['320K', '256K', '192K', '128K', '64K', '0 (best VBR)'];

  String _status = '';
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    final home = Platform.environment['HOME'] ?? '';
    _dirController.text = home.isNotEmpty ? '$home/Music' : '~/Music';
  }

  Future<void> _startDownload() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _status = 'Error: Please enter a valid YouTube URL.';
      });
      return;
    }

    setState(() {
      _isDownloading = true;
      _status = 'Downloading...';
    });

    final dirPath = _dirController.text.trim();
    final outputTemplate = '$dirPath/%(title)s.%(ext)s';
    
    // Parse quality
    String qualityArg = _selectedQuality == '0 (best VBR)' ? '0' : _selectedQuality;

    try {
      final process = await Process.start(
        'yt-dlp',
        [
          '-x',
          '--audio-format',
          _selectedFormat,
          '--audio-quality',
          qualityArg,
          '-o',
          outputTemplate,
          url,
        ],
      );

      // We can optionally read stdout and stderr to show progress
      process.stdout.transform(SystemEncoding().decoder).listen((data) {
        debugPrint(data);
      });
      process.stderr.transform(SystemEncoding().decoder).listen((data) {
        debugPrint(data);
      });

      final exitCode = await process.exitCode;
      
      setState(() {
        if (exitCode == 0) {
          _status = 'Success! Downloaded to $_selectedFormat.';
        } else {
          _status = 'Failed with exit code: $exitCode. See terminal for details.';
        }
        _isDownloading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isDownloading = false;
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _dirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'YouTube Video URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Audio Format',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedFormat,
                    items: _formats.map((format) {
                      return DropdownMenuItem(
                        value: format,
                        child: Text(format.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: _isDownloading
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() => _selectedFormat = val);
                            }
                          },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Audio Quality',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedQuality,
                    items: _qualities.map((quality) {
                      return DropdownMenuItem(
                        value: quality,
                        child: Text(quality),
                      );
                    }).toList(),
                    onChanged: _isDownloading
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() => _selectedQuality = val);
                            }
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dirController,
              decoration: const InputDecoration(
                labelText: 'Output Directory',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isDownloading ? null : _startDownload,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isDownloading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Download', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            Text(
              _status,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _status.startsWith('Error') || _status.startsWith('Failed')
                    ? Colors.red
                    : Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
