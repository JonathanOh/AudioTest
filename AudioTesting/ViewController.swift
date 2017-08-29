//
//  ViewController.swift
//  AudioTesting
//
//  Created by admin on 8/28/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    let playButton = UIButton()
    let recordButton = UIButton()
    let stopButton = UIButton()
    
    var soundRecorder: AVAudioRecorder?
    var soundPlayer: AVAudioPlayer?
    var fileName = "audioFile.caf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupButtons()
    }
    
    func setupRecorder() {
        let recordSettings = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ] as [String : Any]
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            soundRecorder = try AVAudioRecorder(url: getFileURL(), settings: recordSettings)
            soundRecorder?.delegate = self
            soundRecorder?.record()
            //soundRecorder?.prepareToRecord()
        } catch {
            print("something wrong")
        }
    }
    
    func setupPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            soundPlayer = try AVAudioPlayer(contentsOf: getFileURL())
            print(getFileURL())
            soundPlayer?.delegate = self
            soundPlayer?.volume = 1.0
            soundPlayer?.prepareToPlay()
        } catch {
            print(error)
            print(error.localizedDescription)
            print("setting up player failed!")
        }
    }
    
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFileName = paths[0].appendingPathComponent(fileName)
        return audioFileName
    }

    func setupButtons() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        
        playButton.setTitle("Play", for: .normal)
        recordButton.setTitle("Record", for: .normal)
        stopButton.setTitle("Stop", for: .normal)
        
        playButton.backgroundColor = .red
        recordButton.backgroundColor = .red
        stopButton.backgroundColor = .red
        
        view.addSubview(playButton)
        view.addSubview(recordButton)
        view.addSubview(stopButton)
        
        // let thisConstraint = playButton(anchor: .x to:
//        let playButtonCenterXAnchor = playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)
//        let playButtonTopAnchor = playButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0)
//        let playButtonWidthAnchor = playButton.widthAnchor.constraint(equalToConstant: 200.0)
//        let playButtonHeightAnchor = playButton.heightAnchor.constraint(equalToConstant: 50.0)
        playButton.constrain(
            anchorOne: .x, toAnchorOne: view.centerXAnchor, anchorOneConstant: nil,
            anchorTwo: .top, toAnchorTwo: view.topAnchor, anchorTwoConstant: 100.0,
            anchorThree: .width, toAnchorThree: view.centerXAnchor, anchorThreeConstant: 200.0,
            anchorFour: .height, toAnchorFour: view.centerYAnchor, anchorFourConstant: 50.0
        )
        
        let recordButtonCenterXAnchor = recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)
        let recordButtonTopAnchor = recordButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10.0)
        let recordButtonWidthAnchor = recordButton.widthAnchor.constraint(equalToConstant: 200.0)
        let recordButtonHeightAnchor = recordButton.heightAnchor.constraint(equalToConstant: 50.0)
        
        let stopButtonCenterXAnchor = stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)
        let stopButtonTopAnchor = stopButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 10.0)
        let stopButtonWidthAnchor = stopButton.widthAnchor.constraint(equalToConstant: 200.0)
        let stopButtonHeightAnchor = stopButton.heightAnchor.constraint(equalToConstant: 50.0)

        NSLayoutConstraint.activate([
//                playButtonCenterXAnchor,
//                playButtonTopAnchor,
//                playButtonWidthAnchor,
//                playButtonHeightAnchor,
                recordButtonCenterXAnchor,
                recordButtonTopAnchor,
                recordButtonWidthAnchor,
                recordButtonHeightAnchor,
                stopButtonCenterXAnchor,
                stopButtonTopAnchor,
                stopButtonWidthAnchor,
                stopButtonHeightAnchor
            ])
        
    }
    
    func playButtonTapped() {
        print("play tapped")
        setupPlayer()
        soundPlayer?.play()
        
    }
    func recordButtonTapped() {
        print("record tapped")
        setupRecorder()
        soundRecorder?.record()
    }
    func stopButtonTapped() {
        print("stop tapped")
        soundRecorder?.stop()
    }

}

extension UIView {
    enum ConstraintAnchors {
        case x
        case y
        case top
        case bottom
        case left
        case right
        case width
        case height
    }
    func constrain(anchorOne: ConstraintAnchors, toAnchorOne: NSLayoutXAxisAnchor, anchorOneConstant: CGFloat?,
                   anchorTwo: ConstraintAnchors, toAnchorTwo: NSLayoutYAxisAnchor, anchorTwoConstant: CGFloat?,
                   anchorThree: ConstraintAnchors, toAnchorThree: NSLayoutXAxisAnchor, anchorThreeConstant: CGFloat?,
                   anchorFour: ConstraintAnchors, toAnchorFour: NSLayoutYAxisAnchor, anchorFourConstant: CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let relatedAnchors = [toAnchorOne, toAnchorTwo, toAnchorThree, toAnchorFour]
        let relatedConstants = [anchorOneConstant, anchorTwoConstant, anchorThreeConstant, anchorFourConstant]
        var constraintsToActivate = [NSLayoutConstraint]()
        for (index, anchor) in [anchorOne, anchorTwo, anchorThree,anchorFour].enumerated() {
            switch anchor {
            case .x:
                constraintsToActivate.append(self.centerXAnchor.constraint(equalTo: relatedAnchors[index] as! NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: relatedConstants[index] ?? 0.0))
            case .y:
                constraintsToActivate.append(self.centerYAnchor.constraint(equalTo: relatedAnchors[index] as! NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: relatedConstants[index] ?? 0.0))
            case .top:
                constraintsToActivate.append(self.topAnchor.constraint(equalTo: relatedAnchors[index] as! NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: relatedConstants[index] ?? 0.0))
            case .bottom:
                constraintsToActivate.append(self.bottomAnchor.constraint(equalTo: relatedAnchors[index] as! NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: relatedConstants[index] ?? 0.0))
            case .left:
                constraintsToActivate.append(self.leftAnchor.constraint(equalTo: relatedAnchors[index] as! NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: relatedConstants[index] ?? 0.0))
            case .right:
                constraintsToActivate.append(self.rightAnchor.constraint(equalTo: relatedAnchors[index] as! NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: relatedConstants[index] ?? 0.0))
            case .width:
                constraintsToActivate.append(self.widthAnchor.constraint(equalToConstant: relatedConstants[index] ?? 0.0))
            case .height:
                constraintsToActivate.append(self.heightAnchor.constraint(equalToConstant: relatedConstants[index] ?? 0.0))
            }
        }
        NSLayoutConstraint.activate(constraintsToActivate)
    }
}

