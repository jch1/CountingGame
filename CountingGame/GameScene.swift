import SpriteKit
import GameplayKit // For shuffling

class GameScene: SKScene {

    private var numberNodes: [NumberNode] = []
    private var targetSlots: [CGRect] = []
    private var placedNumbers: [NumberNode?] = Array(repeating: nil, count: 10)
    private var lineNode: SKShapeNode!

    let numbersToCount: Int = 20
    let numbersPerLine: Int = 10
    let slotSize = CGSize(width: 64, height: 64) // Adjust as needed
    let spacing: CGFloat = 20 // Spacing between slots

    override func didMove(to view: SKView) {
        setupGame()
    }

    func setupGame() {
        // Clear previous game elements if any
        removeAllChildren()
        numberNodes.removeAll()
        placedNumbers = Array(repeating: nil, count: numbersToCount)
        targetSlots.removeAll()

        backgroundColor = .lightGray // Or any other fun color

        // 1. Create the target line and slots
        setupTargetLine()

        // 2. Create and position number nodes
        createNumberNodes()

        // 3. Shuffle and display numbers
        shuffleAndDisplayNumbers()
    }

    func setupTargetLine() {
//        let totalLineWidth = (slotSize.width * CGFloat(numbersToCount)) + (spacing * CGFloat(numbersToCount - 1))
        let totalLineWidth = (slotSize.width * CGFloat(numbersPerLine)) + (spacing * CGFloat(numbersPerLine - 1))
        let lineYPosition = frame.minY + 3 * slotSize.height * 1.5 // Position at the bottom
        let startX = frame.midX - totalLineWidth / 2
        let startY = lineYPosition - slotSize.height / 2
        print("asdfasdfasdfasdf")
        print("lineYPosition \(lineYPosition)")
        print("frame.minY \(frame.minY)")
        print("frame.minY \(frame.maxY)")
        print("frame.minX \(frame.minX)")
        print("frame.minX \(frame.maxX)")
        
        print("frame.midX \(frame.midX)")
        print("scene anchor: \(self.anchorPoint)")
        print("totalLineWidth \(totalLineWidth)")
        print("scalemode: \(scaleMode)")

        lineNode = SKShapeNode()
        let pathToDraw = CGMutablePath()

        for i in 0..<numbersToCount {
            let xpos = i % numbersPerLine
            let ypos = i / numbersPerLine
            let slotX = startX + (slotSize.width + spacing) * CGFloat(xpos)
            let slotY = startY - (slotSize.height + spacing) * CGFloat(ypos)
//            let slotRect = CGRect(x: slotX, y: lineYPosition - slotSize.height / 2, width: slotSize.width, height: slotSize.height)
            let slotRect = CGRect(x: slotX, y: slotY, width: slotSize.width, height: slotSize.height)
            targetSlots.append(slotRect)

            // Draw visual representation of slots (optional)
            let slotShape = SKShapeNode(rect: slotRect, cornerRadius: 5)
            slotShape.strokeColor = .darkGray
            slotShape.lineWidth = 3
            addChild(slotShape)

            if i < numbersToCount - 1 {
                 pathToDraw.move(to: CGPoint(x: slotX + slotSize.width + spacing / 2, y: lineYPosition))
                 pathToDraw.addLine(to: CGPoint(x: slotX + slotSize.width + spacing / 2, y: lineYPosition - 5)) // Little tick marks
            }
        }

        // Draw the main line (optional, as slots might be enough)
//        let mainLinePath = UIBezierPath()
//        mainLinePath.move(to: CGPoint(x: startX + slotSize.width / 2, y: lineYPosition))
//        mainLinePath.addLine(to: CGPoint(x: startX + totalLineWidth - slotSize.width / 2, y: lineYPosition))
//        lineNode.path = mainLinePath.cgPath
//        lineNode.strokeColor = .red
//        lineNode.lineWidth = 10
//        addChild(lineNode) // Add if you want a continuous line
        
////        let lineNode = SKShapeNode()
//        let startPoint = CGPoint(x: 0, y: 0)
//        let endPoint = CGPoint(x: 0, y: -500)
//        let mainLinePath = CGMutablePath()
//        mainLinePath.move(to: startPoint)
//        mainLinePath.addLine(to: endPoint)
//        
//        let xxx = CGPoint(x: startX + slotSize.width / 2, y: lineYPosition)
//        let yyy = CGPoint(x: startX + totalLineWidth - slotSize.width / 2, y: lineYPosition)
//        print("xxx: \(xxx)")
//        print("yyy: \(yyy)")
////        mainLinePath.move(to: CGPoint(x: startX + slotSize.width / 2, y: lineYPosition))
////        mainLinePath.addLine(to: CGPoint(x: startX + totalLineWidth - slotSize.width / 2, y: lineYPosition))
//        lineNode.path = mainLinePath
//        lineNode.strokeColor = .red
//        lineNode.lineWidth = 5
//        addChild(lineNode)
        
    }

