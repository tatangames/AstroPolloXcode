//
//  SplashController.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 26/5/23.
//
import UIKit
import Lottie

class SplashController: UIViewController {
    
   
    @IBOutlet weak var onboardingLottieView: LottieAnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        /*for family in UIFont.familyNames {
            print(family)
            for name in UIFont.fontNames(forFamilyName: family){
                print(name)
            }
        }*/
        
        
        setupAnimation();
        
        // TIMER
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.performSegue(withIdentifier: "OpenLogin", sender: nil)
        }
        
            
        
        //onboardingLottieView.animation = LottieAnimation.named("splash_hamburger.json")
       // onboardingLottieView.play()
        
    }
    
    private func setupAnimation(){
  
        onboardingLottieView.contentMode = .scaleAspectFit
        onboardingLottieView.loopMode = .loop
        
        onboardingLottieView.play()
        
        
        
    }


}
