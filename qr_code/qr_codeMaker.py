import qrcode
import qrcode.constants
def generate_code(url, file_name):
    if not file_name.lower().endswith(('.png', '.jpg', '.jpeg')):
        print("Error producing QR Code")
    else:    
        qr = qrcode.QRCode(
            version=1,
            box_size = 20,
            border = 4
        )
        qr.add_data(url)
        qr.make(fit=True)
        img = qr.make_image(fill_color="#333")
        img.save(file_name)
        return True
        
text = input("Enter url to generate Code: ").upper()

file_name = input("Enter name of File to be saved as (ex img.jpg): ")
generate_code(text,file_name)


