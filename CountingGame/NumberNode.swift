import SpriteKit

class NumberNode: SKSpriteNode {

    var numberValue: Int = 0 // To store the actual number (1-10)
    var originalPosition: CGPoint = .zero // To snap back if not placed correctly (optional)
    var isBeingDragged: Bool = false

    // Initializer to create a number node with a specific number
    convenience init(number: Int, texture: SKTexture?, color: UIColor, size: CGSize) {
        self.init(texture: texture, color: color, size: size)
        self.numberValue = number
        self.isUserInteractionEnabled = true // Enable touch handling

        // Create a label node to display the number
        let label = SKLabelNode(text: "\(number)")
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = size.height * 0.6
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        addChild(label)
        
        // MARK: - Add Border
        let borderWidth: CGFloat = 4.0 // Adjust border thickness as needed
        let borderColor: SKColor = .black // Adjust border color as needed

        let borderRect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        let borderPath = CGPath(rect: borderRect, transform: nil)

        let border = SKShapeNode(path: borderPath)
        border.strokeColor = borderColor
        border.lineWidth = borderWidth
//        border.antialiasingMode = .none  For sharper lines, consider .none or .subpixel
        addChild(border)
        // MARK: - End Add Border
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        originalPosition = self.position // Store original position if needed
        isBeingDragged = true
        self.zPosition = 100 // Bring to front when dragging
        self.setScale(1.1) // Slightly enlarge when picked up
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isBeingDragged, let touch = touches.first, let parent = self.parent else { return }
        let location = touch.location(in: parent)
        self.position = location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeingDragged = false
        self.zPosition = 0 // Reset zPosition
        self.setScale(1.0) // Reset scale
        // Notify the GameScene that a drag has ended
        if let gameScene = self.scene as? GameScene {
            gameScene.numberNodeDidEndDrag(self)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event) // Treat cancel as end
    }
}


