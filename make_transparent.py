from PIL import Image

def remove_background(image_path, output_path):
    img = Image.open(image_path).convert("RGBA")
    datas = img.getdata()

    newData = []
    # Loop over every pixel
    for item in datas:
        # Check if the pixel is near-white (background)
        # item is (R, G, B, A)
        if item[0] > 240 and item[1] > 240 and item[2] > 240:
            # Change white (also shades of white) to transparent
            newData.append((255, 255, 255, 0))
        else:
            newData.append(item)

    img.putdata(newData)
    
    # Try to crop the transparency, getting the actual bounding box of the logo
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
        
    img.save(output_path, "PNG")

remove_background("assets/images/logo.png", "assets/images/logo.png")
print("Background removed and image cropped to contents.")
