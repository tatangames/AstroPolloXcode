//
//  TextFieldImagen.swift
//  AstroPollo
//
//  Created by Jonathan  Moran on 27/5/23.
//

import Foundation
import UIKit

@IBDesignable
class TextFieldImagen: UITextField {
    
    private var kAssociationKeyMaxLength: Int = 0
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    // para agregar imagen al text field.
    func updateView(){
        
        if let image = leftImage {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            
            imageView.image = image
            
            leftView = imageView
        } else {
            leftViewMode = .never
        }
    }
    
    
}
