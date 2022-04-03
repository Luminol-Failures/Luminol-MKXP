# https://github.com/Luminol-Editor/Luminol/wiki/Widget-design-principles

require_relative 'widget'

class Tree < Widget
    # Accessors.
    attr_reader :rect

    # Methods.
    def initialize(rect, options)
        super rect, options
        
        @rect = rect
        @items = options
    end

    def update(window)
        return unless super window

        @selected = mouse_inside_widget?(window)

        if MKXP.mouse_in_window
            mx, my = get_mouse_pos(window)
        end
    end

    def process_loop(root, bitmap)
        if !root.kind_of?(Array)
            root = [root]
        end
        root.each { |e| 
            puts "Rendering map item:\n\tName: #{e.to_s}\n\tHeight: #{@i}\n\tLayer: #{@layer}"
            bitmap.draw_text(self.x + (@layer * 10), self.y + 10, width, @i, e.to_s)
            @i += 50
            if !e.nil? && e.children.length > 0
                self.process_loop(e.children, bitmap)
            end
        }
        @layer += 1

        # [NOTE] | NOTICE OF CODE SUSPENSION
        # This code was looping through array of hashes
        # but there's no need for it now, since TreeNode class
        # exists, feel free to look at nightmare code.
        #     -somedevfox
        #marray.each { |e| 
            # this DOESN'T SUCK
        #    puts "Rendring map item:\n\tName: #{e[:name]}\n\tHeight: #{@i}"
        #    bitmap.draw_text(self.x + (@layer * 10), self.y + 10, width, @i, e[:name])
        #    @i += 50

        #    if e[:child_maps] != [] && e[:child_maps] != nil
        #        @layer += 1
        #        self.process_loop(e[:child_maps], bitmap)
        #    end

            # this DOES SUCK
            # why in the everloving god did i produce this?
            # uncomment for chaos
            # obsolete now btw
            #  -somedevfox
            #e[:child_maps].each { |c| 
            #    bitmap.draw_text(self.x + 20, self.y + 50, width, @i + 50, c[:name])
            #    puts "Child Element: " + c[:name]
            #    if c[:child_maps] != [] && c[:child_maps] != nil
            #        self.process_loop(c[:child_maps], bitmap)
            #    else puts "Finishing child loop"
            #    end
            #}
        #}
    end

    def draw(bitmap)
        return unless super bitmap

        @i = 25
        @layer = 1

        puts "Drawing tree"
        bitmap.font = Font.new("Terminus (TTF)", 18)
        self.process_loop(@items, bitmap)

        puts "Tree: Rendering Complete"
    end
end