import Foundation
import AppKit

final class ContentViewController: NSViewController {
    @IBOutlet private weak var textFieldLabel: NSTextField!
    @IBOutlet private weak var imageView: NSImageView!
    
    var item: ListItem? {
        didSet {
            let text: String
            let imageName: String
            
            if let item {
                text = "Selected item: \(item.title)"
                imageName = item.systemImage
            } else {
                text = "No item selected"
                imageName = "info.circle"
            }
            
            guard let image = NSImage(systemSymbolName: imageName, accessibilityDescription: nil) else {
                fatalError()
            }
            
            textFieldLabel.stringValue = text
            imageView.image = image
        }
    }
    
    init() {
        super.init(nibName: "ContentView", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
