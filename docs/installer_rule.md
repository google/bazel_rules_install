<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Installer Rules

Skylark rules for installing files using Bazel.

<a id="installer"></a>

## installer

<pre>
installer(<a href="#installer-name">name</a>, <a href="#installer-data">data</a>, <a href="#installer-compilation_mode">compilation_mode</a>, <a href="#installer-executable">executable</a>, <a href="#installer-target_subdir">target_subdir</a>)
</pre>

Creates an installer

This rule creates an installer for targets in data. Running the installer
copies built targets to a given prefix. The prefix has to be passed as an
argument to the installer.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="installer-name"></a>name |  A unique name of this rule.   |  none |
| <a id="installer-data"></a>data |  Targets to be installed. File names will not be changed.   |  none |
| <a id="installer-compilation_mode"></a>compilation_mode |  If not empty, sets compilation_mode of targets in data.   |  `"opt"` |
| <a id="installer-executable"></a>executable |  If True, the copied files will be set as executable.   |  `True` |
| <a id="installer-target_subdir"></a>target_subdir |  Optional subdir under the prefix where the files will be placed.   |  `""` |


