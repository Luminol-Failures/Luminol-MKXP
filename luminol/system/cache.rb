module RPG
  module Cache
    @cache = {}
    def self.load_bitmap(folder_name, filename = " ", hue = 0)
      hue %= 360

      if filename != " "
        path = $system.working_dir + folder_name + filename
      else
        path = $system.working_dir + folder_name
      end

      if not @cache.include?(path) or @cache[path].disposed?
        if filename != ""
          @cache[path] = Bitmap.new(path)
        else
          @cache[path] = Bitmap.new(32, 32)
        end
      end
      if hue == 0
        @cache[path]
      else
        key = [path, hue]
        if not @cache.include?(key) or @cache[key].disposed?
          @cache[key] = @cache[path].clone
          @cache[key].hue_change(hue)
        end
        @cache[key]
      end
    end
    def self.animation(filename, hue)
      self.load_bitmap("Graphics/Animations/", filename, hue)
    end
    def self.autotile(filename)
      self.load_bitmap("Graphics/Autotiles/", filename)
    end
    def self.battleback(filename)
      self.load_bitmap("Graphics/Battlebacks/", filename)
    end
    def self.battler(filename, hue)
      self.load_bitmap("Graphics/Battlers/", filename, hue)
    end
    def self.character(filename, hue)
      self.load_bitmap("Graphics/Characters/", filename, hue)
    end
    def self.fog(filename, hue)
      self.load_bitmap("Graphics/Fogs/", filename, hue)
    end
    def self.gameover(filename)
      self.load_bitmap("Graphics/Gameovers/", filename)
    end
    def self.icon(filename)
      self.load_bitmap("Graphics/Icons/", filename)
    end
    def self.panorama(filename, hue)
      self.load_bitmap("Graphics/Panoramas/", filename, hue)
    end
    def self.picture(filename)
      self.load_bitmap("Graphics/Pictures/", filename)
    end
    def self.tileset(filename)
      self.load_bitmap("Graphics/Tilesets/", filename)
    end
    def self.title(filename)
      self.load_bitmap("Graphics/Titles/", filename)
    end
    def self.windowskin(filename)
      self.load_bitmap("Graphics/Windowskins/", filename)
    end
    def self.tile(filename, tile_id, hue)
      key = [filename, tile_id, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = Bitmap.new(32, 32)
        x = (tile_id - 384) % 8 * 32
        y = (tile_id - 384) / 8 * 32
        rect = Rect.new(x, y, 32, 32)
        @cache[key].blt(0, 0, self.tileset(filename), rect)
        @cache[key].hue_change(hue)
      end
      @cache[key]
    end
    def self.clear
      @cache = {}
      GC.start
    end

    AUTOTILE_CONFIG = [
      [26, 27, 32, 33],
      [4, 27, 32, 33],
      [26, 5, 32, 33],
      [4, 5, 32, 33],
      [26, 27, 32, 11],
      [4, 27, 32, 11],
      [26, 5, 32, 11],
      [4, 5, 32, 11],
      [26, 27, 10, 33],
      [4, 27, 10, 33],
      [26, 5, 10, 33],
      [4, 5, 10, 33],
      [26, 27, 10, 11],
      [4, 27, 10, 11],
      [26, 5, 10, 11],
      [4, 5, 10, 11],
      [24, 25, 30, 31],
      [24, 5, 30, 31],
      [24, 25, 30, 11],
      [24, 5, 30, 11],
      [14, 15, 20, 21],
      [14, 15, 20, 11],
      [14, 15, 10, 21],
      [14, 15, 10, 11],
      [28, 29, 34, 35],
      [28, 29, 10, 35],
      [4, 29, 34, 35],
      [4, 29, 10, 35],
      [38, 39, 44, 45],
      [4, 39, 44, 45],
      [38, 5, 44, 45],
      [4, 5, 44, 45],
      [24, 29, 30, 35],
      [14, 15, 44, 45],
      [12, 13, 18, 19],
      [12, 13, 18, 11],
      [16, 17, 22, 23],
      [16, 17, 10, 23],
      [40, 41, 46, 47],
      [4, 41, 46, 47],
      [36, 37, 42, 43],
      [36, 5, 42, 43],
      [12, 17, 18, 23],
      [12, 13, 42, 43],
      [36, 41, 42, 47],
      [16, 17, 46, 47],
      [12, 17, 42, 47],
      [0, 1, 6, 7],
    ]

    def self.autotile_tile(autotile_names, tile_id, hue)
      raise "Not an autotile you dingus!" if tile_id >= 384
      key = [autotile_names, tile_id, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = Bitmap.new(32, 32)
        if tile_id < 48
          return @cache[key]
        end
        autotile_num = tile_id / 48 - 1
        autotile_id = tile_id % 48

        return @cache[key] if autotile_num + 1 == 0
        return @cache[key] if autotile_names[autotile_num].nil?
        return @cache[key] if autotile_names[autotile_num] == ""

        autotile = RPG::Cache.autotile(autotile_names[autotile_num])

        autotile_corners = AUTOTILE_CONFIG[autotile_id]

        # Holy fuck
        2.times do |sA|
          2.times do |sB|
            ti = autotile_corners[sA + (sB * 2)]
            tx = (ti % 6)
            ty = (ti / 6)
            sX = sA * 16
            sY = sB * 16
            rect = Rect.new(tx * 16, ty * 16, 16, 16)
            @cache[key].blt(sX, sY, autotile, rect)
          end
        end
      end
      @cache[key]
    end
  end
end
