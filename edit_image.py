import sys
from PIL import Image, ImageDraw, ImageFont

image_path = sys.argv[1]
output_path = sys.argv[2]
text_to_add = "smart grocery tracker"

try:
    img = Image.open(image_path).convert('RGB')
    w, h = img.size
    
    draw = ImageDraw.Draw(img)
    
    # The text is between row 215 and 255. 
    # Let's white out from row 205 down to the bottom
    draw.rectangle([0, 205, w, h], fill=(255, 255, 255))
    
    # Try to load a font
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 26)
    except IOError:
        font = ImageFont.load_default()
        
    # main green color found: (160, 216, 179)
    color = (160, 216, 179)
    
    # calculate text size to center it
    # getbbox returns (left, top, right, bottom)
    bbox = font.getbbox(text_to_add)
    text_w = bbox[2] - bbox[0]
    text_h = bbox[3] - bbox[1]
    
    x = (w - text_w) / 2
    y = 215 # Roughly where the original text was
    
    draw.text((x, y), text_to_add, font=font, fill=color)
    
    img.save(output_path)
    print(f"Saved {output_path}")
except Exception as e:
    print(e)
