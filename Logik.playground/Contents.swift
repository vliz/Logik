import Foundation
import UIKit
import PlaygroundSupport
import AVFoundation

class InitialViewController: UIViewController {
    
    var imageView: UIImageView!
    var indicatorView: UIView!
    var guitarSound = URL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: "mp3") ?? "")
    var audioPlayer = AVAudioPlayer()
    var isOn = true
    var playMusicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        playMusic()
    }
    
    private func setupUI() {
        
        //change background color
        self.view.backgroundColor = .lightGray
        
        //add app logo
        let image = UIImage(named: "logo.png")
        imageView = UIImageView(image: image)
        rotateLogo(imageView: imageView, aCircleTime: 50)
        
        self.view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        let aspectRatioConstraint = NSLayoutConstraint(item: imageView!, attribute: .height, relatedBy: .equal,toItem: imageView, attribute: .width,multiplier: (1.0 / 1.0), constant: 0)
        imageView.addConstraint(aspectRatioConstraint)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        //add how to play button
        let howToPlayButton = UIButton(type: .custom)
        howToPlayButton.setTitle("How To Play", for: .normal)
        howToPlayButton.layer.borderWidth = 2
        howToPlayButton.layer.borderColor = UIColor.white.cgColor
        howToPlayButton.layer.cornerRadius = 10
        howToPlayButton.translatesAutoresizingMaskIntoConstraints = false
        howToPlayButton.titleLabel?.font = UIFont(name: "Palatino", size: 20)
        self.view.addSubview(howToPlayButton)
        
        NSLayoutConstraint.activate([
            howToPlayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            howToPlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            howToPlayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            howToPlayButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        howToPlayButton.addTarget(self, action: #selector(didTapHowToPlay), for: .touchUpInside)
        
        //add start button
        let startButton = UIButton(type: .custom)
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = UIColor.white
        startButton.setTitleColor(.darkGray, for: .normal)
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.cornerRadius = 10
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.titleLabel?.font = UIFont(name: "Palatino", size: 20)
        self.view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: howToPlayButton.topAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        // add music button
        playMusicButton = UIButton(type: .custom)
        playMusicButton.setImage(UIImage(named: "music_on.png"), for: .normal)
        playMusicButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playMusicButton)
        playMusicButton.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            playMusicButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playMusicButton.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
        ])
        
        playMusicButton.addTarget(self, action: #selector(didTapMusicButton), for: .touchUpInside)
        
    }
    
    func rotateLogo(imageView: UIImageView, aCircleTime: Double) {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2
        rotationAnimation.duration = aCircleTime
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: nil)
    }
    
    func playMusic() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: guitarSound)
            audioPlayer.play()
        } catch {
            print("couldn't load sound file")
        }
    }
    
    func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        
        if isOn {
            audioPlayer.play()
            playMusicButton.setImage(UIImage(named: "music_on.png"), for: .normal)
        } else {
            audioPlayer.stop()
            playMusicButton.setImage(UIImage(named: "music_off.png"), for: .normal)
        }
    }
    
    @objc func didTapMusicButton() {
        buttonPressed()
    }
    
    @objc private func didTapHowToPlay() {
        let howToPlayViewController = HowToPlayViewController()
        self.present(howToPlayViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapStart() {
        
        self.showActivity()
        DispatchQueue.main.async {
            let nextViewController = GameViewController()
            self.present(nextViewController, animated: true) {
                self.hideActivity()
            }
        }
    }
    
    func showActivity() {
        let activityView = UIView.init(frame: self.view.bounds)
        activityView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = activityView.center
        activityView.addSubview(activityIndicator)
        self.view.addSubview(activityView)
        
        self.indicatorView = activityView
    }
    
    func hideActivity() {
        self.indicatorView?.removeFromSuperview()
        self.indicatorView = nil
    }
}

// ----------------------------------------------------------------------------

class HowToPlayViewController: UIViewController {
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "howtoplay.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

// ----------------------------------------------------------------------------

class GameViewController : UIViewController {
    
    
    var showListView: UIScrollView!
    
    var checkerListImageView: [UIImageView] = []
    var numberInputView: [UIButton] = []
    var guessNumberLabel = UILabel()
    
    var allNumber = [Int](0...9)
    var userInput: [Int] = []
    var answerCheck = [Int]()
    var answerKey: [Int] = []
    
    var gridWidth: CGFloat = 0.0
    var listRow: CGFloat = 0.0
    var index = 0
    var guessCounter = 0
    var hasWon = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
        setupUI()
    }
    
    func startGame() {
        userInput = Array(repeating: 0, count: 3)
        answerCheck = Array(repeating: 0, count: 3)
        allNumber.shuffle()
        answerKey = Array(allNumber.prefix(3))
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = .white
        
        //setup grid view container
        showListView = UIScrollView(frame: CGRect.zero)
        showListView.flashScrollIndicators()
        guard let image = UIImage(named: "Artwork.png") else { return }
        showListView.backgroundColor = UIColor(patternImage: image)
        showListView.contentMode = .scaleToFill
        self.view.addSubview(showListView)
        
        NSLayoutConstraint.activate([
            showListView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            showListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            showListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            showListView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        let aspectRatioConstraint = NSLayoutConstraint(item: showListView!, attribute: .height, relatedBy: .equal,toItem: showListView, attribute: .width,multiplier: (1.0 / 1.0), constant: 0)
        showListView.addConstraint(aspectRatioConstraint)
        showListView.translatesAutoresizingMaskIntoConstraints = false
        
        gridWidth = (view.bounds.width - 100) / 9
        
        //setup number input imageview
        for num in 0...2 {
            let numberView = UIButton(frame: CGRect.zero)
            numberView.backgroundColor = .lightGray
            self.numberInputView.append(numberView)
            numberView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(numberView)
            
            numberView.layer.borderWidth = 2
            numberView.layer.borderColor = UIColor.white.cgColor
            numberView.layer.cornerRadius = 10
            numberView.contentMode = .scaleAspectFit
            numberView.isUserInteractionEnabled = false
            
            NSLayoutConstraint.activate([
                numberView.topAnchor.constraint(equalTo: showListView.bottomAnchor, constant: 10),
                numberView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0 + gridWidth + gridWidth * 1.5 * CGFloat(num)),
                numberView.widthAnchor.constraint(equalToConstant: gridWidth * 1.5),
                numberView.heightAnchor.constraint(equalToConstant: gridWidth * 1.5)
            ])
        }
        
        
        //add check button
        let checkButton = UIButton(type: .custom)
        checkButton.setTitle("Check", for: .normal)
        checkButton.backgroundColor = .gray
        checkButton.setTitleColor(.white, for: .normal)
        checkButton.layer.borderWidth = 2
        checkButton.layer.borderColor = UIColor.white.cgColor
        checkButton.layer.cornerRadius = 10
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.titleLabel?.font = UIFont(name: "Palatino", size: 20)
        self.view.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            checkButton.topAnchor.constraint(equalTo: showListView.bottomAnchor, constant: 63),
            checkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            checkButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        checkButton.addTarget(self, action: #selector(didTapCheck), for: .touchUpInside)
        
        // add number buttons
        for num in 0...9 {
            let numButton = UIButton(frame: CGRect.zero)
            numButton.backgroundColor = .darkGray
            numButton.translatesAutoresizingMaskIntoConstraints = false
            numButton.layer.borderWidth = 2
            numButton.layer.borderColor = UIColor.white.cgColor
            numButton.layer.cornerRadius = 10
            numButton.contentMode = .scaleAspectFit
            numButton.isUserInteractionEnabled = true
            self.view.addSubview(numButton)
            
            switch num {
            case 0:
                numButton.setTitle("0", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapZero))
                numButton.addGestureRecognizer(gesture)
            case 1:
                numButton.setTitle("1", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOne))
                numButton.addGestureRecognizer(gesture)
            case 2:
                numButton.setTitle("2", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTwo))
                numButton.addGestureRecognizer(gesture)
            case 3:
                numButton.setTitle("3", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapThree))
                numButton.addGestureRecognizer(gesture)
            case 4:
                numButton.setTitle("4", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapFour))
                numButton.addGestureRecognizer(gesture)
            case 5:
                numButton.setTitle("5", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapFive))
                numButton.addGestureRecognizer(gesture)
            case 6:
                numButton.setTitle("6", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSix))
                numButton.addGestureRecognizer(gesture)
            case 7:
                numButton.setTitle("7", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSeven))
                numButton.addGestureRecognizer(gesture)
            case 8:
                numButton.setTitle("8", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapEight))
                numButton.addGestureRecognizer(gesture)
            case 9:
                numButton.setTitle("9", for: .normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapNine))
                numButton.addGestureRecognizer(gesture)
            default:
                break
            }
            
            if num <= 4 {
                NSLayoutConstraint.activate([
                    numButton.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 10),
                    numButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25.0 + gridWidth + gridWidth * 1.75 * CGFloat(num)),
                    numButton.widthAnchor.constraint(equalToConstant: gridWidth * 1.75),
                    numButton.heightAnchor.constraint(equalToConstant: gridWidth * 1.75)
                ])
            } else {
                NSLayoutConstraint.activate([
                    numButton.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 20 + gridWidth * 1.5),
                    numButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25.0 + gridWidth + gridWidth * 1.75 * CGFloat(num-5)),
                    numButton.widthAnchor.constraint(equalToConstant: gridWidth * 1.75),
                    numButton.heightAnchor.constraint(equalToConstant: gridWidth * 1.75)
                ])
            }
        }
        
        // add number of guesses
        let guessLabel = UILabel(frame: CGRect.zero)
        guessLabel.text = "Guesses: "
        guessLabel.font = UIFont(name: "Palatino", size: 16)
        guessLabel.translatesAutoresizingMaskIntoConstraints = false
        guessLabel.textColor = .darkGray
        
        guessNumberLabel = UILabel(frame: CGRect.zero)
        guessNumberLabel.text = "\(guessCounter)"
        guessNumberLabel.font = UIFont(name: "Palatino", size: 28)
        guessNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        guessNumberLabel.textColor = .red
        
        self.view.addSubview(guessLabel)
        self.view.addSubview(guessNumberLabel)
        
        NSLayoutConstraint.activate([
            guessNumberLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            guessNumberLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
            guessLabel.trailingAnchor.constraint(equalTo: guessNumberLabel.leadingAnchor, constant: -5),
            guessLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
        ])
        
        // add back button
        let backButton = UIButton(frame: CGRect.zero)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Palatino", size: 18)
        backButton.backgroundColor = UIColor.red
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 5
        self.view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            backButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 70),
            backButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc func didTapZero() {
        if index <= 2 {
            userInput[index] = 0
            numberInputView[index].setTitle("0", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapOne() {
        if index <= 2 {
            userInput[index] = 1
            numberInputView[index].setTitle("1", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapTwo() {
        if index <= 2 {
            userInput[index] = 2
            numberInputView[index].setTitle("2", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapThree() {
        if index <= 2 {
            userInput[index] = 3
            numberInputView[index].setTitle("3", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapFour() {
        if index <= 2 {
            userInput[index] = 4
            numberInputView[index].setTitle("4", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapFive() {
        if index <= 2 {
            userInput[index] = 5
            numberInputView[index].setTitle("5", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapSix() {
        if index <= 2 {
            userInput[index] = 6
            numberInputView[index].setTitle("6", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapSeven() {
        if index <= 2 {
            userInput[index] = 7
            numberInputView[index].setTitle("7", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapEight() {
        if index <= 2 {
            userInput[index] = 8
            numberInputView[index].setTitle("8", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapNine() {
        if index <= 2 {
            userInput[index] = 9
            numberInputView[index].setTitle("9", for: .normal)
            index += 1
        }
    }
    
    @objc func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCheck() {
        if index < 3 {
            let alert = UIAlertController(title: "Please fill all 3 boxes", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            checkAnswer()
            for v in 0...2 {
                numberInputView[v].setTitle("", for: .normal)
            }
        }
    }
    
    func checkAnswer() {
        for i in 0..<userInput.count {
            if userInput[i] == answerKey[i] {
                answerCheck[i] = 1
            } else {
                var isCorrect = false
                for j in 0..<answerKey.count {
                    if userInput[i] == answerKey[j] {
                        isCorrect = true
                    }
                }
                if isCorrect {
                    answerCheck[i] = 2
                } else {
                    answerCheck[i] = 0
                }
            }
        }
        
        updateGrid()
        playerHasWon()
    }
    
    func updateGrid() {
        var numPosition: CGFloat = 0.0
        var checkPosition: CGFloat = 0.0
        
        // add number views
        for num in userInput {
            let lastInputView = UIButton(frame: CGRect.zero)
            lastInputView.backgroundColor = .lightGray
            lastInputView.translatesAutoresizingMaskIntoConstraints = false
            lastInputView.layer.borderWidth = 2
            lastInputView.layer.borderColor = UIColor.white.cgColor
            lastInputView.layer.cornerRadius = 10
            lastInputView.contentMode = .scaleAspectFit
            lastInputView.isUserInteractionEnabled = false
            self.showListView.addSubview(lastInputView)
            
            switch num {
            case 0:
                lastInputView.setTitle("0", for: .normal)
            case 1:
                lastInputView.setTitle("1", for: .normal)
            case 2:
                lastInputView.setTitle("2", for: .normal)
            case 3:
                lastInputView.setTitle("3", for: .normal)
            case 4:
                lastInputView.setTitle("4", for: .normal)
            case 5:
                lastInputView.setTitle("5", for: .normal)
            case 6:
                lastInputView.setTitle("6", for: .normal)
            case 7:
                lastInputView.setTitle("7", for: .normal)
            case 8:
                lastInputView.setTitle("8", for: .normal)
            case 9:
                lastInputView.setTitle("9", for: .normal)
            default:
                break
            }
            
            NSLayoutConstraint.activate([
                lastInputView.topAnchor.constraint(equalTo: showListView.topAnchor, constant: 10 + listRow),
                lastInputView.leadingAnchor.constraint(equalTo: showListView.leadingAnchor, constant: 10.0 + gridWidth * 1.75 * numPosition),
                lastInputView.widthAnchor.constraint(equalToConstant: gridWidth * 1.5),
                lastInputView.heightAnchor.constraint(equalToConstant: gridWidth * 1.5)
            ])
            
            numPosition += 1.0
        }
        
        // add checker views
        for num in answerCheck {
            let checkerView = UIImageView(frame: CGRect.zero)
            checkerView.translatesAutoresizingMaskIntoConstraints = false
            checkerView.contentMode = .scaleAspectFit
            self.showListView.addSubview(checkerView)
            
            switch num {
            case 0:
                checkerView.image = UIImage(named: "incorrect.png")
            case 1:
                checkerView.image = UIImage(named: "correct.png")
            case 2:
                checkerView.image = UIImage(named: "maybe.png")
            default:
                break
            }
            
            NSLayoutConstraint.activate([
                checkerView.topAnchor.constraint(equalTo: showListView.topAnchor, constant: 15 + listRow),
                checkerView.leadingAnchor.constraint(equalTo: showListView.centerXAnchor, constant: 50 + gridWidth * 1.25 * checkPosition),
                //               checkerView.leadingAnchor.constraint(equalTo: gridContainerView.leadingAnchor, constant: 20.0 + listWidth * 2.0 * CGFloat(num)),
                checkerView.widthAnchor.constraint(equalToConstant: gridWidth),
                checkerView.heightAnchor.constraint(equalToConstant: gridWidth)
            ])
            
            checkPosition += 1.0
        }
    }
    
    func playerHasWon() {
        hasWon = answerCheck.allSatisfy { $0 == 1}
        
        if hasWon == true {
            let alert = UIAlertController(title: "You Win", message: "Congratulations! You are amazing! Play this game again?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Again", style: .default, handler: { (_) in
                self.restartGame()
            }))
            alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            resetPlay()
        }
    }
    
    func resetPlay() {
        index = 0
        listRow += gridWidth * 1.75
        guessCounter += 1
        guessNumberLabel.text = "\(guessCounter)"
    }
    
    func restartGame() {
        
        listRow = 0.0
        index = 0
        guessCounter = 0
        hasWon = false
        guessNumberLabel.text = "\(guessCounter)"
        self.view.setNeedsLayout()
        
        for view in showListView.subviews {
            view.removeFromSuperview()
        }
        startGame()
    }
}

// Start Playground
PlaygroundPage.current.liveView = InitialViewController()



// Created by:
// Agnes Felicia Loho
// nicole.agnes.felicia@gmail.com
// for WWDC Student Challenge 2020

// Images, Artwork, and Music all created by me
// using Figma, Sketch, Procreate, and GarageBand


