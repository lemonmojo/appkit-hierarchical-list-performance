import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    
    let sidebarViewController = SidebarViewController()
    let contentViewController = ContentViewController()
    
    let splitViewController = NSSplitViewController()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let contentView = window.contentView else {
            fatalError()
        }
        
        sidebarViewController.didSelectItem = { [weak self] item in
            guard let self else { return }
            
            self.contentViewController.item = item
        }
        
        splitViewController.view.frame = contentView.bounds
        splitViewController.view.autoresizingMask = [ .minXMargin, .maxXMargin, .minYMargin, .maxYMargin, .width, .height ]
        
        let sidebarSplitViewItem = NSSplitViewItem(sidebarWithViewController: sidebarViewController)
        splitViewController.addSplitViewItem(sidebarSplitViewItem)
        
        let contentSplitViewItem = NSSplitViewItem(viewController: contentViewController)
        splitViewController.addSplitViewItem(contentSplitViewItem)
        
        contentView.addSubview(splitViewController.view)
    }
}
