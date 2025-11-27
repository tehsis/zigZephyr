# Zephyr

Zephyr is a _game engine_ that allows fast iterations and experimentation providing a delightful declarative experience making it suitable for human coders and LLMs.



It does so by providing declarative means to build _scenes_ and levels via TOML and a Repl interface.

# Zephyr Repl

```
>> add scene
scene_1 created
[scene_1] >> add square x:25 y:26 color:red 
square_1 created in scene_1
[square_1] >> add controller player.lua
controller player.lua added to square_1
[square_1] >> save my_game.zph
my_game.zph created.
```

Each game in Zephyr is fully represented by a tree. By doing so, programming in Zephyr is fully declarative and allows your code to excel either written by a human or an LLM.

The previous snipped will generate the following tree:

```toml
[window.scene_1.square_1.transform]
x = 25
y = 26

[window.scene_1.square_1.controller]
src = "player.lua"
```

A game can have multiple windows (which corresponds a window manager window) but only one scene is active at a time.

controller scripts are used to modify the state. Zephyr won't actually care how you modify that state

eg.

```lua
-- player.lua
if key.press("arrow_left") then
    entity.transform.x = entity.transform.x - 1;
end

if key.press("arrow_right") then
    entity.transform.x = entity.transform.x + 1;
end
```
   
Zephyr eval loop reads that state and updates its representation.
