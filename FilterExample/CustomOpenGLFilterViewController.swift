import UIKit

class CustomOpenGLFilterViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var beginImage: CIImage!
    var context: CIContext!
    var filter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginImage = CIImage(image: UIImage(named: "milk")!)
        self.context = CIContext(options: nil)

        let kernelString =
            "kernel vec4 chromaKey( __sample s) { \n" +
                "  vec4 newPixel = s.rgba;" +
                "  newPixel[0] = 0.0;" +
                "  newPixel[2] = newPixel[2] / 2.0;" +
                "  return newPixel;\n" +
        "}"

        let kernel = CIColorKernel(source: kernelString)!
        let output = kernel.apply(extent: beginImage.extent, arguments: [beginImage as Any])!

        if let cgimg = context.createCGImage(output, from: output.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imgView.image = processedImage
        }
    }
}
