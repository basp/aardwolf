# Laly's Mapper
This is a no-nonsense mapping script for **Aardwolf** and **Mudlet** although it probably can be tweaked for any MUD that involves cardinal directions.

The main point of this mapping script is that it's extremely user friendly. Up to the point where it stops to be user friendly actually. The mapper's main focus is on **Aardwolf** and because of the complications we cannot try to be too smart. That's why this mapper offers two things:

* **Smart** commands to handle 90% of the mapping cases
* **Easy** commands to tweak your maps

The rest of this file will explain the various commands in more detail.

# Commands
## Overview
Below is an overview of the various commands that are currently supported as well as examples on how to use them.

### Smart
* `lautocoords` sets the current room's coordinates based on the previous room's coordinates and the last movement.
* `lautoexits` sets the current room's exits based on GMCP data.

### Tweaking
* `lareas` lists all areas known to the mapper
* `lcoords` lists the current room's coordinates
* `lcoords <x> <y> <z>` sets the current room's coordinates
* `lexits` lists the current room's exits
* `lexit <num> <direction>` sets an exit from the current room
* `lstubs` lists all the current room's exit stubs
* `lrmexits` removes all the current room's exits
* `lrmarea <area_name>` removes a known area

## Behavior
Whenever you enter a new area the mapper will assume the first room to be at coordinates `x, y, z = 0, 0, 0`. The mapper will automatically create areas and rooms. However, it does not automatically try to position (e.g. assign coordinates to) rooms so (for now) all the new rooms will be created at `0 0 0` position.

This means that if you run around with the mapper active, your map will be nonsense unless you use some of the commands. Your best friends will be `lautocoords` and `lautoexits` and these will cover most of your mapping cases.

## Cardinal directions
The auto-mapping features work on cardinal directions. The known cardinal directions are as follows:

* north `n`
* south `s`
* east `e`
* west `w`
* northeast `ne`
* northwest `nw`
* southeast `se`
* southwest `sw`
* up `u`
* down `d`

## Basic mapping
1. Once you enter a new area in Aardwolf the mapper will be at a room at coordinates `0 0 0` (the default for any area starting point). You should see some log messages about areas, rooms and exit stubs.
2. To start mapping just move in a cardinal direction (see above). 
3. Now that you moved one room you can use `lautocoords` to set your current room's coordinates based on the previous room and your movement. You should see your map update.
4. The mapper only creates so-called *exit stubs* to indicate any unmapped exits on the map. To create all known exits based on GMCP data you can use the `lautoexits` command.
5. Now you'll probably have some one-way exits on the map. To fix them you can return to the previous room and just run `lautoexits` again.
6. Rinse and repeat, mapping all easy cardinal exits. If you run into custom exits or maze-like rooms that you need to reposition you can always use the `lcoords` and `lexit` commands to tweak your map.
7. For really akward rooms you can just re-position them (if the map is divided) to some random far off position like `-20, -20` and continue mapping from there.
8. You can always re-map. Just use `lcoord <x> <y> <z>` to reposition your room and continue mapping from there using the `lautocoords` command. Exits will usually clean up automatically.

## Mapping tips
* I use mostly numpad to run around and have the keys macrod in Mudlet, this means my commands are not echoed on the command line.
* So in a new area, I just have `lautocoords` on the command line while I move around using numpad and executing the command in every room. This will give me a general layout of the map.
* If I need to tweak things I can use `lcoords <x> <y> <z>` in some funky room and continue automapping from there.
* If things get a real mess I just `lrmarea <area_name>` and try again but usually you can just get away with using `lautocoords` and `lautoexits` if you take care with your movements.
* Once I got the general layout as I want it, I move around again and connect up the exits using `lautoexits` in ever room.
* You can always use `lexit <room_id> <direction>` to add custom exits.