//
//  ViewController.swift
//  Egoist_Material
//
//  Created by Motoki Onayama on 2021/10/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        var scenes = SCNScene()
        
        /// dae → scn に変換する必要がある
        scenes = SCNScene(named: "art.scnassets/chelly_material.scn")!
        
            //scenes.rootNode.name = "chelly"
            //scenes.rootNode.scale = SCNVector3(0.001, 0.001, 0.001)
            //sceneView.scene.rootNode.addChildNode(scenes.rootNode)
        
        // Set the scene to the view
        sceneView.scene = scenes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // タッチした最初の座標を取り出す
            guard let touch = touches.first else { return }

            // タッチで取得した座標をスクリーン座標系に変換
            let touchPosition = touch.location(in: sceneView)

            //これより下がhitTest(_:types:)の代わりのコード
            guard let query = sceneView.raycastQuery(from: touchPosition, allowing: .existingPlaneGeometry, alignment: .any) else { return }
            let results = sceneView.session.raycast(query)
            guard let hitTestResult = results.first else {
                print("no surface found")
                return
            }
            let anchor = ARAnchor(transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
