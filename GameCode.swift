/*
 BOUNCY BALL APP
 PADEN GARRARD
 SEPTEMBER 26 2021
 */
import Foundation

// BUILDING BLOCK CODE
let ball = OvalShape(width: 40,height: 40)

var barriers: [Shape] = []

let funnelPoints = [
        Point(x: 0, y: 50),
        Point(x: 80, y: 50),
        Point(x: 60, y: 0),
        Point(x: 20, y: 0)
    ]

let funnel = PolygonShape(points: funnelPoints)

func ballCollided(with otherShape: Shape) {
     if otherShape.name != "target" { return }
     otherShape.fillColor = .green
}

var targets: [Shape] = []

func printPosition(of shape: Shape) {
    print(shape.position)
}


// BALL SETUP
fileprivate func setupBall() {
    ball.position = Point(x: 250, y:400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    scene.trackShape(ball)
    ball.onExitedScene = ballExcitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.6
}


// BARRIER SETUP
fileprivate func addBarrier(at position:
        Point, width: Double, height: Double,
        angel: Double) {
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    
    let barrier = PolygonShape(points: barrierPoints)
    
    barriers.append(barrier)
        
    barrier.position = position
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.angle = angel
}


// FUNNEL SETUP
fileprivate func setupFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    func dropBall() {
        ball.position = funnel.position
        ball.stopAllMotion()
        for barrier in barriers {
            barrier.isDraggable = false
        }
        for target in targets {
            target.fillColor = .yellow
        }
    }
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
    funnel.isDraggable = false
}


//TARGET SETUP
func addTarget(at position: Point) {
   let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
        ]
    
    let target = PolygonShape(points:
           targetPoints)
    
    targets.append(target)
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
    //target.isDraggable = false
}


// BALL EXCIT FUNC
func ballExcitedScene () {
    for barrier in barriers {
        barrier.isDraggable = true
    }
    var hitTargets = 0
        for target in targets {
            if target.fillColor == .green {
                hitTargets += 1
            }
        }
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!",
            completion: alertDismissed)
    }
    func alertDismissed() {
    }
}

// GAME RESTART
func resetGame () {
    ball.position = Point(x: 0, y: -80)
}
    

// FINAL APP SETUP
func setup() {
    setupBall()
    
    setupFunnel()
   
    addBarrier(at: Point(x: 200, y: 150), width: 80,
       height: 25, angel: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 30,
       height: 15, angel: -0.2)
    addBarrier(at: Point(x: 300, y: 150), width: 100,
       height: 25, angel: 0.4)
    
    addTarget(at: Point(x: 133, y: 614))
    addTarget(at: Point(x: 111, y: 474))
    addTarget(at: Point(x: 256, y: 280))
    addTarget(at: Point(x: 151, y: 242))
    addTarget(at: Point(x: 165, y: 40))

    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
}
