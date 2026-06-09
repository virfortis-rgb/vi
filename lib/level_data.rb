module LevelData
  LEVELS = {
    1 => {
      orbes: [
        { x: 5, y: 3, verbum: 'cano' },
        { x: 12, y: 5, verbum: 'verum' },
        { x: 3, y: 15, verbum: 'et' },
        { x: 23, y: 21, verbum: 'arma' },
      ],
      libellum: {x: 29, y: 20, title: "Vergelii Aeneas", text: "Arma virumque canō"},
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
        target_level: 2,
        spawn_x: 50, spawn_y: 8 
        }
      ]
    }
  }
end

# TODO: add map info?? and refactor accordingly