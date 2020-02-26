<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#installer"></a>

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
| :-------------: | :-------------: | :-------------: |
| name |  A unique name of this rule.   |  none |
| data |  Targets to be installed. File names will not be changed.   |  none |
| compilation_mode |  If not empty, sets compilation_mode of targets in data.   |  <code>"opt"</code> |
| executable |  If True, the copied files will be set as executable.   |  <code>True</code> |
| target_subdir |  Optional subdir under the prefix where the files will be                placed.   |  <code>""</code> |


