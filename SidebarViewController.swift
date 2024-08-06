import Foundation
import AppKit

final class SidebarViewController: NSViewController {
    // Flat example data.
    private static let rootItem = ListItem.createFolder(leafsCount: 100_000,
                                                        folderIndex: 1,
                                                        leafStartIndex: 1)
    
    // Real-world example data with folder hierarchy.
//    private static let rootItem = ListItem(title: "Root", children: [
//        .createFolder(leafsCount: 25_000, folderIndex: 1, leafStartIndex: 1),
//        .createFolder(leafsCount: 25_000, folderIndex: 2, leafStartIndex: 25_001),
//        .createFolder(leafsCount: 25_000, folderIndex: 3, leafStartIndex: 50_001),
//        .createFolder(leafsCount: 25_000, folderIndex: 4, leafStartIndex: 75_001)
//    ])
    
    @IBOutlet private weak var outlineView: NSOutlineView!
    
    private var items: [ListItem] = SidebarViewController.rootItem.children ?? .init()
    
    var didSelectItem: ((_ item: ListItem?) -> Void)?
    
    private var selectedItem: ListItem? {
        didSet {
            didSelectItem?(selectedItem)
        }
    }
    
    init() {
        super.init(nibName: "SidebarView", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outlineView.delegate = self
        outlineView.dataSource = self
        
        outlineView.reloadData()
    }
    
    @IBAction private func buttonShuffle_action(_ sender: Any) {
        items = items.shuffled()
        outlineView.reloadData()
    }
}

extension SidebarViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, 
                     numberOfChildrenOfItem item: Any?) -> Int {
        if let listItem = item as? ListItem {
            if let children = listItem.children {
                return children.count
            } else {
                return 0
            }
        } else {
            return items.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, 
                     isItemExpandable item: Any) -> Bool {
        guard let listItem = item as? ListItem else {
            return false
        }
        
        return listItem.isFolder
    }
    
    func outlineView(_ outlineView: NSOutlineView, 
                     child index: Int,
                     ofItem item: Any?) -> Any {
        if let listItem = item as? ListItem {
            guard let children = listItem.children else {
                fatalError()
            }
            
            return children[index]
        }
        
        return items[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, 
                     viewFor tableColumn: NSTableColumn?,
                     item: Any) -> NSView? {
        guard let listItem = item as? ListItem else {
            fatalError()
        }
        
        let view = outlineView.makeView(withIdentifier: .init("DataCell"),
                                        owner: nil)
        
        guard let tableCellView = view as? NSTableCellView,
              let textField = tableCellView.textField,
              let imageView = tableCellView.imageView else {
            fatalError()
        }
        
        guard let image = NSImage(systemSymbolName: listItem.systemImage, accessibilityDescription: nil) else {
            fatalError()
        }
        
        textField.stringValue = listItem.title
        imageView.image = image
        
        return tableCellView
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard notification.object as? AnyObject === outlineView else {
            fatalError()
        }
        
        let row = outlineView.selectedRow
        let item = outlineView.item(atRow: row)
        
        let listItem = item as? ListItem
        
        self.selectedItem = listItem
    }
}
