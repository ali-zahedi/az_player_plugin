import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

typedef void UtilitiesCallback();

class Utilities {
	static Utilities _instance = Utilities._();
	UtilitiesCallback _callback;
	bool _isLoadCompleted = false;
	
	String _currentPath;
	
	String get currentPath {
		return this._currentPath;
	}
	
	String get securePath {
		return this._currentPath;
	}
	
	Utilities._() {
		this._getCurrentPath().then((elem) {
			this._currentPath = elem;
			this._isLoadCompleted = true;
			this._callback();
		});
	}
	
	factory Utilities() {
		return Utilities._instance;
	}
	
	factory Utilities.withCallback(UtilitiesCallback callback) {
		Utilities._instance._callback = callback;
		if (Utilities._instance._isLoadCompleted) {
			Utilities._instance._callback();
		}
		return Utilities._instance;
	}
	
	Future<String> _getCurrentPath() async {
		String directory;
		if (Platform.isWindows || Platform.isMacOS) {
			directory = dirname(Platform.script.toString());
		} else {
			var appDirectory = await getApplicationDocumentsDirectory();
			directory = appDirectory.path;
		}
		return directory;
	}
	
	String joinPath(String part1, String part2) {
		return join(part1, part2);
	}
	
	/// File
	// exist
	Future<bool> exists(String path) async {
		return await File(path).exists();
	}
	
}
