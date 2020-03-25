package catalina;

import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;
import haxe.macro.Expr;

using haxe.macro.Tools;

enum abstract CopyMode(String) {
  var Shallow;
  var Deep;
}

@:keep
class AssetManagement {
  public static function copy(copyMode: CopyMode, srcPath: Path, dstPath: Path) {
    if (!FileSystem.exists(dstPath.toString())) {
      FileSystem.createDirectory(dstPath.toString());
    }

    for (entry in FileSystem.readDirectory(srcPath.toString())) {
      var currentPath = new Path(Path.join([srcPath.toString(), entry]));
      var newPath = new Path(Path.join([dstPath.toString(), entry]));

      if (copyMode == CopyMode.Deep && FileSystem.isDirectory(currentPath.toString())) {
        AssetManagement.copy(CopyMode.Deep, currentPath, newPath);
      } else {
        trace('Found: $currentPath');
        File.copy(currentPath.toString(), newPath.toString());
      }
    }
  }

  public static function copyDirectory(srcDirectory: String, dstDirectory: String) {
    var srcPath = new Path(srcDirectory);
    var dstPath = new Path(dstDirectory);

    trace('Copying all files in ${srcPath} to ${dstPath}...');
    AssetManagement.copy(CopyMode.Deep, srcPath, dstPath);
    trace('Done.');
  }
}
