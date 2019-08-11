The [PlantUML Standard Library](http://plantuml.com/stdlib) makes it possible to use popular icons in PlantUML with zero effort.

The [plantuml-stdlib](https://github.com/plantuml/plantuml-stdlib) code as based on other projects.

As there were changes in some of those repos that were not (yet) in plantuml-stdlib, I decided to open some merge-requests to update things.

Because I don't like to do thnings manually that could be automated, I spend some time creating two BASH scripts:

- [`check-sources-for-update.sh`](./check-sources-for-update.sh)
- [`update_sources.sh`](./update_sources.sh)

The first script checks if there are updates for the libraries in the plantuml-stdlib codebase.
The second updates all the libraries in the plantuml-stdlib codebase.

## `check-sources-for-update.sh`

To use this script, make sure there is an up-to-date version of the `plantuml-stdlib` git repository locally.

Then point the script to the `plantuml-stdlib` code base:

```bash
bash ./check-sources-for-update.sh /path/to/plantuml-stdlib/
```
This will then output whether each project has an update available or not.

## `update_sources.sh`

To use this script, make sure there is an up-to-date version of the `plantuml-stdlib` git repository locally.

The `sources.config` file is also needed.

Next point the script to the `plantuml-stdlib` code base:

```bash
bash ./update_sources.sh . /path/to/repos/ /path/to/sources.config
```

This will then checkout or update all the other project git repositories and copy all the relevant files from those projects into the `plantuml-stdlib` code base.
It does this based on information from the config file.

The changes in `plantuml-stdlib` can then be seen using `git status`, added using `git add`. comitted with `git commit`, etc.

