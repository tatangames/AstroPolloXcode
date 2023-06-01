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
        
        setupAnimation();
        
        // TIMER
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
          
            
            // verificacion si ya inicio sesion
           if let usuarioid = UserDefaults.standard.getValueIdUsuario(), !usuarioid.isEmpty {
            
               
               let vista : TabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
               
               self.present(vista, animated: true, completion: nil)
           }
           else {
               
               let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
                       
               self.present(vista, animated: true, completion: nil)
            }
        }
        
   
    }
    
    
    
    private func setupAnimation(){
  
        onboardingLottieView.contentMode = .scaleAspectFit
        onboardingLottieView.loopMode = .loop
        
        onboardingLottieView.play()
        
        
        
    }


}
