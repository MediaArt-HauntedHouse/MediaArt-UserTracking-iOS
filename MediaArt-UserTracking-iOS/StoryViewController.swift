//
//  StoryViewController.swift
//  MediaArt-UserTracking-iOS
//
//  Created by Masaki Kobayashi on 2014/10/28.
//  Copyright (c) 2014年 Masaki Kobayashi. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    @IBOutlet weak var storyTextView: UITextView!

    typealias storiesType = Dictionary<String, String>
    
    var storyIndex: Int = 0
    let stories: [storiesType] = [
        [
            "story": "0"
        ],
        [
            "story": "1"
        ],
        [
            "story": "2"
        ],
        [
            "story": "3"
        ],
        [
            "story": "4"
        ],
        [
            "story": "5"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.storyTextView.text = stories[storyIndex]["story"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
