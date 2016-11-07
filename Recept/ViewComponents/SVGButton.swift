//
//  DrawerButton.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-06.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class SVGButton: UIButton {
    var svgImageView: SVGKLayeredImageView?
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
        
        svgImageView = SVGKLayeredImageView(frame: self.bounds)
        self.setTitle("", for: UIControlState())
        self.addSubview(self.svgImageView!)
        self.svgImageView!.isUserInteractionEnabled = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        svgImageView = SVGKLayeredImageView(frame: self.bounds)
        self.setTitle("", for: UIControlState())
        self.addSubview(self.svgImageView!)
        self.svgImageView!.isUserInteractionEnabled = false
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.svgImageView?.frame = rect
    }
    
    func setSvgImage(_ svgImage: SVGKImage?, forState state: UIControlState) {
        guard svgImage != nil else {
            self.setImage(nil, for: state)
            return
        }
        self.svgImageView!.image = svgImage
    }
}