    func createNumberNodes() {
        for i in 1...numbersToCount {
            // You can use SKTexture for images or SKShapeNode with SKLabelNode for simple blocks
            let numberNode = NumberNode(number: i, texture: nil, color: SKColor.orange, size: slotSize)
            numberNodes.append(numberNode)
        }
    }

    func shuffleAndDisplayNumbers() {
        let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: numberNodes) as! [NumberNode]

        let playableArea = CGRect(x: frame.minX + 50, y: frame.midY - 100, width: frame.width - 100, height: frame.height / 2 - 50)

        for (index, node) in shuffledNumbers.enumerated() {
            // Distribute numbers randomly in the upper part of the screen
            let randomX = CGFloat.random(in: playableArea.minX...playableArea.maxX)
            let randomY = CGFloat.random(in: playableArea.minY...playableArea.maxY)
            node.position = CGPoint(x: randomX, y: randomY)
            node.originalPosition = node.position // Set initial random position as original
            addChild(node)
        }
    }

    func numberNodeDidEndDrag(_ numberNode: NumberNode) {
        var snapped = false
        for (index, slotRect) in targetSlots.enumerated() {
            if slotRect.contains(numberNode.position) {
                // Check if the slot is empty or if it's the current node's slot
                if placedNumbers[index] == nil || placedNumbers[index] == numberNode {
                    // Snap to the center of the slot
                    numberNode.run(SKAction.move(to: CGPoint(x: slotRect.midX, y: slotRect.midY), duration: 0.1))

                    // Remove from previous slot if it was in one
                    if let previousIndex = placedNumbers.firstIndex(where: { $0 == numberNode }), previousIndex != index {
                        placedNumbers[previousIndex] = nil
                    }
                    placedNumbers[index] = numberNode
                    snapped = true
                    break
                }
            }
        }

        if !snapped {
            // If not snapped to a valid slot, and it was previously in a slot, remove it
            if let previousIndex = placedNumbers.firstIndex(where: { $0 == numberNode }) {
                placedNumbers[previousIndex] = nil
            }
            // Optional: Snap back to original random position if not placed
            // numberNode.run(SKAction.move(to: numberNode.originalPosition, duration: 0.2))
        }

        checkWinCondition()
    }

    func checkWinCondition() {
        var correctCount = 0
        var allSlotsFilled = true
        for i in 0..<numbersToCount {
            if let placedNode = placedNumbers[i] {
                if placedNode.numberValue == i + 1 {
                    correctCount += 1
                }
            } else {
                allSlotsFilled = false // A slot is empty
            }
        }

        if allSlotsFilled && correctCount == numbersToCount {
            print("YOU WIN!")
            // Disable further interaction with numbers
            numberNodes.forEach { $0.isUserInteractionEnabled = false }
            showFireworks()
        }
    }

    func showFireworks() {
        if let fireworks = SKEmitterNode(fileNamed: "Fireworks.sks") { // Create this particle file
            fireworks.position = CGPoint(x: frame.midX, y: frame.midY)
            fireworks.zPosition = 200 // Make sure it's on top
            addChild(fireworks)

            // Add multiple bursts for a better effect
            let burstAction = SKAction.run {
                let burst = SKEmitterNode(fileNamed: "Fireworks.sks")!
                burst.position = CGPoint(
                    x: CGFloat.random(in: self.frame.minX + 50 ... self.frame.maxX - 50),
                    y: CGFloat.random(in: self.frame.minY + 50 ... self.frame.maxY - 50)
                )
                self.addChild(burst)
                self.run(SKAction.wait(forDuration: 0.8)) { // Remove burst after a delay
                    burst.removeFromParent()
                }
            }
            let sequence = SKAction.sequence([
                SKAction.repeat(burstAction, count: 5), // Show 5 bursts
                SKAction.wait(forDuration: 3.0) // Wait for fireworks to finish
            ])


            run(sequence) {
                // After fireworks, restart the game
                self.setupGame()
            }
        } else {
            print("Could not load Fireworks.sks")
            // Fallback if particle file isn't found
            let winLabel = SKLabelNode(text: "🎉 YOU WIN! 🎉")
            winLabel.fontSize = 40
            winLabel.fontColor = .red
            winLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            winLabel.zPosition = 200
            addChild(winLabel)
            run(SKAction.wait(forDuration: 3.0)) {
                winLabel.removeFromParent()
                self.setupGame()
            }
        }
    }

    // Handle touches outside of nodes (e.g., to deselect a node if needed)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This is called if a touch doesn't hit any interactive node
    }
}

