module Assets
  @cache = {}
  class << self
    def load_bitmap(folder_name, filename = " ", hue = 0)
      hue %= 360

      if filename != " "
        path = folder_name + filename
      else
        path = folder_name
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

    def skin(filename, hue = 0)
      self.load_bitmap("assets/skins/", filename, hue)
    end

    def windowskin(skin_name, hue = 0)
      key = [skin_name + "_windowskin", hue]
      return @cache[key] if @cache.include?(key) and not @cache[key].disposed?

      skin = self.skin(skin_name, hue)
      bitmap = Bitmap.new(192, 128)
      bitmap.blt(0, 0, skin, Rect.new(0, 0, 192, 128))
      @cache[key] = bitmap

      return @cache[key]
    end
  end
end
