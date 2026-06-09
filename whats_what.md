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
  - logic:
  1. 
  2. 
  3. 

## 2. Change exit_gates into portals
  - now: when a player goes to the next level, they can't go back to where they started
  - future: a player should be able to go back to previous maps (maybe as a way to access libellum or orbs that were spwned later ?)
  - logic:
  1. add trigger_tiles (portals) and spawn co-ordinates for each level => level_data.rb
  2. need to track unlocked_levels, as well as collected orbs and libellum (arrays?) => initiate and update => use in open_levels method that'll keep tracj of which worlds and portals should be open as well as which orbs and libellum should not be spawned again
  3. udate load_mundum to accept spawn co-oridinates 
  4. add method to open the levels that should be open
  5. add method (revise novam_viam) to accoutn for portals (atm, just exit_gate)
  6. Check and debug (did you miss anything??)
