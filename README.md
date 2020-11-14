The [PlantUML Standard Library](http://plantuml.com/stdlib) makes it possible to use popular icons in PlantUML with zero effort.

The [plantuml-stdlib](https://github.com/plantuml/plantuml-stdlib) code is based on other projects.

As there were changes in some of those repos that were not (yet) in plantuml-stdlib, I decided to open some merge-requests to update things. []()

Because I don't like to do things manually that could be automated, I spend some time creating two BASH scripts:

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

![screenshot-check-sources-for-update](https://gist.githubusercontent.com/Potherca/d52275853c3fb46e8244616676790b80/raw/screenshot-check-sources-for-update.png)

## `update_sources.sh`

To use this script, make sure there is an up-to-date version of the `plantuml-stdlib` git repository locally.

The `sources.config` file is also needed.

Next point the script to the `plantuml-stdlib` code base:

```bash
bash ./update_sources.sh /path/to/plantuml-stdlib/ /path/to/repos/ /path/to/sources.config
```

This will then checkout or update all the other project git repositories and copy all the relevant files from those projects into the `plantuml-stdlib` code base.
It does this based on information from the config file.

![screenshot-update_sources](https://gist.githubusercontent.com/Potherca/d52275853c3fb46e8244616676790b80/raw/screenshot-update_sources.png)

The changes in `plantuml-stdlib` can then be seen using `git status`, added using `git add`. comitted with `git commit`, etc.

## Adding a new library

As it might not be clear, I also created [a "simple" tutorial explaining how to add an icon library](./how-to-add-an-icon-library.md).
