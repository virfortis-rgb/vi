# Things to know
## Map Things (tileset):
- path (1)              => 0
- path_grass (1)        => 1
- path_floor (1)        => 2
- wall_left (1)         => 3
- wall_right (1)        => 4
- wall_top (1)          => 5
- wall_bottom (1)       => 6
- wall_single (1)       => 7
- tree_one (1)          => 8
- tree_two (1)          => 9

## **** Map CSV file names should use the following format: mundus_{number of level}.csv****
## **** e.g. mundus_1.csv, mundus_200.csv ****

## Lucius Thigs
### Donkey:
- idle (2)
- walk (4)

### Man:
- idle (2)
- walk (4)

## Modal Things
- Orbs board (1)
- Libellum board (1)

## UI Things
- General pop-up (need sprite? Just dark bg?)
- Intro boards
- 

# TODO
## 1. Orbs Protectors
  - not enemies, bt entities that defend the orbs so that are slightly more difficult to get
  - walk arounf their orbs to protect it 
  - logic: TODO

## 2. Story
  - Intro to story

## 3. Main Menu
  - Start game
  - Load saved game
  - Exit
  - logic:
  1. initialize game with menu state
  2. menu options (atm 2)
  3. state_manager: if :menu, up-down changes selected option
                              space/enter activates sequence
                                 1. start game - change state to explore
                                 2. exit game - read docs - trigger close in main.rb