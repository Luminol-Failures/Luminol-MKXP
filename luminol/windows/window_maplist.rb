require_relative "../window_base/window_draggable"
require_relative "../window_base/widgets/filepicker"
require_relative "../window_base/widgets/scroller"
require_relative "../window_base/widgets/tree"
require_relative '../subscribers/project'
require_relative '../window_base/widgets/treenode'

class Window_MapList < Window_Draggable
    def initialize
        icon = $system.button(:file)
        super(0, 0, 240, 240, "Map List", icon)

        # [NOTE] | Remove test Tree widget.
        root_node = TreeNode.new("Project", nil)

        start_node = TreeNode.new("START", nil)

        root_node.add_child(start_node)
        @tree = Tree.new(
            Rect.new(0, 0, self.width - 32, self.height),
            root_node
        )
        @scroller = Scroller.new(
            Rect.new(0, 0, self.width - 32 - $system.scrollbar_width, self.height - 32),
        )
        @scroller.add_widget(@tree)

        self.add_widget(:rightscroller, @scroller)
        self.close
    end
end