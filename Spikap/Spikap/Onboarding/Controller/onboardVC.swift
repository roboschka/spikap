//
//  onboardVC.swift
//  Spikap
//
//  Created by Aries Dwi Prasetiyo on 10/07/20.
//  Copyright © 2020 Aries Dwi Prasetiyo. All rights reserved.
//

import UIKit

class onboardVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Post.createPosts(postID: UUID().uuidString, postTitle: "Test Title", postAudio: "Test Audio", postLikes: 59, userID: UUID().uuidString)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
