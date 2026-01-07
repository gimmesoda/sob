import sys.io.File;
import sys.FileSystem;
import sys.io.Process;
import haxe.io.Path;

using StringTools;

final args:Array<String> = Sys.args();

function main()
{
	final workingDirectory:String = args.pop();

	while (args.length > 0)
		switch args.shift() {
			case 'new':
				final projectName:String = args.shift();
				copyDirectoryUnsafe('template', Path.join([workingDirectory, projectName]));
				return;
		}

	final lua:Process = new Process('bin/win32/lua54', [Path.join([workingDirectory, 'sobfile.lua']), workingDirectory]);
	lua.exitCode();
	Sys.stderr().write(lua.stderr.readAll());
}

function copyDirectoryUnsafe(src:String, dest:String)
{
  if (FileSystem.exists(dest))
		throw 'Cannot create new project in $dest';

	FileSystem.createDirectory(dest);

  for (item in FileSystem.readDirectory(src)) {
    final srcPath:String = haxe.io.Path.join([src, item]);
    final destPath:String = haxe.io.Path.join([dest, item]);

    if (FileSystem.isDirectory(srcPath))
      copyDirectoryUnsafe(srcPath, destPath);
    else
      File.copy(srcPath, destPath);
  }
}
