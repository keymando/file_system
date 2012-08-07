class FileSystem < Plugin
  requires_version '1.1.4'
end

class FileSystem
  class << self
    def home
      explore(ENV['HOME'])
    end
    def root
      explore('/')
    end
    def explore(path)
      ExplorePath.new.run_using(FileSystemActionItem.new(path, path))
    end
  end
end


class FileSystemActionItem < DisplayItem; end

class FileSystemDispatch
  include Plugins::Dialogs

  def run_using(item)
    if item.is_a?(FileSystemActionItem)
      items = [
        DisplayItem.new(item.original, 'Open')
      ]
      trigger_item_with(items, LaunchItem.new)
    else
      ExplorePath.new.run_using(item)
    end
  end
end

class ExplorePath
  include Plugins::Dialogs

  def run_using(item)
    items = [FileSystemActionItem.new(item.original, '*** Actions ***')]
    items += Find.find(item.original,:depth => 1, :type => :any, :extension => '')
    trigger_item_with(items, FileSystemDispatch.new)                                                                                                                                                             
  end
end
