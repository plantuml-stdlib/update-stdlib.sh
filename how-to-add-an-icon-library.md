# How to add an icon library

The steps to add an icon library are:

1. Generate PlantUML sprite files
2. Put all of the sprites in a repo
3. Open an MR here to get the sprite repo included into stdLib
   - Including an `INFO` file

## 1. Generate PlantUML sprite files

Generating`.puml` files from a bunch of SVGs can be done using `plantuml.jar -encodesprite`<sup>1</sup>

It is quite common for icon-sets to either exist out of SVGs or be generated from SVGs, so source SVGs are often already available.

Figuring out which settings to use with `encodesprite` can take some trial-and-error.<sup>2</sup> 

I remember looking into https://github.com/tupadr3/font-icon-generator but I can really remember how things work, so for now [YMMV](https://en.wiktionary.org/wiki/your_mileage_may_vary).

## 2. Put all of the sprites in a repo

Once you have a bunch of generated `.puml` files, it is a good idea to create a common/main file that includes all the sprites, to save users the hassle of having to load each sprite individually.<sup>3</sup>

Adding a README explaining things a bit is also a good move.

## 3. Open an MR here to get the sprite repo included into stdLib

To add an icon library to this project (i.e.e the PlantUML stdLib), open a merge request with:<sup>4</sup>

- A folder containing all of your PlantUML sprite files
- An entry to README file
- An `INFO` file
 
### Including an `INFO` file

The `INFO` file should contain the version (i.e. the git tag or github release) of the icon-set you are adding and the source repo.

For instance:

```
VERSION=1.2.0
SOURCE=https://github.com/path-to/project
```

If the _source_ repo tags newer versions when things change, updating things here can be automated.<sup>5</sup>

In the long run, it _could_ even be possible to add/update icon-sets here without an intermediary repo, but for now, this is how it is done.

## Footnotes

1. To quote [the manual entry on sprites](https://plantuml.com/sprite):
   > To encode sprite, you can use the command line like: `java -jar plantuml.jar -encodesprite 16z foo.png` where `foo.png` is the image file you want to use (it will be converted to gray automatically). After `-encodesprite`, you have to specify a format: `4`, `8`, `16`, `4z`, `8z` or `16z`. The number indicates the gray level and the optional `z` is used to enable compression in sprite definition.

2. This [blog post by Hubert Klein Ikkink](https://mrhaki.blogspot.com/2017/10/plantuml-pleasantness-creating-our-own.html) might be of some help

3. Look at existing sprite sets for inspiration

4. A good example of this is [#18](https://github.com/plantuml/plantuml-stdlib/pull/18/files?file-filters%5B%5D=.md&file-filters%5B%5D=No+extension) 

5. That is in fact what I have been doing for all MRs opened for this ticket