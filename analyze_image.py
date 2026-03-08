import sys
from PIL import Image

image_path = sys.argv[1]
try:
    img = Image.open(image_path)
    print(f"Size: {img.size}, Mode: {img.mode}")
    # find non-white pixels
    w, h = img.size
    pixels = img.load()
    colors = {}
    
    for y in range(h):
        for x in range(w):
            p = pixels[x, y]
            if img.mode == 'RGB':
                r, g, b = p
                # if not white
                if r < 250 or g < 250 or b < 250:
                    colors[(r,g,b)] = colors.get((r,g,b), 0) + 1
            elif img.mode == 'RGBA':
                r, g, b, a = p
                if a > 0 and (r < 250 or g < 250 or b < 250):
                    colors[(r,g,b)] = colors.get((r,g,b), 0) + 1
                    
    sorted_colors = sorted(colors.items(), key=lambda item: item[1], reverse=True)
    print(f"Top 5 non-white colors: {sorted_colors[:5]}")
    
    # Try to find the bounding box of the top part (the logo) and the bottom part (the text)
    # We can assume the text is horizontally centered near the bottom
    # We will look for horizontal gaps (all white lines)
    row_has_pixels = []
    for y in range(h):
        has_pixel = False
        for x in range(w):
            p = pixels[x, y]
            r, g, b = p[:3]
            if r < 250 or g < 250 or b < 250:
                has_pixel = True
                break
        row_has_pixels.append(has_pixel)
        
    print("Row pixel blocks:")
    in_block = False
    start = -1
    for y, has_p in enumerate(row_has_pixels):
        if has_p and not in_block:
            in_block = True
            start = y
        elif not has_p and in_block:
            in_block = False
            print(f"Block: {start} to {y - 1}")
    if in_block:
        print(f"Block: {start} to {h - 1}")
        
except Exception as e:
    print(e)
