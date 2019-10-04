class FileStatus {
	final int _value;
	
	const FileStatus._internal(this._value);
	
	int get value => _value;
	
	get hashCode => _value;
	
	operator ==(status) => status._value == this._value;
	
	toString() => 'FileStatus($_value)';
	
	static FileStatus from(int value) =>
			FileStatus._internal(value);
	
	static const undefined = const FileStatus._internal(0);
	static const playing = const FileStatus._internal(1);
	static const pause = const FileStatus._internal(2);
	static const stop = const FileStatus._internal(3);
	static const ready = const FileStatus._internal(4);
}