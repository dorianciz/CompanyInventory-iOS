//
//  ARInventoryViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 7/2/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit

class ARInventoryViewController: UIViewController {

    @IBOutlet weak var arSceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBox()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureARSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arSceneView.session.pause()
    }
    
    private func configureARSceneView() {
        let arConfiguration = ARWorldTrackingConfiguration()
        arSceneView.session.run(arConfiguration)
    }
    
    private func addBox() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.red
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0,0,-0.2)

        let text = SCNText()
        text.firstMaterial?.diffuse.contents = UIColor.blue
        text.string = "Some text"
        
        let viewasd = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        viewasd.backgroundColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        
        let plane = SCNPlane()
        plane.firstMaterial?.diffuse.contents = viewasd
        
        let textNode = SCNNode()
        textNode.geometry = plane
        textNode.position = SCNVector3(0,0,-0.2)
        
        
        let scene = SCNScene()
//        scene.rootNode.addChildNode(boxNode)
        scene.rootNode.addChildNode(textNode)

        arSceneView.scene = scene
    }

}
