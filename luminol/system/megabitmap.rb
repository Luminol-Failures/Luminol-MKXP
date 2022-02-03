class MegaBitmap
    attr_reader :width, :height, :rect, :disposed?
    def initialize(width, height)
        @width = width
        @height = height
        
        @rect = Rect.new(0, 0, width, height)
        @disposed? = false

        

        @bitmaps = []
        max_size = $system.max_tex_size
        raise "Only one axis can be greater than #{max_size}" if width > max_size && height > max_size
        (@height.to_f / max_size).ceil.times do |x|

        end
    end
end