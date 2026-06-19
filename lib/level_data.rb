module LevelData
  LEVELS = {
    1 => {
      orbes: [
        { x: 5, y: 3, verbum: 'cano' },
        { x: 12, y: 5, verbum: 'verum' },
        { x: 4, y: 15, verbum: 'et' },
        { x: 1, y: 28, verbum: 'one' },
        { x: 7, y: 21, verbum: 'two' },
        { x: 23, y: 21, verbum: 'three' },
        { x: 24, y: 19, verbum: 'four' },
        { x: 48, y: 5, verbum: 'five' },
        { x: 18, y: 12, verbum: 'sux' },
        { x: 32, y: 23, verbum: 'seven' },
        { x: 9, y: 16, verbum: 'eight' },
        { x: 48, y: 24, verbum: 'nine' },
        { x: 3, y: 11, verbum: 'ten' },
        { x: 29, y: 1, verbum: 'elf' },
        { x: 15, y: 24, verbum: 'twaalf' },
        { x: 27, y: 23, verbum: 'dertien' },
        { x: 20, y: 12, verbum: 'veertien' },
        { x: 47, y: 15, verbum: 'vyftien' },
        { x: 20, y: 12, verbum: 'sesien' },
        { x: 47, y: 15, verbum: 'sewentien' }
      ],
      libellum: {x: 29, y: 20, title: "Scroll I", text: "Arma virumque canō"},
      portals: [
        {
        x: 0, y: 7,
        target_level: 2,
        spawn_x: 63, spawn_y: 7 
        }
      ]
    },
    2 => {
      orbes: [
        { x: 5, y: 3, verbum: 'cano' },
        { x: 12, y: 5, verbum: 'verum' },
        { x: 3, y: 15, verbum: 'et' },
        { x: 23, y: 22, verbum: 'arma' },
      ],
      libellum: {x: 29, y: 20, title: "Scroll II", text: "Arma virumque canō"},
      portals: [
        {
        x: 63, y: 7,
        target_level: 1,
        spawn_x: 1, spawn_y: 7 
        },
        {
        x: 0, y: 7,
        target_level: 3,
        spawn_x: 63, spawn_y: 7 
        }
      ]
    },
    3 => {
      orbes: [
        { x: 5, y: 3, verbum: 'cano' },
        { x: 12, y: 5, verbum: 'verum' },
        { x: 3, y: 15, verbum: 'et' },
        { x: 23, y: 21, verbum: 'arma' },
      ],
      libellum: {},
      portals: [
        {
        x: 63, y: 7,
        target_level: 1,
        spawn_x: 1, spawn_y: 7 
        },
        {
        x: 0, y: 7,
        target_level: 4,
        spawn_x: 50, spawn_y: 8 
        }
      ]
    }
  }
end